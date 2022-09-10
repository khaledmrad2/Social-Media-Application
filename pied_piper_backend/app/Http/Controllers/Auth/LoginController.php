<?php

namespace App\Http\Controllers\Auth;

use App\Http\Controllers\Controller;
use App\Http\Requests\Auth\LoginRequest;
use App\Http\Resources\auth\LoggedInUserResource;
use App\Http\Resources\UserResource;
use App\Traits\HttpResponse;
use Illuminate\Contracts\Auth\MustVerifyEmail;
use Illuminate\Support\Facades\Auth;

class LoginController extends Controller
{
    use HttpResponse;

    /**
     * @OA\Post(
     * path="/api/login/{role}",
     * operationId="2",
     * tags={"Authentication"},
     * summary="User login",
     * description="User login here",
     *   @OA\Parameter(
     *         name="role",
     *         in="path",
     *         description="user or admin",
     *         required=true,
     *      ),
     *     @OA\RequestBody(
     *         @OA\JsonContent(),
     *         @OA\MediaType(
     *            mediaType="multipart/form-data",
     *            @OA\Schema(
     *               type="object",
     *               required={"email", "password"},
     *               @OA\Property(property="email", type="text"),
     *               @OA\Property(property="password", type="password"),
     *            ),
     *        ),
     *    ),
     *      @OA\Response(
     *          response=200,
     *          description="loggedin successfully",
     *          @OA\JsonContent()
     *       ),
     * )
     */
    public function login(LoginRequest $request, $role): \Illuminate\Http\Response
    {
        $token = Auth::guard($role)->attempt($request->all());

        if (!$token) {
            return self::failure("wrong password or email, please check your inputs again", 403);
        }

        $user = Auth::guard($role)->user();

        //check if the user has verified his email
        if($user instanceof MustVerifyEmail && ! $user->hasVerifiedEmail()) {
            return self::failure('please verify your email then try again', 422);
        }

        $user['token'] = $token;

        return self::returnData('user', new LoggedInUserResource($user),'logged in successfully',200);
    }

}
