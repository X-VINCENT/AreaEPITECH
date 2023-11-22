<?php

namespace App\Models;

use Exception;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Support\Facades\Http;
use stdClass;

class Reaction extends Model
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
     * @throws Exception
     */
    public function execute(User $user, mixed $config, string $data): string
    {
        $key = $this->key;
        $usable = $user->isConnectedToService($this->service_id);

        if (!$usable ?? false)
            throw new Exception('You cannot use this action. Please, check your connection to the service.');

        return match ($key) {
            'sendMail' => $this->sendMail($user, $config, $data),
            'writeGoogleDoc' => $this->writeGoogleDoc($user, $config, $data),
            'addEventToGoogleCalendar' => $this->addEventToGoogleCalendar($user, $config, $data),
            'addIssueToGitHubRepo' => $this->addIssueToGitHubRepo($user, $config, $data),
            'addIssueToGitLabRepo' => $this->addIssueToGitLabRepo($user, $config, $data),
            'createStackExchangeComment' => $this->createStackExchangeComment($user, $config, $data),
            'sendOutlookMail' => $this->sendOutlookMail($user, $config, $data),
            'addEventToMicrosoftCalendar' => $this->addEventToMicrosoftCalendar($user, $config, $data),
            'addMicrosoftNote' => $this->addMicrosoftNote($user, $config, $data),
            'addMicrosoftTask' => $this->addMicrosoftTask($user, $config, $data),
            'sendMicrosoftChatMessage' => $this->sendMicrosoftChatMessage($user, $config, $data),
            default => throw new Exception("Reaction {$key} not found"),
        };
    }

    /**
     * @throws Exception
     */
    public function sendMail(User $user, mixed $config, string $data): string
    {
        $mail = $config->mail;
        $subject = $config->subject;
        $token = $user->google_token;

        if (!$user->checkAccessTokenExpiration('google'))
            $token = $user->getNewAccessToken('google');

        $response = Http::withToken($token)->post('https://gmail.googleapis.com/gmail/v1/users/me/messages/send', [
            'raw' => base64_encode("From: {$user->email}\r\nTo: {$mail}\r\nSubject: {$subject}\r\n\r\n{$data}"),
        ]);

        if (!$response->successful())
            throw new Exception('Error sending email');

        return 'Email sent successfully';
    }

    /**
     * @throws Exception
     */
    public function writeGoogleDoc(User $user, mixed $config, string $data): string
    {
        $documentName = $config->documentName;
        $token = $user->google_token;

        if (!$user->checkAccessTokenExpiration('google'))
            $token = $user->getNewAccessToken('google');

        $response = Http::withToken($token)->get('https://www.googleapis.com/drive/v3/files', [
            'pageSize' => 1000,
            'q' => "mimeType='application/vnd.google-apps.document' and trashed=false",
        ]);

        if (!$response->successful())
            throw new Exception('Error getting documents');

        $documents = $response->json()['files'];
        $documentId = null;

        foreach ($documents as $document) {
            if ($document['name'] === $documentName) {
                $documentId = $document['id'];
                break;
            }
        }

        if (is_null($documentId)) {
            $response = Http::withToken($token)->post('https://www.googleapis.com/drive/v3/files', [
                'name' => $documentName,
                'mimeType' => 'application/vnd.google-apps.document',
            ]);

            if (!$response->successful())
                throw new Exception('Error creating document');

            $documentId = $response->json()['id'];
        }

        $date = date('d/m/Y H:i:s');
        $content = "Date: {$date}\nContent: {$data}\n\n";

        $response = Http::withToken($token)->post("https://docs.googleapis.com/v1/documents/{$documentId}:batchUpdate", [
            'requests' => [
                'insertText' => [
                    'endOfSegmentLocation' => new stdClass(),
                    'text' => $content,
                ],
            ],
        ]);

        if (!$response->successful())
            throw new Exception('Error writing to document');

        return 'Document updated successfully';
    }

    /**
     * @throws Exception
     */
    public function addEventToGoogleCalendar(User $user, mixed $config, string $data): string
    {
        $calendarId = $config->calendarId;
        $title = $config->title;
        $start = $config->start;
        $end = $config->end;
        $token = $user->google_token;

        if (!$user->checkAccessTokenExpiration('google'))
            $token = $user->getNewAccessToken('google');

        $response = Http::withToken($token)->post("https://www.googleapis.com/calendar/v3/calendars/{$calendarId}/events", [
            'summary' => $title,
            'description' => $data,
            'start' => [
                'dateTime' => $start,
                'timeZone' => 'Europe/Paris',
            ],
            'end' => [
                'dateTime' => $end,
                'timeZone' => 'Europe/Paris',
            ],
        ]);

        if (!$response->successful())
            throw new Exception('Error adding event to calendar');

        return 'Event added successfully';
    }

    /**
     * @throws Exception
     */
    public function addIssueToGitHubRepo(User $user, mixed $config, string $data): string
    {
        $owner = $config->owner;
        $repo = $config->repo;
        $title = $config->title;
        $body = $data;
        $token = $user->github_token;

        $response = Http::withToken($token)->post("https://api.github.com/repos/{$owner}/{$repo}/issues", [
            'title' => $title,
            'body' => $body,
        ]);

        if (!$response->successful())
            throw new Exception('Error adding issue to repo');

        return 'Issue added successfully';
    }

    /**
     * @throws Exception
     */
    public function addIssueToGitLabRepo(User $user, mixed $config, string $data): string
    {
        $projectId = $config->projectId;
        $title = $config->title;
        $body = $data;
        $token = $user->gitlab_token;

        $response = Http::withToken($token)->post("https://gitlab.com/api/v4/projects/{$projectId}/issues", [
            'title' => $title,
            'body' => $body,
        ]);

        if (!$response->successful())
            throw new Exception('Error adding issue to repo');

        return 'Issue added successfully';
    }

    /**
     * @throws Exception
     */
    public function createStackExchangeComment(User $user, mixed $config, string $data): string
    {
        $postId = $config->postId;
        $body = $data;
        $token = $user->stackexchange_token;

        $response = Http::withToken($token)->post("https://api.stackexchange.com/2.3/posts/{$postId}/comments/add", [
            'site' => 'stackapps',
            'body' => $body,
        ]);

        if (!$response->successful())
            throw new Exception('Error creating comment');

        return 'Comment created successfully';
    }

    /**
     * @throws Exception
     */
    public function sendOutlookMail(User $user, mixed $config, string $data): string
    {
        $mail = $config->mail;
        $subject = $config->subject;
        $token = $user->microsoft_token;

        if (!$user->checkAccessTokenExpiration('microsoft'))
            $token = $user->getNewAccessToken('microsoft');

        $response = Http::withToken($token)->post('https://graph.microsoft.com/v1.0/me/sendMail', [
            'message' => [
                'subject' => $subject,
                'body' => [
                    'contentType' => 'Text',
                    'content' => $data,
                ],
                'toRecipients' => [
                    [
                        'emailAddress' => [
                            'address' => $mail,
                        ],
                    ],
                ],
            ],
        ]);

        if (!$response->successful())
            throw new Exception('Error sending email');

        return 'Email sent successfully';
    }

    /**
     * @throws Exception
     */
    public function addEventToMicrosoftCalendar(User $user, mixed $config, string $data): string
    {
        $calendarId = $config->calendarId;
        $title = $config->title;
        $start = $config->start;
        $end = $config->end;
        $token = $user->microsoft_token;

        if (!$user->checkAccessTokenExpiration('microsoft'))
            $token = $user->getNewAccessToken('microsoft');

        $response = Http::withToken($token)->post("https://graph.microsoft.com/v1.0/me/calendars/{$calendarId}/events", [
            'subject' => $title,
            'body' => [
                'contentType' => 'Text',
                'content' => $data,
            ],
            'start' => [
                'dateTime' => $start,
                'timeZone' => 'Europe/Paris',
            ],
            'end' => [
                'dateTime' => $end,
                'timeZone' => 'Europe/Paris',
            ],
        ]);

        if (!$response->successful())
            throw new Exception('Error adding event to calendar');

        return 'Event added successfully';
    }

    /**
     * @throws Exception
     */
    public function addMicrosoftNote(User $user, mixed $config, string $data): string
    {
        $notebookName = $config->notebookName;
        $sectionName = $config->sectionName;
        $pageName = $config->pageName;
        $token = $user->microsoft_token;

        if (!$user->checkAccessTokenExpiration('microsoft'))
            $token = $user->getNewAccessToken('microsoft');

        $response = Http::withToken($token)->get('https://graph.microsoft.com/v1.0/me/onenote/notebooks', [
            'filter' => "name eq '{$notebookName}'",
        ]);

        if (!$response->successful())
            throw new Exception('Error getting notebooks');

        $notebooks = $response->json()['value'];

        if (count($notebooks) === 0) {
            $response = Http::withToken($token)->post('https://graph.microsoft.com/v1.0/me/onenote/notebooks', [
                'displayName' => $notebookName,
            ]);

            if (!$response->successful())
                throw new Exception('Error creating notebook');

            $notebookId = $response->json()['id'];
        } else {
            $notebookId = $notebooks[0]['id'];
        }

        $response = Http::withToken($token)->get("https://graph.microsoft.com/v1.0/me/onenote/notebooks/{$notebookId}/sections", [
            'filter' => "name eq '{$sectionName}'",
        ]);

        if (!$response->successful())
            throw new Exception('Error getting sections');

        $sections = $response->json()['value'];

        if (count($sections) === 0) {
            $response = Http::withToken($token)->post("https://graph.microsoft.com/v1.0/me/onenote/notebooks/{$notebookId}/sections", [
                'displayName' => $sectionName,
            ]);

            if (!$response->successful())
                throw new Exception('Error creating section');

            $sectionId = $response->json()['id'];
        } else {
            $sectionId = $sections[0]['id'];
        }

        $response = Http::withToken($token)->get("https://graph.microsoft.com/v1.0/me/onenote/sections/{$sectionId}/pages", [
            'filter' => "title eq '{$pageName}'",
        ]);

        if (!$response->successful())
            throw new Exception('Error getting pages');

        $pages = $response->json()['value'];

        if (count($pages) === 0) {
            $htmlContent = '<!DOCTYPE html><html><head><title>' . $pageName . '</title></head><body><p>' . $data . '</p></body></html>';
            $boundary = 'MyPartBoundary' . md5(microtime());
            $multipartData = "--$boundary\r\n";
            $multipartData .= "Content-Disposition: form-data; name=\"Presentation\"\r\n";
            $multipartData .= "Content-Type: text/html\r\n\r\n";
            $multipartData .= $htmlContent . "\r\n";
            $multipartData .= "--$boundary--\r\n";

            $response = Http::withToken($token)->withBody(
                $multipartData,
                'multipart/form-data; boundary=' . $boundary
            )->post("https://graph.microsoft.com/v1.0/me/onenote/sections/{$sectionId}/pages");

            if (!$response->successful())
                throw new Exception('Error creating page');
        } else {
            $pageId = $pages[0]['id'];

            $body = [
                'target' => 'body',
                'action' => 'append',
                'content' => '<p>' . $data . '</p>',
            ];

            $response = Http::withToken($token)->patch("https://graph.microsoft.com/v1.0/me/onenote/pages/{$pageId}/content", [
                $body
            ]);

            if (!$response->successful())
                throw new Exception('Error updating page');
        }

        return 'Note added successfully';
    }

    /**
     * @throws Exception
     */
    public function addMicrosoftTask(User $user, mixed $config, string $data): string
    {
        $taskListName = $config->taskListName;
        $title = $config->title;
        $body = $data;
        $token = $user->microsoft_token;

        if (!$user->checkAccessTokenExpiration('microsoft'))
            $token = $user->getNewAccessToken('microsoft');

        $response = Http::withToken($token)->get('https://graph.microsoft.com/v1.0/me/todo/lists', [
            'filter' => "displayName eq '{$taskListName}'",
        ]);

        if (!$response->successful())
            throw new Exception('Error getting task lists');

        $taskLists = $response->json()['value'];

        $taskList = null;

        foreach ($taskLists as $list) {
            if ($list['displayName'] === $taskListName) {
                $taskList = $list;
                break;
            }
        }

        if (is_null($taskList)) {
            $response = Http::withToken($token)->post('https://graph.microsoft.com/v1.0/me/todo/lists', [
                'displayName' => $taskListName,
            ]);

            if (!$response->successful())
                throw new Exception('Error creating task list');

            $taskListId = $response->json()['id'];
        } else {
            $taskListId = $taskList['id'];
        }

        $response = Http::withToken($token)->post("https://graph.microsoft.com/v1.0/me/todo/lists/{$taskListId}/tasks", [
            'title' => $title,
            'body' => [
                'contentType' => 'text',
                'content' => $body,
            ],
        ]);

        if (!$response->successful())
            throw new Exception('Error creating task');

        return 'Task added successfully';
    }

    /**
     * @throws Exception
     */
    public function sendMicrosoftChatMessage(User $user, mixed $config, string $data): string
    {
        $chatId = $config->chatId;
        $body = $data;
        $token = $user->microsoft_token;

        if (!$user->checkAccessTokenExpiration('microsoft'))
            $token = $user->getNewAccessToken('microsoft');

        $response = Http::withToken($token)->post("https://graph.microsoft.com/v1.0/me/chats/{$chatId}/messages", [
            'body' => [
                'content' => $body,
            ],
        ]);

        if (!$response->successful())
            throw new Exception('Error sending message');

        return 'Message sent successfully';
    }
}
