<?php

namespace App\Http\Middleware\Google;

use Closure;
use Illuminate\Http\Request;

class VerifyGoogleTokenMiddleware
{
    public function handle(Request $request, Closure $next)
    {
        $user = $request->user();

        if (!$user || !isset($user->google_token)) {
            return response()->json(['message' => 'Unauthorized. Google token is missing.'], 401);
        }

        return $next($request);
    }
}
