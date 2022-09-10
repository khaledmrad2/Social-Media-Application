<?php

namespace App\Http\Controllers\Auth;

use App\Http\Controllers\Controller;
use App\Http\Requests\Auth\EmailRequest;
use App\Mail\SendCode;
use App\Repositories\Contracts\ICode;
use App\Repositories\Contracts\IUser;
use App\Traits\HttpResponse;
use Illuminate\Support\Facades\Mail;

class SendCodeController extends Controller
{
    use HttpResponse;

    private $user, $code, $action;

    public function __construct(IUser $user, ICode $code)
    {
        $this->user = $user;
        $this->code = $code;
    }

    /**
     * @OA\Post(
     * path="/api/code/{type}",
     * operationId="sendCode",
     * tags={"Authentication"},
     * summary="send code to user",
     * description="sending code code",
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
     *               required={"email"},
     *               @OA\Property(property="email", type="email"),
     *            ),
     *        ),
     *    ),
     *      @OA\Response(
     *          response=200,
     *          description="sended successfully",
     *          @OA\JsonContent()
     *       ),
     * )
     */
    public function sendCode(EmailRequest $request, $type): \Illuminate\Http\Response
    {
        // checking if user exists
         $email = $this->user->findWhere('email', $request->all());
         if($email->isEmpty())
             return self::failure('email not found!',404);

        // generating new code process
        $this->code->generateCode($request->email, $type);

        return self::success('code sent successfully', 200);
    }
}
