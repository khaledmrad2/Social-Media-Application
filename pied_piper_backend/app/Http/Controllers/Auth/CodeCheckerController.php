<?php

namespace App\Http\Controllers\Auth;

use App\Http\Controllers\Controller;
use App\Http\Requests\Auth\CodeRequest;
use App\Http\Requests\Auth\EmailRequest;
use App\Http\Requests\Auth\PasswordRequest;
use App\Repositories\Contracts\ICode;
use App\Repositories\Contracts\IUser;
use App\Traits\HttpResponse;

class CodeCheckerController extends Controller
{
    use HttpResponse;

    private $user, $code, $resetRequest, $resendRequest;

    public function __construct(IUser $user, ICode $code)
    {
        $this->user = $user;
        $this->code = $code;
    }

    private function typeChecker($email, $type, $pRequest) {
        if ($type == 'reset') {
            $this->user->forceFillPassword($email, ["password" => bcrypt($pRequest->password)]);
        } else if ($type == 'send') {
            $this->user->findAndVerify($email);
        }
    }

    /**
     * @OA\Post(
     * path="/api/check/{type}",
     * operationId="check",
     * tags={"Authentication"},
     * summary="check if code is true for reset / send",
     * description="Uchecking from code",
     *   @OA\Parameter(
     *         name="type",
     *         in="path",
     *         description="reset or send",
     *         required=true,
     *      ),
     *     @OA\RequestBody(
     *         @OA\JsonContent(),
     *         @OA\MediaType(
     *            mediaType="multipart/form-data",
     *            @OA\Schema(
     *               type="object",
     *               required={"code"},
     *               @OA\Property(property="code", type="integer"),
     *               @OA\Property(property="password", type="password"),
     *               @OA\Property(property="password_confirmation", type="password"),
     *            ),
     *        ),
     *    ),
     *      @OA\Response(
     *          response=200,
     *          description="operation done",
     *          @OA\JsonContent()
     *       ),
     * )
     */
    public function check(CodeRequest $request, PasswordRequest $pRequest, $type): \Illuminate\Http\Response
    {
        // find the code
        $code = $this->code->findExpiredCode('code', $request->code, 'type', $type);

        // processing the action __reset __verify
        $this->typeChecker($code->email, $type, $pRequest);

        // delete current code
        $this->code->delete($code->id);

        return self::success('action done', 200);
    }
}
