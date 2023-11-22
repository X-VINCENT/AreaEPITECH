<?php

namespace App\Http\Controllers\API;

use App\Http\Controllers\API\BaseController as BaseController;
use App\Models\Service;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;

class ServiceController extends BaseController
{
    public function index(): JsonResponse
    {
        $services = Service::all();

        return $this->sendResponse($services->toArray(), 'Services retrieved successfully.');
    }

    public function show(Request $request): JsonResponse
    {
        $id = $request->id;
        $service = Service::find($id);

        if (!isset($service)) {
            return $this->sendError('Service not found.');
        }

        return $this->sendResponse($service->toArray(), 'Service retrieved successfully.');
    }

    public function store(Request $request): JsonResponse
    {
        $validator = Validator::make($request->all(), [
            'key' => 'required|max:64|unique:services',
            'name' => 'required|max:64',
            'logo_url' => 'required',
            'is_oauth' => 'boolean',
        ]);

        if ($validator->fails()) {
            return $this->sendError('Validation Error.', $validator->errors(), 400);
        }

        $input = $request->all();
        $service = Service::create($input);

        return $this->sendResponse($service->toArray(), 'Service created successfully.');
    }

    public function update(Request $request): JsonResponse
    {
        $id = $request->id;
        $service = Service::find($id);

        if (!isset($service)) {
            return $this->sendError('Service not found.');
        }

        $validator = Validator::make($request->all(), [
            'key' => 'max:64|unique:services,key,' . $id,
            'name' => 'max:64',
            'logo_url' => '',
            'is_oauth' => 'boolean',
        ]);

        if ($validator->fails()) {
            return $this->sendError('Validation Error.', $validator->errors(), 400);
        }

        $input = $request->all();
        $service->fill($input);
        $service->save();

        return $this->sendResponse($service->toArray(), 'Service updated successfully.');
    }

    public function destroy(Request $request): JsonResponse
    {
        $id = $request->id;
        $service = Service::find($id);

        if (!isset($service)) {
            return $this->sendError('Service not found.');
        }

        $service->delete();

        return $this->sendResponse('', 'Service deleted successfully.');
    }
}
