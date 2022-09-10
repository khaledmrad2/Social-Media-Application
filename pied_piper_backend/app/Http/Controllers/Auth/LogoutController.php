<?php

namespace App\Http\Controllers\Auth;

use App\Http\Controllers\Controller;
use App\Repositories\Contracts\IFcm_Token;
use App\Repositories\Contracts\IUser;
use App\Traits\HttpResponse;
use Illuminate\Http\Request;
use Jenssegers\Agent\Agent;
use Tymon\JWTAuth\Exceptions\TokenInvalidException;
use Tymon\JWTAuth\Facades\JWTAuth;

class LogoutController extends Controller
{
    use HttpResponse;
    protected $user, $fcm_token;

    public function __construct(IUser $user,IFcm_Token $fcm_token) {
        $this->user = $user;
        $this->fcm_token = $fcm_token;
    }

    /**
     * @OA\Post(
     * path="/api/logout",
     * operationId="logout",
     * tags={"Authentication"},
     * summary="logout user / admin",
     *      @OA\Response(
     *          response=200,
     *          description="logged out",
     *          @OA\JsonContent()
     *       ),
     * )
     */
    public function logout(Request $request): \Illuminate\Http\Response
    {
        // take the token from the header __auth token
        $token = $request->bearerToken();
        $agent = new Agent();
        $user = $this->user->find(auth()->user()->id);

        // return error if token fails
        if (!$token) {
            return self::failure('something went wrong', 422);
        }

        // delete the token if it's true
        try {
            JWTAuth::setToken($token)->invalidate();
        } catch (TokenInvalidException $ex) {
            return self::failure('some thing went wrong', 422);
        }

        if($agent->isAndroidOS()){
            $this->fcm_token->findAndDelete2('device','android','user_id',$user->id);
        }
        else
            $this->fcm_token->findAndDelete2('device',$agent->browser(),'user_id',$user->id);

        return self::success('logged out successfully', 200);
    }
}
