<?php

namespace App\Http\Middleware\Auth;

use App\Traits\HttpResponse;
use Closure;
use Illuminate\Http\Request;
use Tymon\JWTAuth\Exceptions\TokenExpiredException;
use Tymon\JWTAuth\Exceptions\JWTException;
use Tymon\JWTAuth\Facades\JWTAuth;
use Tymon\JWTAuth\Http\Middleware\BaseMiddleware;

class AssignGuard extends BaseMiddleware
{
    use HttpResponse;

    public function handle(Request $request, Closure $next, $guard = null)
    {
        if ($guard !== null) {
            auth()->shouldUse($guard);

            $request->bearerToken();

            // try to parse the token to authenticate the user
            try {
                JWTAuth::parseToken()->authenticate();
            } catch (TokenExpiredException | JWTException $e) {
                return self::failure('Unauthenticated User', 401);
            }
        }
        return $next($request);
    }
}
