<?php

namespace App\Traits;

trait HttpResponse
{
    public static function success($message,$status):\Illuminate\Http\Response
    {
        return response([
            'success'=>true,
            'message'=>$message,
        ],$status);
    }

    public static function failure($message,$status):\Illuminate\Http\Response
    {
        return response([
            'success'=>false,
            'message'=>$message,
        ],$status);
    }

    public static function returnData($key, $value, $message, $status): \Illuminate\Http\Response
    {
        return response([
            'success' => true,
            'message' => $message,
            $key => $value
        ],$status);
    }
}
