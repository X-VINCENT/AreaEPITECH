<?php

namespace App\Http\Middleware\Google;

use Closure;
use Illuminate\Http\Request;

class AdminRole
{
    /**
     * Handle an incoming request.
     *
     * @param  Request  $request
     * @param  Closure  $next
     * @return mixed
     */
    public function handle(Request $request, Closure $next): mixed
    {
        if ($request->user() && $request->user()->hasRole('admin')) {
            return $next($request);
        }

        return response()->json(['error' => 'Unauthorized (admin role required)'], 403);
    }
}
