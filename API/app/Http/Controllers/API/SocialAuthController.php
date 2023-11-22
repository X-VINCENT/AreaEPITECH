<?php

namespace App\Http\Controllers\API;

use App\Http\Controllers\API\BaseController as BaseController;
use App\Models\User;
use DateInterval;
use DateTime;
use Exception;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Laravel\Socialite\Facades\Socialite;

class SocialAuthController extends BaseController
{
    public array $providers = [
        'google',
        'github',
        'gitlab',
        'stackexchange',
        'microsoft',
    ];

    public array $scopes = [
        'google' => [
            'https://www.googleapis.com/auth/calendar',
            'https://www.googleapis.com/auth/docs',
            'https://www.googleapis.com/auth/drive',
            'https://mail.google.com',
        ],
        'github' => [
            'repo',
            'read:user',
            'project',
            'notifications'
        ],
        'gitlab' => [
            'read_repository',
            'read_user',
            'api',
            'write_repository',
            'profile',
            'email'
        ],
        'stackexchange' => [
            'read_inbox',
            'no_expiry',
            'write_access',
            'private_info',
        ],
        'microsoft' => [
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
        ]
    ];

    public function redirect(Request $request): JsonResponse
    {
        $provider = $request->provider;

        if (!in_array($provider, $this->providers)) {
            return $this->sendError('Provider not found');
        }

        $scopes = $this->scopes[$provider] ?? [];

        $url = Socialite::driver($provider)->scopes($scopes)->stateless()->redirect()->getTargetUrl();

        if ($provider === 'google')
            $url .= '&access_type=offline&prompt=consent';

        return $this->sendResponse(['url' => $url], 'Redirect url retrieved successfully.');
    }

    /**
     * @throws Exception
     */
    public function callback(Request $request): JsonResponse
    {
        $provider = $request->provider;
        $token = $request->query('token');

        if (!in_array($provider, $this->providers))
            return $this->sendError('Provider not found');

        try {
            if (isset($token))
                $user = Socialite::driver($provider)->stateless()->userFromToken($token);
            else
                $user = Socialite::driver($provider)->stateless()->user();
        } catch (Exception $e) {
            return $this->sendError('Error retrieving user', $e, 500);
        }

        $request_user = $request->user();

        $user_in_db = $request_user ?? User::where('email', $user->email)->first();

        if (!isset($user_in_db)) {
            $user_in_db = User::create([
                'name' => $user->name,
                'email' => $user->email,
                'password' => '',
            ]);
        } else if (isset($request_user) && $request_user->id !== $user_in_db->id) {
            return $this->sendError('User already exists', "", 409);
        }

        $user_in_db[$provider . '_id'] = $user->id;
        $user_in_db[$provider . '_token'] = $user->token;
        $user_in_db[$provider . '_refresh_token'] = $user->refreshToken;
        if (isset($user->expiresIn)) {
            $expires_at = new DateTime();
            $expires_at->add(new DateInterval('PT' . $user->expiresIn . 'S'));
            $user_in_db[$provider . '_expires_at'] = $expires_at;
        }
        $user_in_db->save();
        $token = $user_in_db->createToken($provider . '_token')->accessToken;

        return $this->sendResponse([
            'user' => $user_in_db,
            'token' => $token,
        ], 'User retrieved successfully.');
    }

    /**
     * @throws Exception
     */
    public function disconnect(Request $request): JsonResponse
    {
        $provider = $request->provider;

        if (!in_array($provider, $this->providers))
            return $this->sendError('Provider not found');

        $request_user = $request->user();

        $user_in_db = $request_user ?? User::where('email', $user->email)->first();

        if (!isset($user_in_db))
            return $this->sendError('User not found', "");

        $user_in_db[$provider . '_id'] = null;
        $user_in_db[$provider . '_token'] = null;
        $user_in_db[$provider . '_refresh_token'] = null;
        $user_in_db[$provider . '_expires_at'] = null;
        $user_in_db->save();

        return $this->sendResponse([
            'user' => $user_in_db,
        ], 'Successfully disconnected from ' . $provider . '.');
    }
}
