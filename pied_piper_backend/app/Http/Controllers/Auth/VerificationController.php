<?php

namespace App\Http\Controllers\Auth;

use App\Events\Registered;
use App\Http\Controllers\Controller;
use App\Http\Requests\Auth\EmailRequest;
use App\Models\User;
use App\Repositories\Contracts\ICode;
use App\Repositories\Contracts\IUser;
use App\Traits\HttpResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\URL;

class VerificationController extends Controller
{
    use HttpResponse;

    private $user, $code;

    public function __construct(IUser $user, ICode $code)
    {
        $this->user = $user;
        $this->code = $code;
    }

    private $mailRequest, $verifyRequest;

    /**
     * @OA\Post(
     * path="/verify/{user}'",
     * operationId="verify",
     * tags={"Authentication"},
     * summary="verify user web",
     * description="verify user",
     *   @OA\Parameter(
     *         name="id",
     *         in="path",
     *         description="user id",
     *         required=true,
     *      ),
     *     @OA\RequestBody(
     *         @OA\JsonContent(),
     *         @OA\MediaType(
     *            mediaType="multipart/form-data",
     *            @OA\Schema(
     *               type="object",
     *               required={"signature", "expires"},
     *               @OA\Property(property="signature", type="text"),
     *               @OA\Property(property="expires", type="text"),
     *            ),
     *        ),
     *    ),
     *      @OA\Response(
     *          response=200,
     *          description="verified successfully",
     *          @OA\JsonContent()
     *       ),
     * )
     */
    public function verify(Request $request, User $user): \Illuminate\Http\Response
    {
        // check if the url is a valid signed url
//       if (! URL::hasValidSignature($request)) {
//           return self::failure('invalid verification link', 422);
//       }

        // check if user has already verified his Email
        if($user->hasVerifiedEmail()) {
            return self::failure('Already verified', 422);
        }

        // verify user email
        $user->markEmailAsVerified();
        return self::success('user verified successfully', 200);
    }

    /**
     * @OA\Post(
     * path="/resend/{from}'",
     * operationId="resend",
     * tags={"Authentication"},
     * summary="resend code / link to verify",
     * description="verify user",
     *   @OA\Parameter(
     *         name="from",
     *         in="path",
     *         description="web / flutter",
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
     *          description="resended successfully",
     *          @OA\JsonContent()
     *       ),
     * )
     */
    public function resend(EmailRequest $request, $from): \Illuminate\Http\Response
    {
        $user = $this->user->findWhereFirst('email', $request->email);

        // check if user has already verified his Email
        if($user->hasVerifiedEmail()) {
            return self::failure('Already verified', 422);
        }

        // send email verification
        event(new Registered($user, $from, $this->code));

        return self::success('verification link sent', 200);
    }
}
