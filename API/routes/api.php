<?php

use App\Http\Controllers\API\ActionController;
use App\Http\Controllers\API\AreaController;
use App\Http\Controllers\API\AreaLogController;
use App\Http\Controllers\API\AuthController;
use App\Http\Controllers\API\Google\GmailController;
use App\Http\Controllers\API\ReactionController;
use App\Http\Controllers\API\ServiceController;
use App\Http\Controllers\API\SocialAuthController;
use App\Http\Controllers\API\UsersController;
use Illuminate\Support\Facades\Route;

/*
|--------------------------------------------------------------------------
| API Routes
|--------------------------------------------------------------------------
|
| Here is where you can register API routes for your application. These
| routes are loaded by the RouteServiceProvider and all of them will
| be assigned to the "api" middleware group. Make something great!
|
*/

Route::group(['middleware' => ['cors', 'json.response']], function () {
    // public routes
    Route::post('register', [AuthController::class, 'register']);
    Route::post('login', [AuthController::class, 'login']);
    Route::get('/auth/{provider}', [SocialAuthController::class, 'redirect']);
    Route::get('/auth/{provider}/callback', [SocialAuthController::class, 'callback']);
    Route::get('/auth/{provider}/disconnect', [SocialAuthController::class, 'disconnect']);
    Route::get('gmail/webhook', [GmailController::class, 'gmailWebHook']);

    // services routes
    Route::group(['prefix' => 'services'], function () {
        Route::get('/', [ServiceController::class, 'index']);
        Route::get('/{id}', [ServiceController::class, 'show']);
    });

    // protected routes
    Route::middleware('auth:api')->group(function () {

        // actions routes
        Route::group(['prefix' => 'actions'], function () {
            Route::get('/', [ActionController::class, 'index']);
            Route::get('/{id}', [ActionController::class, 'show']);
        });

        // reactions routes
        Route::group(['prefix' => 'reactions'], function () {
            Route::get('/', [ReactionController::class, 'index']);
            Route::get('/{id}', [ReactionController::class, 'show']);
        });

        // areas routes
        Route::group(['prefix' => 'areas'], function () {
            Route::get('/', [AreaController::class, 'index']);
            Route::post('/', [AreaController::class, 'store']);
            Route::get('/logs', [AreaLogController::class, 'index']);
            Route::get('/{id}', [AreaController::class, 'show']);
            Route::get('/{id}/execute', [AreaController::class, 'execute']);
            Route::put('/{id}', [AreaController::class, 'update']);
            Route::delete('/{id}', [AreaController::class, 'destroy']);
            Route::get('/{id}/logs', [AreaLogController::class, 'show']);
        });

        Route::group(['prefix' => 'gmail', 'middleware' => ['verifyGoogleToken']], function () {
            Route::get('/', [GmailController::class, 'index']);
        });
    });

    // admin routes (user with role admin)
    Route::middleware(['auth:api', 'role:admin'])->group(function () {
        // users routes
        Route::group(['prefix' => 'users'], function () {
            Route::get('/', [UsersController::class, 'index']);
            Route::get('/{id}', [UsersController::class, 'show']);
        });

        // services routes
        Route::group(['prefix' => 'services'], function () {
            Route::post('/', [ServiceController::class, 'store']);
            Route::put('/{id}', [ServiceController::class, 'update']);
            Route::delete('/{id}', [ServiceController::class, 'destroy']);
        });

        // actions routes
        Route::group(['prefix' => 'actions'], function () {
            Route::post('/', [ActionController::class, 'store']);
            Route::put('/{id}', [ActionController::class, 'update']);
            Route::delete('/{id}', [ActionController::class, 'destroy']);
        });

        // reactions routes
        Route::group(['prefix' => 'reactions'], function () {
            Route::post('/', [ReactionController::class, 'store']);
            Route::put('/{id}', [ReactionController::class, 'update']);
            Route::delete('/{id}', [ReactionController::class, 'destroy']);
        });
    });
});

Route::any('{any}', function(){
    return response()->json([
        'status'    => false,
        'message'   => 'Route Not Found.',
    ], 404);
})->where('any', '.*');
