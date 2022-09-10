<?php

namespace App\Http\Controllers\Post;

use App\Http\Controllers\Controller;
use App\Http\Requests\Post\CommentRequest;
use App\Repositories\Contracts\IComment;
use App\Repositories\Contracts\IPost;
use App\Repositories\Contracts\IUser;
use App\Traits\Cloudinary;
use App\Traits\HttpResponse;
use App\Traits\Notifications;
use Illuminate\Http\Request;
use App\Http\Resources\Post\CommentResource;
use Illuminate\Support\Facades\App;

class CommentsController extends Controller
{
    use HttpResponse,Cloudinary, Notifications;

    protected  $comment,$user,$post;
    public function __construct(IComment $comment , IUser $user , IPost $post){
        $this->comment = $comment;
        $this->user = $user;
        $this->post = $post;
    }

    public function index($id): \Illuminate\Http\Response
    {
        return self::returnData('comments',new CommentResource($this->post->find($id)->comments()->get()), "all comments", 200);
    }

    /**
     * @OA\Post(
     * path="/api/comment/create/{post_id}",
     * operationId="create_comment",
     * tags={"Comments"},
     * summary="create comment",
     * description="User create comment here",
     * security={{"JWT":{}}},
     *   @OA\Parameter(
     *         name="post_id",
     *         in="path",
     *         description="the id of post you want comment on",
     *         required=true,
     *      ),
     *     @OA\RequestBody(
     *         @OA\JsonContent(),
     *         @OA\MediaType(
     *            mediaType="multipart/form-data",
     *            @OA\Schema(
     *               type="object",
     *               required={},
     *               @OA\Property(property="text", type="text"),
     *               @OA\Property(property="image", type="file"),
     *            ),
     *        ),
     *    ),
     *      @OA\Response(
     *          response=200,
     *          description="post created successfully!",
     *          @OA\JsonContent()
     *       ),
     * )
     */
    public function create(CommentRequest $request,$post): \Illuminate\Http\Response
    {
        $data = $request->all();
        $post = $this->post->find($post);
        if($data == null){
            return self::failure("check your data" , 400);
        }
        if(array_key_exists('image',$data)){
            $data['image'] = self::uploadImages( $data['image'] , (string)auth()->user()->id,'comments');
        }
        $data['user_id'] = auth()->user()->id;
        $data['post_id'] = $post->id;
        $comment = $this->comment->create($data);
        self::PostNotification($post->user_id,'comment',$comment->id);
      return self::returnData('comment',new CommentResource ($comment),'comment added successfully',200);
    }

    public function update(CommentRequest $request,$comment){
        $user = auth()->user();
        $data = $request->all();
        $comment = $this->comment->find($comment);
        if($user->cannot('update',$comment))
            App::abort(403, 'Access denied');

        if(array_key_exists('image',$data) && $data['image']!='null'){
            $data['image'] = self::uploadImages( $data['image'] , (string)auth()->user()->id,'comments');
            $comment =  $this->comment->update($comment->id,$data);
        }
        else if(array_key_exists('image',$data) && $data['image']=='null'){
            $data['image'] = null;
            $comment =  $this->comment->update($comment->id,$data);
        }
        else if(!array_key_exists('image',$data)){
            $comment =  $this->comment->update($comment->id,$data);
        }
        return self::returnData('comment',new CommentResource($comment),"comment updated successfully",200);

    }

    /**
     *  @OA\delete(
     *      path="/api/comment/delete/{comment_id}",
     *      operationId="delet_comment",
     *      tags={"Comments"},
     *      summary="delete comment",
     *      security={{"JWT":{}}},
     *      @OA\Parameter(
     *         name="comment_id",
     *         in="path",
     *         description="id of  comment you want to delete",
     *         required=true,
     *      ),
     *      @OA\Response(
     *          response=200,
     *          description="comment deleted",
     *      ),
     *      @OA\Response(
     *          response="401",
     *          description="unauthorized."
     *      ),
     *  )
     */
    public function delete($comment): \Illuminate\Http\Response
    {
        $user = auth()->user();
        $comment = $this->comment-> find($comment);
        if($user->cannot('delete',$comment))
            App::abort(403, 'Access denied');
        if ($comment->image) {
            self::deleteFile($comment->image);
        }
        $this->comment->delete($comment->id);
        return self::success("comment deleted successfully",200);
    }

    public function allPostComments($id): \Illuminate\Http\Response
    {
        $post = $this->post->find($id);
        return self::returnData('allComments',CommentResource::collection($post->comments),'all comments on post',200);
    }
}
