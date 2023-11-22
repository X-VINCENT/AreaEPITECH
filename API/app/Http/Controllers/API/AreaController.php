<?php

namespace App\Http\Controllers\API;

use App\Http\Controllers\API\BaseController as BaseController;
use App\Models\Action;
use App\Models\Area;
use App\Models\AreaLog;
use App\Models\Reaction;
use DateTime;
use Exception;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;

class AreaController extends BaseController
{
    public function index(Request $request): JsonResponse
    {
        $user = $request->user();
        $areas = Area::where('user_id', $user->id)->get();

        $areas = $areas->map(function ($area) {
            if (isset($area->action_config))
                $area->action_config = json_decode($area->action_config);
            if (isset($area->reaction_config))
                $area->reaction_config = json_decode($area->reaction_config);
            return $area;
        });

        return $this->sendResponse($areas->toArray(), 'Areas retrieved successfully.');
    }

    public function show(Request $request): JsonResponse
    {
        $id = $request->id;
        $user = $request->user();
        $area = Area::where('user_id', $user->id)->find($id);

        if (!isset($area))
            return $this->sendError('Area not found.');

        $response = $area->toArray();
        if (isset($response['action_config']))
            $response['action_config'] = json_decode($response['action_config']);
        if (isset($response['reaction_config']))
            $response['reaction_config'] = json_decode($response['reaction_config']);

        return $this->sendResponse($response, 'Area retrieved successfully.');
    }

    public function store(Request $request): JsonResponse
    {
        $validator = Validator::make($request->all(), [
            'name' => 'required|max:255',
            'description' => '',
            'active' => 'boolean',
            'action_id' => 'required|int|exists:actions,id',
            'reaction_id' => 'required|int|exists:reactions,id',
            'action_config' => 'array',
            'reaction_config' => 'array',
            'refresh_delay' => 'int|min:60|max:86400',
        ]);

        if ($validator->fails()) {
            return $this->sendError('Validation error', $validator->errors(), 400);
        }

        $input = $request->all();
        $user = $request->user();
        $input['user_id'] = $user->id;

        $selectedAction = Action::findOrFail($input['action_id']);
        $actionConfigKeys = json_decode($selectedAction->config_keys, true);

        if (!isset($input['action_config']))
        	$input['action_config'] = [];

        if (!isset($input['reaction_config']))
        	$input['reaction_config'] = [];

        if (!$this->validateConfig($input['action_config'], $actionConfigKeys))
            return $this->sendError('Validation error', 'Invalid action_config', 400);

        $selectedReaction = Reaction::findOrFail($input['reaction_id']);
        $reactionConfigKeys = json_decode($selectedReaction->config_keys, true);

        if (!$this->validateConfig($input['reaction_config'], $reactionConfigKeys))
            return $this->sendError('Validation error', 'Invalid reaction_config', 400);

        $input['action_config'] = json_encode($input['action_config']);
        $input['reaction_config'] = json_encode($input['reaction_config']);
        $input['last_executed'] = json_encode(now());
        $area = Area::create($input);

        $response = $area->toArray();
        $response['action_config'] = json_decode($response['action_config']);
        $response['reaction_config'] = json_decode($response['reaction_config']);

        return $this->sendResponse($response, 'Area created successfully.');
    }

    public function update(Request $request): JsonResponse
    {
        $id = $request->id;
        $user = $request->user();
        $area = Area::where('user_id', $user->id)->find($id);

        if (!isset($area)) {
            return $this->sendError('Area not found.');
        }

        $validator = Validator::make($request->all(), [
            'name' => 'max:64',
            'description' => '',
            'active' => 'boolean',
            'action_id' => 'int|exists:actions,id',
            'reaction_id' => 'int|exists:reactions,id',
            'action_config' => 'array',
            'reaction_config' => 'array',
            'refresh_delay' => 'int|min:60|max:86400',
        ]);

        if ($validator->fails()) {
            return $this->sendError('Validation error', $validator->errors(), 400);
        }

        $input = $request->all();

        if (!isset($input['action_config']))
        	$input['action_config'] = [];

        if (!isset($input['reaction_config']))
            $input['reaction_config'] = [];

        if (isset($input['action_id'])) {
            $selectedAction = Action::findOrFail($input['action_id']);
            $actionConfigKeys = json_decode($selectedAction->config_keys, true);

            if (!$this->validateConfig($input['action_config'], $actionConfigKeys))
                return $this->sendError('Validation error', 'Invalid action_config', 400);
        }

        if (isset($input['reaction_id'])) {
            $selectedReaction = Reaction::findOrFail($input['reaction_id']);
            $reactionConfigKeys = json_decode($selectedReaction->config_keys, true);

            if (!$this->validateConfig($input['reaction_config'], $reactionConfigKeys))
                return $this->sendError('Validation error', 'Invalid reaction_config', 400);
        }

        if (isset($input['action_config']))
            $input['action_config'] = json_encode($input['action_config']);

        if (isset($input['reaction_config']))
            $input['reaction_config'] = json_encode($input['reaction_config']);

        $area->fill($input);
        $area->save();

        $response = $area->toArray();
        $response['action_config'] = json_decode($response['action_config']);
        $response['reaction_config'] = json_decode($response['reaction_config']);

        return $this->sendResponse($response, 'Area updated successfully.');
    }

    public function destroy(Request $request): JsonResponse
    {
        $id = $request->id;
        $user = $request->user();
        $area = Area::where('user_id', $user->id)->find($id);

        if (!isset($area)) {
            return $this->sendError('Area not found.');
        }

        $area->delete();

        $response = $area->toArray();
        $response['action_config'] = json_decode($response['action_config']);
        $response['reaction_config'] = json_decode($response['reaction_config']);

        return $this->sendResponse($response, 'Area deleted successfully.');
    }

    public function execute(Request $request): JsonResponse
    {
        $id = $request->id;
        $user = $request->user();
        $area = Area::where('user_id', $user->id)->find($id);

        if (!isset($area)) {
            return $this->sendError('Area not found.');
        }

        $action = Action::find($area->action_id);
        if (!isset($action)) {
            return $this->sendError('Action not found.');
        }

        $reaction = Reaction::find($area->reaction_id);
        if (!isset($reaction)) {
            return $this->sendError('Reaction not found.');
        }

        $action_config = json_decode($area->action_config);
        $reaction_config = json_decode($area->reaction_config);

        $area_log_input = [
            'user_id' => $user->id,
            'area_id' => $area->id,
            'status' => 'pending',
        ];
        $area_log = AreaLog::create($area_log_input);

        $last_executed = $area->last_executed;
        $area->last_executed = new DateTime();
        $area->save();

        try {
            $actionResult = $action->execute($user, $action_config, $last_executed);
            if (!$actionResult) {
                $area_log->message = 'No trigger detected.';
                $area_log->save();
                return $this->sendResponse('', 'No trigger detected.');
            }
            $reactionResult = $reaction->execute($user, $reaction_config, $actionResult);
            if (!$reactionResult) {
                $area_log->message = 'Reaction failed.';
                $area_log->save();
                return $this->sendResponse('', 'Reaction failed.');
            }
        } catch (Exception $e) {
            $area_log->status = 'error';
            $area_log->message = $e->getMessage();
            $area_log->save();
            return $this->sendError($e->getMessage(), $e->getMessage(), 400);
        }

        $area_log->status = 'success';
        $area_log->save();

        return $this->sendResponse([
            'action_result' => $actionResult,
            'reaction_result' => $reactionResult,
        ], 'Area executed successfully.');
    }

    private function validateConfig($config, $keys): bool
    {
        if (!isset($keys))
            return true;

        foreach ($keys as $key) {
            $id = $key['id'];
            $type = $key['type'];
            $optional = $key['optional'] ?? false;
            $maxLength = $key['maxLength'] ?? null;

            if ($optional && !isset($config[$id]))
                continue;

            if (!isset($config[$id]))
                return false;

            if ($type === 'number' && !is_numeric($config[$id])) {
                return false;
            } elseif ($type === 'dateTime') {
                try {
                    new DateTime($config[$id]);
                } catch (Exception $e) {
                    return false;
                }
            } elseif ($type === 'text') {
                if (!is_string($config[$id]))
                    return false;
                elseif ($maxLength !== null && strlen($config[$id]) > $maxLength)
                    return false;
            }
        }

        return true;
    }
}
