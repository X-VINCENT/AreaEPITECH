<?php

namespace App\Http\Controllers\API;

use App\Http\Controllers\API\BaseController as BaseController;
use App\Models\Action;
use App\Models\Reaction;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;

class ReactionController extends BaseController
{
    public function index(Request $request): JsonResponse
    {
        $user = $request->user();

        $reactions = Reaction::all();

        $reactions = $reactions->map(function ($reaction) use ($user) {
            if (isset($reaction->config_keys))
                $reaction->config_keys = json_decode($reaction->config_keys);
            $reaction->usable = $user->isConnectedToService($reaction->service_id);
            return $reaction;
        });

        return $this->sendResponse($reactions->toArray(), 'Reactions retrieved successfully.');
    }

    public function show(Request $request): JsonResponse
    {
        $id = $request->id;
        $reaction = Reaction::find($id);

        if (!isset($reaction))
            return $this->sendError('Reaction not found.');

        $user = $request->user();

        $reaction->usable = $user->isConnectedToService($reaction->service_id);
        $response = $reaction->toArray();

        if (isset($response['config_keys']))
            $response['config_keys'] = json_decode($response['config_keys']);

        return $this->sendResponse($response, 'Reaction retrieved successfully.');
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

        if (!isset($input['config_keys']))
            $input['config_keys'] = json_encode($input['config_keys']);

        $reaction = Reaction::create($input);
        $response = $reaction->toArray();

        if (isset($response['config_keys']))
            $response['config_keys'] = json_decode($response['config_keys']);

        return $this->sendResponse($response, 'Reaction created successfully.');
    }

    public function update(Request $request): JsonResponse
    {
        $id = $request->id;
        $reaction = Reaction::find($id);

        if (!isset($reaction))
            return $this->sendError('Reaction not found.');

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

        $reaction->fill($input);
        $reaction->save();
        $response = $reaction->toArray();

        if (isset($response['config_keys']))
            $response['config_keys'] = json_decode($response['config_keys']);

        return $this->sendResponse($response, 'Reaction updated successfully.');
    }

    public function destroy(Request $request): JsonResponse
    {
        $id = $request->id;
        $reaction = Reaction::find($id);

        if (!isset($reaction))
            return $this->sendError('Reaction not found.');

        $reaction->delete();

        $response = $reaction->toArray();

        if (isset($response['config_keys']))
            $response['config_keys'] = json_decode($response['config_keys']);

        return $this->sendResponse($response, 'Reaction deleted successfully.');
    }
}
