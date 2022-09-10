<?php

namespace App\Http\Controllers\Post;

use App\Http\Controllers\Controller;
use App\Http\Resources\Post\PostFormatResource;
use App\Repositories\Contracts\IPost;
use App\Repositories\Contracts\ISaved_Post;
use App\Repositories\Contracts\IUser;
use App\Traits\HttpResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\App;

class SavedPostsController extends Controller
{
    use HttpResponse;
    protected $user,$post,$saved_post;
    public function __construct(IUser $user ,IPost $post, ISaved_Post $saved_Post ){
        $this->user = $user;
        $this->post = $post;
        $this->saved_post = $saved_Post;

    }
    /**
     * @OA\Post(
     * path="/api/post/savePost/{Post_id}",
     * operationId="create_saved_post",
     * tags={"saved posts"},
     * summary="create saved post",
     * description="User create saved post here",
     * security={{"JWT":{}}},
     *   @OA\Parameter(
     *         name="post_id",
     *         in="path",
     *         description="post_id of the post that you want to save",
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
     *          description="saved post created successfully!",
     *          @OA\JsonContent()
     *       ),
     * )
     */
    public function create($post): \Illuminate\Http\Response
    {
        $data = [];
        $user = auth()->user();
        $post = $this->post->find($post);
        if($this->saved_post->check($post)){
            return self::failure("you are already saved this post",400);
        }
        $data['user_id'] = $user->id;
        $data['post_id'] = $post->id;
        $this->saved_post->create($data);
        return self::success("post saved successfully",200);
    }




    /**
     *  @OA\Get(
     *      path="/api/post/mySavedPosts",
     *      operationId="SavedPosts",
     *      tags={"saved posts"},
     *      summary="get all Saved posts",
     *      security={{"JWT":{}}},
     *      @OA\Response(
     *          response=200,
     *          description="all Saved posts",
     *      ),
     *      @OA\Response(
     *          response="401",
     *          description="unauthorized."
     *      ),
     *  )
     */

    public function getMySavedPost(): \Illuminate\Http\Response
    {
        $user = auth()->user();
        $saved_posts = $this->saved_post->findWhere('user_id',$user->id);
        $data = [];
        foreach($saved_posts as $post){
            array_push($data , (object)($this->post->find($post->post_id)));
        }
        return self::returnData('saved_posts',PostFormatResource::collection($data),'your saved posts',200);
    }

    /**
     *  @OA\delete(
     *      path="/api/post/DeleteSavedPost/{SavedPost_id}",
     *      operationId="delete_SavedPost",
     *      tags={"saved posts"},
     *      summary="delete Savedpost",
     *      security={{"JWT":{}}},
     *      @OA\Parameter(
     *         name="SavedPost_id",
     *         in="path",
     *         description="id of Savedpost you want to delete",
     *         required=true,
     *      ),
     *      @OA\Response(
     *          response=200,
     *          description="saved post deleted",
     *      ),
     *      @OA\Response(
     *          response="401",
     *          description="unauthorized."
     *      ),
     *  )
     */

    public function delete($post_id):\Illuminate\Http\Response
{
        $user = auth()->user();
        $post = $this->post->find($post_id);
        $savedPost = $this->saved_post->FindMySavedPost($user->id,$post->id);
        if($user->cannot('delete',$savedPost))
            App::abort(403, 'Access denied');
        $this->saved_post->delete($savedPost->id);
        return self::success("saved post deleted successfully",200);
    }
}
