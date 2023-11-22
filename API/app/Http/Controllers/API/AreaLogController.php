<?php

namespace App\Http\Controllers\API;

use App\Http\Controllers\API\BaseController as BaseController;
use App\Models\AreaLog;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

class AreaLogController extends BaseController
{
    /**
     * Display a listing of the resource.
     */
    public function index(Request $request): JsonResponse
    {
        $user = $request->user();
        $areaLogs = AreaLog::where('user_id', $user->id)->get();

        return $this->sendResponse($areaLogs->toArray(), 'Area logs retrieved successfully.');
    }

    public function show(Request $request): JsonResponse
    {
        $id = $request->id;
        $user = $request->user();

        $areaLogs = AreaLog::where('user_id', $user->id)
            ->where('area_id', $id)
            ->get();

        if (!isset($areaLogs)) {
            return $this->sendError("Area log $id not found.");
        }

        return $this->sendResponse($areaLogs->toArray(), 'Area logs retrieved successfully.');
    }
}
