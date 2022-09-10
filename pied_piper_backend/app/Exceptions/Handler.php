<?php

namespace App\Exceptions;

use App\Traits\HttpResponse;
use Exception;
use GuzzleHttp\Exception\ConnectException;

use Illuminate\Auth\Access\AuthorizationException;
use Illuminate\Database\QueryException;
use Illuminate\Foundation\Exceptions\Handler as ExceptionHandler;
use Symfony\Component\HttpKernel\Exception\AccessDeniedHttpException;
use Symfony\Component\HttpKernel\Exception\BadRequestHttpException;
use Symfony\Component\HttpKernel\Exception\HttpException;
use Symfony\Component\HttpKernel\Exception\NotFoundHttpException;
use Throwable;

class Handler extends ExceptionHandler
{
    use HttpResponse;
    /**
     * A list of the exception types that are not reported.
     *
     * @var string[]
     */
    protected $dontReport = [
        //
    ];

    /**
     * A list of the inputs that are never flashed for validation exceptions.
     *
     * @var string[]
     */
    protected $dontFlash = [
        'current_password',
        'password',
        'password_confirmation',
    ];

    /**
     * Register the exception handling callbacks for the application.
     *
     * @return void
     */
    public function register()
    {
        $this->renderable(function (AccessDeniedHttpException $e, $request) {
            return self::failure('this action is unauthorized', 403);
        });

        $this->renderable(function (NotFoundHttpException $e, $request) {
            return self::failure('not found', 404);
        });
        $this->renderable(function (ConnectException $e, $request) {
            return self::failure('check your internet connection', 502);
        });

        $this->renderable(function (BadRequestHttpException $e, $request) {
            return self::failure('wrong data, check your request', 400);
        });

        $this->renderable(function ( Exception $e, $request) {
            if($e instanceof HttpException && $e->getStatusCode() == 403){
                 return self::failure('Access denied', 403);
            }
        });

        $this->renderable(function (AccessDeniedHttpException $e, $request) {
            return self::failure('this action is unauthorized', 403);
        });
    }


}
