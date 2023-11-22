<?php

namespace App\Models;

use DateInterval;
use DateTime;
use Exception;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Foundation\Auth\User as Authenticatable;
use Illuminate\Notifications\Notifiable;
use Illuminate\Support\Facades\Http;
use Illuminate\Support\Facades\Schema;
use Laravel\Passport\HasApiTokens;

class User extends Authenticatable
{
    use HasApiTokens, HasFactory, Notifiable;

    /**
     * The attributes that are mass assignable.
     *
     * @var array<int, string>
     */
    protected $fillable = [
        'name',
        'email',
        'password',
    ];

    /**
     * The attributes that should be hidden for serialization.
     *
     * @var array<int, string>
     */
    protected $hidden = [
        'password',
        'remember_token',
        'google_token',
        'google_refresh_token',
        'google_expires_at',
        'github_token',
        'github_refresh_token',
        'github_expires_at',
        'gitlab_token',
        'gitlab_refresh_token',
        'gitlab_expires_at',
        'stackexchange_token',
        'stackexchange_refresh_token',
        'stackexchange_expires_at',
        'microsoft_token',
        'microsoft_refresh_token',
        'microsoft_expires_at',
    ];

    /**
     * The attributes that should be cast.
     *
     * @var array<string, string>
     */
    protected $casts = [
        'email_verified_at' => 'datetime',
    ];

    /**
     * Check if the user has a specific role.
     *
     * @param string $role
     * @return bool
     */
    public function hasRole(string $role): bool
    {
        $roles = explode(',', $this->roles);
        return in_array($role, $roles);
    }

    public function isConnectedToService(int $serviceId): bool
    {
        $services = Service::all();
        $service = $services->where('id', $serviceId)->first();

        $has_column = Schema::hasColumn($this->getTable(), $service->key . '_id');

        if (!isset($service))
            return false;

        if (!$has_column)
            return true;

        return strlen($this[$service->key . '_id']) > 0;
    }

    /**
     * @throws Exception
     */
    public function checkAccessTokenExpiration(string $provider): bool
    {
        $expires_at = new DateTime($this[$provider . '_expires_at']);
        $now = new DateTime();

        return $expires_at > $now;
    }

    /**
     * @throws Exception
     */
    public function getNewAccessToken(string $provider): string
    {
        $data = match ($provider) {
            'google' => $this->getNewGoogleAccessToken(),
            'gitlab' => $this->getNewGitLabAccessToken(),
            'microsoft' => $this->getNewMicrosoftAccessToken(),
            default => throw new Exception('Provider not found'),
        };

        $token = $data['access_token'];
        $expires_in = $data['expires_in'];

        $this[$provider . '_token'] = $token;
        $expires_at = new DateTime();
        $expires_at->add(new DateInterval('PT' . $expires_in . 'S'));
        $this[$provider . '_expires_at'] = $expires_at;
        $this->save();

        return $token;
    }

    /**
     * @throws Exception
     */
    public function getNewGoogleAccessToken(): array
    {
        $response = Http::asForm()->post('https://oauth2.googleapis.com/token', [
            'client_id' => env('GOOGLE_CLIENT_ID'),
            'client_secret' => env('GOOGLE_CLIENT_SECRET'),
            'refresh_token' => $this->google_refresh_token,
            'grant_type' => 'refresh_token',
        ]);

        if (!$response->successful())
            throw new Exception('Error refreshing Google token');

        $json = $response->json();

        return [
            'access_token' => $json['access_token'],
            'expires_in' => $json['expires_in'],
        ];
    }

    /**
     * @throws Exception
     */
    public function getNewGitlabAccessToken(): array
    {
        $response = Http::asForm()->post('https://gitlab.com/oauth/token', [
            'client_id' => env('GITLAB_CLIENT_ID'),
            'client_secret' => env('GITLAB_CLIENT_SECRET'),
            'refresh_token' => $this->gitlab_refresh_token,
            'grant_type' => 'refresh_token',
            'redirect_uri' => env('GITLAB_REDIRECT_URI'),
        ]);

        if (!$response->successful())
            throw new Exception('Error refreshing GitLab token');

        $json = $response->json();

        return [
            'access_token' => $json['access_token'],
            'expires_in' => $json['expires_in'],
        ];
    }

    /**
     * @throws Exception
     */
    public function getNewMicrosoftAccessToken(): array
    {
        $scopes = [
            'Calendars.ReadWrite',
            'Chat.ReadWrite',
            'email',
            'Files.ReadWrite.All',
            'Mail.Read',
            'Mail.Send',
            'Notes.Create',
            'Notes.ReadWrite.All',
            'Notifications.ReadWrite.CreatedByApp',
            'offline_access',
            'openid',
            'profile',
            'ShortNotes.ReadWrite',
            'Tasks.ReadWrite',
            'User.ReadBasic.All',
            'User.ReadWrite',
        ];
        $response = Http::asForm()->post('https://login.microsoftonline.com/common/oauth2/v2.0/token', [
            'client_id' => env('MICROSOFT_CLIENT_ID'),
            'client_secret' => env('MICROSOFT_CLIENT_SECRET'),
            'scope' => implode(' ', $scopes),
            'refresh_token' => $this->microsoft_refresh_token,
            'grant_type' => 'refresh_token',
        ]);

        if (!$response->successful())
            throw new Exception('Error refreshing Microsoft token');

        $json = $response->json();

        return [
            'access_token' => $json['access_token'],
            'expires_in' => $json['expires_in'],
        ];
    }
}
