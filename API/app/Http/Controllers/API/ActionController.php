<?php

namespace App\Http\Controllers\API;

use App\Http\Controllers\API\BaseController as BaseController;
use App\Models\Action;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;

class ActionController extends BaseController
{
    public function index(Request $request): JsonResponse
    {
        $user = $request->user();

        $actions = Action::all();

        $actions = $actions->map(function ($action) use ($user) {
            if (isset($action->config_keys))
                $action->config_keys = json_decode($action->config_keys);
            $action->usable = $user->isConnectedToService($action->service_id);
            return $action;
        });

        return $this->sendResponse($actions->toArray(), 'Actions retrieved successfully.');
    }

    public function show(Request $request): JsonResponse
    {
        $id = $request->id;
        $action = Action::find($id);

        if (!isset($action))
            return $this->sendError('Action not found.');

        $user = $request->user();

        $action->usable = $user->isConnectedToService($action->service_id);
        $response = $action->toArray();

        if (isset($response['config_keys']))
            $response['config_keys'] = json_decode($response['config_keys']);

        return $this->sendResponse($response, 'Action retrieved successfully.');
    }

    public function store(Request $request): JsonResponse
    {
        $validator = Validator::make($request->all(), [
            'service_id' => 'required|int|exists:services,id',
            'name' => 'required|max:64',
            'description' => '',
            'config_keys' => 'array',
        ]);

        if ($validator->fails())
            return $this->sendError('Validation error', $validator->errors(), 400);

        $input = $request->all();

        if (isset($input['config_keys']))
            $input['config_keys'] = json_encode($input['config_keys']);

        $action = Action::create($input);
        $response = $action->toArray();

        if (isset($response['config_keys']))
            $response['config_keys'] = json_decode($response['config_keys']);

        return $this->sendResponse($response, 'Action created successfully.');
    }

    public function update(Request $request): JsonResponse
    {
        $id = $request->id;
        $action = Action::find($id);

        if (!isset($action))
            return $this->sendError('Action not found.');

        $validator = Validator::make($request->all(), [
            'service_id' => 'int|exists:services,id',
            'name' => 'max:64',
            'description' => '',
            'config_keys' => 'array',
        ]);

        if ($validator->fails())
            return $this->sendError('Validation error', $validator->errors(), 400);

        $input = $request->all();

        if (isset($input['config_keys']))
            $input['config_keys'] = json_encode($input['config_keys']);

        $action->fill($input);
        $action->save();
        $response = $action->toArray();

        if (isset($response['config_keys']))
            $response['config_keys'] = json_decode($response['config_keys']);

        return $this->sendResponse($response, 'Action updated successfully.');
    }

    public function destroy(Request $request): JsonResponse
    {
        $id = $request->id;
        $action = Action::find($id);

        if (!isset($action))
            return $this->sendError('Action not found.');

        $action->delete();

        $response = $action->toArray();

        if (isset($response['config_keys']))
            $response['config_keys'] = json_decode($response['config_keys']);

        return $this->sendResponse($response, 'Action deleted successfully.');
    }
}
