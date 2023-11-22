<?php

namespace App\Http\Controllers\API\Google;

use App\Http\Controllers\API\BaseController as BaseController;
use App\Models\User;
use Google\Client;
use Google\Service\Gmail;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

class GmailController extends BaseController
{
    private function getGmailService(User $user): Gmail
    {
        $client = new Client();
        $client->setAccessToken($user->google_token);
        return new Gmail($client);
    }

    public function index(Request $request): JsonResponse
    {
        $user = $request->user();
        $service = $this->getGmailService($user);

        $threads = $service->users_threads->listUsersThreads('me');
        return $this->sendResponse($threads, '');
    }

    public function subscribeUserPushNotification(Request $request): JsonResponse
    {
        $user = $request->user();
        $service = $this->getGmailService($user);

        $watchRequest = new Gmail\WatchRequest();
        $watchRequest->setTopicName('projects/my_project_name/topics/GmailAPIPush');
        $watchRequest->setLabelIds(['INBOX']);
        $response = $service->users->watch('me', $watchRequest);
        return $this->sendResponse($response, '');
    }

    public function gmailWebHook(Request $request): JsonResponse
    {
        $user = $request->user();
        error_log('webhook received');
        return $this->sendResponse([], '');
    }
}
