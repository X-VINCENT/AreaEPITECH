<?php

use App\Models\Action;
use App\Models\Reaction;
use App\Models\Service;
use Illuminate\Support\Facades\Route;

/*
|--------------------------------------------------------------------------
| Web Routes
|--------------------------------------------------------------------------
|
| Here is where you can register web routes for your application. These
| routes are loaded by the RouteServiceProvider and all of them will
| be assigned to the "web" middleware group. Make something great!
|
*/

Route::get('/about.json', function () {
    $services = Service::all();
    $actions = Action::all();
    $reactions = Reaction::all();

    $servicesArray = [];

    foreach ($services as $service) {
        $actionsArray = [];
        $reactionsArray = [];

        foreach ($actions as $action) {
            if ($action->service_id == $service->id) {
                $actionsArray[] = [
                    'name' => $action->name,
                    'description' => $action->description,
                ];
            }
        }

        foreach ($reactions as $reaction) {
            if ($reaction->service_id == $service->id) {
                $reactionsArray[] = [
                    'name' => $reaction->name,
                    'description' => $reaction->description,
                ];
            }
        }

        $servicesArray[] = [
            'name' => $service->name,
            'actions' => $actionsArray,
            'reactions' => $reactionsArray,
        ];
    }

    return response()->json([
        'client' => [
            'host' => $_SERVER['REMOTE_ADDR'],
        ],
        'server' => [
            'current_time' => time(),
            'services' => $servicesArray,
        ]
    ]);
});

Route::get('/', function () {
    return view('welcome');
});

Route::get('/oauth-login', function () {
    return view('oauth-login');
});
