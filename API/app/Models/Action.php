<?php

namespace App\Models;

use Exception;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Support\Facades\Http;

class Action extends Model
{
    use HasFactory;

    /**
     * The attributes that are mass assignable.
     *
     * @var array<int, string>
     */
    protected $fillable = [
        'service_id',
        'key',
        'name',
        'description',
        'config_keys'
    ];

    /**
     * @throws Exception if action not found
     */
    public function execute(User $user, mixed $config, ?string $last_executed): ?string
    {
        $key = $this->key;
        $service = Service::find($this->service_id);

        if (!isset($service)) {
            throw new Exception('Service not found');
        }

        $usable = $user->isConnectedToService($this->service_id);
        if (!$usable ?? false) {
            throw new Exception('You cannot use this action. Please, check your connection to the service.');
        }
        return match ($key) {
            'receiveMail' => $this->receiveMail($user, $last_executed),
            'higherTemp' => $this->higherTemp($config),
            'lowerTemp' => $this->lowerTemp($config),
            'higherHumidity' => $this->higherHumidity($config),
            'lowerHumidity' => $this->lowerHumidity($config),
            'higherWindSpeed' => $this->higherWindSpeed($config),
            'lowerWindSpeed' => $this->lowerWindSpeed($config),
            'higherPrecipitation' => $this->higherPrecipitation($config),
            'lowerPrecipitation' => $this->lowerPrecipitation($config),
            'lastHourNews' => $this->lastHourNews($config),
            'assignedToGitHubIssue' => $this->assignedToGitHubIssue($user, $config),
            'assignedToGitlabIssue' => $this->assignedToGitlabIssue($user, $config),
            'commitMadeOnGitHubRepo' => $this->commitMadeOnGitHubRepo($user, $config, $last_executed),
            'commitMadeOnGitLabRepo' => $this->commitMadeOnGitLabRepo($user, $config, $last_executed),
            'receiveMailOutlook' => $this->receiveMailOutlook($user, $last_executed),
            default => throw new Exception("Action {$key} not found"),
        };
    }

    /**
     * @throws Exception
     */
    protected function receiveMail(User $user, ?string $last_executed): ?string
    {
        $token = $user->google_token;

        if (!$user->checkAccessTokenExpiration('google'))
            $token = $user->getNewAccessToken('google');

        $response = Http::withToken($token)->get('https://gmail.googleapis.com/gmail/v1/users/me/messages');
        $mails = $response->json()['messages'];

        if (count($mails) === 0)
            return null;

        $output = '';
        $mailsCount = 0;

        foreach ($mails as $mail) {
            $message_id = $mail['id'];

            $response = Http::withToken($token)->get("https://gmail.googleapis.com/gmail/v1/users/me/messages/{$message_id}?format=full");
            $message = $response->json();
            $headers = $message['payload']['headers'];

            $from = '';
            $subject = '';
            $date = '';

            foreach ($headers as $header) {
                if ($header['name'] === 'From')
                    $from = $header['value'];

                if ($header['name'] === 'Subject')
                    $subject = $header['value'];

                if ($header['name'] === 'Date')
                    $date = $header['value'];
            }

            $date = strtotime($date);
            $formattedDate = date('Y-m-d H:i:s', $date);
            $lastExecuted = strtotime($last_executed);
            $diff = $date - $lastExecuted;

            if ($diff <= 0)
                continue;

            $mailsCount++;

            $content = $message['snippet'];

            $output .= "From: $from\n";
            $output .= "Subject: $subject\n";
            $output .= "Date: $formattedDate\n";
            $output .= "Content: $content\n\n";
        }

        if ($mailsCount === 0)
            return null;

        $prefix = $mailsCount === 1 ? '1 mail found:' : "$mailsCount mails found:";
        $output2 = "$prefix\n\n";
        $output2 .= $output;

        return $output2;
    }

    /**
     * @throws Exception
     */
    protected function checkOpenMeteoCondition(
        mixed $config,
        string $paramName,
        string $urlSuffix,
        string $unit,
        string $comparison,
        string $label,
    ): ?string {
        $value = $config->{$paramName};
        $latitude = $config->latitude;
        $longitude = $config->longitude;

        $url = "https://api.open-meteo.com/v1/forecast?latitude=$latitude&longitude=$longitude&hourly=$urlSuffix&timezone=Europe%2FBerlin";

        $response = Http::get($url);

        $data = $response->json();
        $hourly = $data['hourly'][$urlSuffix];
        $time = $data['hourly']['time'];

        $count = count($time);
        $lastHourValue = $hourly[$count - 1];
        $lastHourTime = $time[$count - 1];
        $lastHourTime = strtotime($lastHourTime);
        $now = strtotime(date('Y-m-d H:i:s'));
        $diff = $now - $lastHourTime;

        if ($diff > 3600)
            return null;

        if ($comparison === 'higher' && $lastHourValue > $value) {
            if ($paramName === 'humidity') {
                return "$label: $lastHourValue%";
            }
            return "$label: $lastHourValue$unit";
        } elseif ($comparison === 'lower' && $lastHourValue < $value) {
            if ($paramName === 'humidity') {
                return "$label: $lastHourValue%";
            }
            return "$label: $lastHourValue$unit";
        }

        return null;
    }

    /**
     * @throws Exception
     */
    protected function higherTemp(mixed $config): ?string
    {
        return $this->checkOpenMeteoCondition($config, 'temperature', 'temperature_2m', '°C', 'higher', 'Temperature');
    }

    /**
     * @throws Exception
     */
    protected function lowerTemp(mixed $config): ?string
    {
        return $this->checkOpenMeteoCondition($config, 'temperature', 'temperature_2m', '°C', 'lower', 'Temperature');
    }

    /**
     * @throws Exception
     */
    protected function higherHumidity(mixed $config): ?string
    {
        return $this->checkOpenMeteoCondition($config, 'humidity', 'relativehumidity_2m', '%', 'higher', 'Humidity');
    }

    /**
     * @throws Exception
     */
    protected function lowerHumidity(mixed $config): ?string
    {
        return $this->checkOpenMeteoCondition($config, 'humidity', 'relativehumidity_2m', '%', 'lower', 'Humidity');
    }

    /**
     * @throws Exception
     */
    protected function higherWindSpeed(mixed $config): ?string
    {
        return $this->checkOpenMeteoCondition($config, 'windSpeed', 'windspeed_10m', 'km/h', 'higher', 'Wind speed');
    }

    /**
     * @throws Exception
     */
    protected function lowerWindSpeed(mixed $config): ?string
    {
        return $this->checkOpenMeteoCondition($config, 'windSpeed', 'windspeed_10m', 'km/h', 'lower', 'Wind speed');
    }

    /**
     * @throws Exception
     */
    protected function higherPrecipitation(mixed $config): ?string
    {
        return $this->checkOpenMeteoCondition($config, 'precipitation', 'precipitation', 'mm', 'higher', 'Precipitation');
    }

    /**
     * @throws Exception
     */
    protected function lowerPrecipitation(mixed $config): ?string
    {
        return $this->checkOpenMeteoCondition($config, 'precipitation', 'precipitation', 'mm', 'lower', 'Precipitation');
    }

    /**
     * @throws Exception
     */
    protected function lastHourNews(mixed $config): ?string
    {
        $apiKey = env('NEWS_API_KEY');
        $q = urlencode($config->keywords);
        $fromDate = date('Y-m-d\TH:i:s\Z', strtotime('-1 hour'));

        $url = "https://newsapi.org/v2/everything?pageSize=1&from=$fromDate&apiKey=$apiKey";

        if (strlen($q) > 0)
            $url .= "&q=$q";

        $response = Http::get($url);

        $data = $response->json();

        $articles = $data['articles'];

        if (count($articles) === 0)
            return null;

        $article = $articles[0];

        $response = "Article found:\n\n";
        $response .= "Keywords: {$config->keywords}\n\n";
        $response .= "Title: {$article['title']}\n";
        $response .= "Description: {$article['description']}\n";
        $response .= "Content: {$article['content']}\n";
        $response .= "Author: {$article['author']}\n";
        $response .= "Published at: {$article['publishedAt']}\n";
        $response .= "URL: {$article['url']}\n";
        $response .= "Image: {$article['urlToImage']}\n\n";

        return $response;
    }

    /**
     * @throws Exception
     */
    protected function assignedToGitHubIssue(User $user, mixed $config): ?string
    {
        $token = $user->github_token;
        $owner = $config->owner;
        $repo = $config->repo;

        $resGithubUsername = Http::withToken($token)->get('https://api.github.com/user');
        $githubUsername = $resGithubUsername->json()['login'];

        $response = Http::withToken($token)->get("https://api.github.com/repos/$owner/$repo/issues?assignee={$githubUsername}&state=open");
        $issues = $response->json();

        $issuesNumber = count($issues);

        if ($issuesNumber === 0)
            return null;

        $response = $issuesNumber === 1
            ? "1 issue found:\n\n"
            : "$issuesNumber issues found:\n\n";

        foreach ($issues as $issue) {
            $response .= "Title: {$issue['title']}\n";
            if (isset($issue['body']))
                $response .= "Body: {$issue['body']}\n";
            $response .= "Created at: {$issue['created_at']}\n";
            $response .= "URL: {$issue['html_url']}\n\n";

            return $response;
        }

        return null;
    }

    /**
     * @throws Exception
     */
    protected function commitMadeOnGitHubRepo(User $user, mixed $config, ?string $last_executed): ?string
    {
        $token = $user->github_token;
        $owner = $config->owner;
        $repo = $config->repo;

        $response = Http::withToken($token)->get("https://api.github.com/repos/$owner/$repo/commits");
        $commits = $response->json();

        if (count($commits) === 0)
            return null;

        $output = '';
        $commitsCount = 0;

        foreach ($commits as $commit) {
            $commitDate = $commit['commit']['author']['date'];
            $commitDate = strtotime($commitDate);
            $formattedCommitDate = date('Y-m-d H:i:s', $commitDate);
            $lastExecuted = strtotime($last_executed);
            $diff = $commitDate - $lastExecuted;

            if ($diff <= 0)
                continue;

            $commitsCount++;
            $output .= "Message: {$commit['commit']['message']}\n";
            $output .= "Author: {$commit['commit']['author']['name']}\n";
            $output .= "Date: $formattedCommitDate\n";
            $output .= "URL: {$commit['html_url']}\n\n";
        }

        if ($commitsCount === 0)
            return null;

        $output2 = $commitsCount === 1 ? '1 commit found:' : "$commitsCount commits found:";
        $output2 .= "\n\n";
        $output2 .= $output;

        return $output2;
    }

    /**
     * @throws Exception
     */
    protected function assignedToGitlabIssue(User $user, mixed $config) : ?string
    {
        $projectId = $config->projectId;
        $token = $user->gitlab_token;

        if (!$user->checkAccessTokenExpiration('gitlab'))
            $token = $user->getNewAccessToken('gitlab');

        $resGitlabUsername = Http::withToken($token)->get('https://gitlab.com/api/v4/user');
        $gitlabUsername = $resGitlabUsername->json()['username'];

        $response = Http::withToken($token)->get("https://gitlab.com/api/v4/projects/$projectId/issues?assignee_username=$gitlabUsername&state=opened");
        $issues = $response->json();

        $issuesNumber = count($issues);

        if ($issuesNumber === 0)
            return null;

        $output = $issuesNumber === 1
            ? "1 issue found:\n\n"
            : "$issuesNumber issues found:\n\n";

        foreach ($issues as $issue) {
            $output .= "Title: {$issue['title']}\n";
            if (isset($issue['description']))
                $output .= "Description: {$issue['description']}\n";
            $output .= "Created at: {$issue['created_at']}\n";
            $output .= "URL: {$issue['web_url']}\n\n";
        }

        return $output;
    }

    /**
    * @throws Exception
    */
    protected function commitMadeOnGitLabRepo(User $user, mixed $config, ?string $last_executed): ?string
    {
        $token = $user->gitlab_token;
        $projectId = $config->projectId;

        if (!$user->checkAccessTokenExpiration('gitlab'))
        $token = $user->getNewAccessToken('gitlab');

        $response = Http::withToken($token)->get("https://gitlab.com/api/v4/projects/{$projectId}/repository/commits");

        if (!$response->successful())
            throw new Exception("Error: Failed to retrieve commits from GitLab.");

        $commits = $response->json();

        if (!is_array($commits))
            throw new Exception("Error: Unexpected response format from GitLab API.");

        $commitsCount = count($commits);

        if ($commitsCount === 0)
            return null;

        $output = $commitsCount === 1
            ? '1 commit found:'
            : "$commitsCount commits found:";

        foreach ($commits as $commit) {
            $commitDate = $commit['created_at'];
            $commitDate = strtotime($commitDate);
            $formattedCommitDate = date('Y-m-d H:i:s', $commitDate);
            $lastExecuted = strtotime($last_executed);
            $diff = $commitDate - $lastExecuted;

            if ($diff <= 0)
                continue;

            $output = "Message: {$commit['message']}\n";
            $output .= "Author: {$commit['author_name']}\n";
            $output .= "Date: $formattedCommitDate\n";
            $output .= "URL: {$commit['web_url']}\n\n";
        }

        return $output;
    }

    /**
     * @throws Exception
     */
    protected function receiveMailOutlook(User $user, ?string $last_executed): ?string
    {
        $token = $user->microsoft_token;

        if (!$user->checkAccessTokenExpiration('microsoft'))
            $token = $user->getNewAccessToken('microsoft');

        $response = Http::withToken($token)->get('https://graph.microsoft.com/v1.0/me/messages');
        $mails = $response->json()['value'];

        if (count($mails) === 0)
            return null;

        $output = '';
        $mailsCount = 0;

        foreach ($mails as $mail) {
            if (!isset($mail['from']) || !isset($mail['subject']) || !isset($mail['receivedDateTime']))
                continue;
            $fromName = $mail['from']['emailAddress']['name'];
            $fromAddress = $mail['from']['emailAddress']['address'];
            $from = "$fromName <$fromAddress>";
            $subject = $mail['subject'];
            $date = $mail['receivedDateTime'];

            $date = strtotime($date);
            $formattedDate = date('Y-m-d H:i:s', $date);
            $lastExecuted = strtotime($last_executed);
            $diff = $date - $lastExecuted;

            if ($diff <= 0)
                continue;

            $mailsCount++;

            $content = $mail['bodyPreview'];

            $output .= "From: $from\n";
            $output .= "Subject: $subject\n";
            $output .= "Date: $formattedDate\n";
            $output .= "Content: $content\n\n";
        }

        if ($mailsCount === 0)
            return null;

        $prefix = $mailsCount === 1 ? '1 mail found:' : "$mailsCount mails found:";
        $output2 = "$prefix\n\n";
        $output2 .= $output;

        return $output2;
    }
}
