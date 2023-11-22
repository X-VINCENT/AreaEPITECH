<?php

namespace App\Http\Controllers\API;

use Illuminate\Http\Request;
use App\Http\Controllers\API\BaseController as BaseController;
use App\Models\User;
use Illuminate\Support\Facades\Auth;
use Illuminate\Http\JsonResponse;
use Illuminate\Support\Facades\Validator;

class AuthController extends BaseController
{
    /**
     * Register api
     *
     * @param Request $request
     * @return JsonResponse
     */
    public function register(Request $request): JsonResponse
    {
        $validator = Validator::make($request->all(), [
            'name' => 'required|max:64',
            'email' => 'required|email|unique:users',
            'password' => 'required|min:8',
            'c_password' => 'required|same:password',
        ]);

        if ($validator->fails()) {
            return $this->sendError('Validation error', $validator->errors(), 400);
        }

        $input = $request->all();
        $input['password'] = bcrypt($input['password']);
        $user = User::create($input);
        $response['user'] = $user->toArray();
        $response['token'] = $user->createToken('auth_token')->accessToken;

        return $this->sendResponse($response, 'User register successfully.');
    }

    /**
     * Login api
     *
     * @param Request $request
     * @return JsonResponse
     */
    public function login(Request $request): JsonResponse
    {
        $credentials = [
            'email' => $request->email,
            'password' => $request->password,
        ];

        $auth_guard = Auth::guard('web');
        if (!$auth_guard->attempt($credentials)) {
            return $this->sendError('Invalid credentials.', [], 401);
        }

        $user = $auth_guard->user();
        $response['user'] = $user->toArray();
        $response['token'] = $user->createToken('auth_token')->accessToken;

        return $this->sendResponse($response, 'User login successfully.');
    }
}
