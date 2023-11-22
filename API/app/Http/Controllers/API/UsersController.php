<?php

namespace App\Http\Controllers\API;

use App\Http\Controllers\API\BaseController as BaseController;
use App\Models\User;
use Illuminate\Http\JsonResponse;

class UsersController extends BaseController
{
    public function index(): JsonResponse
    {
        $users = User::all();

        return $this->sendResponse($users->toArray(), 'Users retrieved successfully.');
    }

    public function show(int $id): JsonResponse
    {
        $user = User::find($id);

        if (is_null($user))
            return $this->sendError('User not found.');

        return $this->sendResponse($user->toArray(), 'User retrieved successfully.');
    }
}
