<?php

namespace App\Http\Controllers\user;


use App\Models\User;
use App\Repositories\Contracts\IFcm_Token;
use App\Repositories\Contracts\IUser;
use App\Traits\HttpResponse;
use Illuminate\Http\Request;
use Jenssegers\Agent\Agent;

class FCMTokenController
{
    use HttpResponse;
    protected $user, $fcm_token;

    public function __construct(IUser $user,IFcm_Token $fcm_token) {
        $this->user = $user;
        $this->fcm_token = $fcm_token;
    }
    public function sendToken(Request $request): \Illuminate\Http\Response//: \Illuminate\Http\Response
    {
        $token = $request->input('token');
        $user = $this->user->find(auth()->user()->id);
        $agent = new Agent();

        //processing mobile tokens
        if($agent->isAndroidOS()){
            $this->fcm_token->create(['user_id'=>$user->id,'fcm_token'=>$token,'device'=>'android']);
        }

        //processing web tokens
        else {
            $userToken = $this->fcm_token->checkByTwoConditions('device', $agent->browser(), 'user_id', $user->id)->get();
            if ($userToken->isEmpty()) {
                $this->fcm_token->create(['user_id' => $user->id, 'fcm_token' => $token, 'device' => $agent->browser()]);
            }
            else if (!$userToken->isEmpty()) {
                if($userToken->first() == $token)
                    return self::returnData('fcm_token',$token,'token do not need to update',200);
                else
                     $this->fcm_token->delete($userToken->first()->id);
                     $this->fcm_token->create(['user_id' => $user->id, 'fcm_token' => $token, 'device' => $agent->browser()]);
            }
        }
       return self::returnData('fcm_token',$token,'token updated successfully',200);
    }
}
