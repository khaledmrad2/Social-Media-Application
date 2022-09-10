<?php

namespace App\Http\Controllers\Post;

use App\Http\Controllers\Controller;
use App\Http\Resources\Post\SharedPostsResource;
use App\Repositories\Contracts\IPost;
use App\Repositories\Contracts\ISharedPost;
use App\Repositories\Contracts\IUser;
use App\Traits\HttpResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\App;

class SharedPostsController extends Controller
{
    use HttpResponse;
    protected $user , $post , $sharedPost;
    public function __construct(IUser $user , IPost $post, ISharedPost $sharedPost ){
        $this->user = $user;
        $this->post =$post;
        $this->sharedPost =$sharedPost;

    }
    /**
     * @OA\Post(
     * path="/api/post/sharePost/{post_id}",
     * operationId="shere_post",
     * tags={"shared posts"},
     * summary="shere post",
     * description="User shere saved  here",
     * security={{"JWT":{}}},
     *   @OA\Parameter(
     *         name="post_id",
     *         in="path",
     *         description="post_id of the post that you want to shere",
     *         required=true,
     *      ),
     *     @OA\RequestBody(
     *         @OA\JsonContent(),
     *         @OA\MediaType(
     *            mediaType="multipart/form-data",
     *            @OA\Schema(
     *               type="object",
     *               required={},
     *            ),
     *        ),
     *    ),
     *      @OA\Response(
     *          response=200,
     *          description="post sherded successfully!",
     *          @OA\JsonContent()
     *       ),
     * )
     */
    public function create($post) : \Illuminate\Http\Response
    {
        $user = auth()->user();
        $post = $this->post->find($post);
        $data['user_id'] = $user->id;
        $data['post_id'] = $post->id;
        $post = $this->sharedPost->create($data);
        return self::returnData('post', new SharedPostsResource($post),'post shared successfully',200);
    }

    /**
     *  @OA\delete(
     *      path="/api/post/deleteSharedPost/{SharedPost_id}",
     *      operationId="delete_shaerdPost",
     *      tags={"shared posts"},
     *      summary="delete sharedpost",
     *      security={{"JWT":{}}},
     *      @OA\Parameter(
     *         name="SharedPost_id",
     *         in="path",
     *         description="id of SharedPost you want to delete",
     *         required=true,
     *      ),
     *      @OA\Response(
     *          response=200,
     *          description="SharedPost deleted",
     *      ),
     *      @OA\Response(
     *          response="401",
     *          description="unauthorized."
     *      ),
     *  )
     */
    public function delete($sharedPost){
        $user = auth()->user();
        $sharedPost = $this->sharedPost->find($sharedPost);
        if ($user->cannot('delete', $sharedPost)) {
            App::abort(403, 'Access denied');
        }
        $this->sharedPost->delete($sharedPost->id);
        return self::success("shared post deleted successfully",200);

    }
}
