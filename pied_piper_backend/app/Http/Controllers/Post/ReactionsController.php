<?php

namespace App\Http\Controllers\Post;

use App\Http\Controllers\Controller;
use App\Http\Requests\Post\ReactionRequest;
use App\Http\Resources\Post\ReactionResource;
use App\Repositories\Contracts\IComment;
use App\Repositories\Contracts\IPost;
use App\Repositories\Contracts\IReaction;
use App\Repositories\Contracts\IUser;
use App\Traits\HttpResponse;
use App\Traits\Notifications;
use Illuminate\Http\Request;

class ReactionsController extends Controller
{
    use HttpResponse, Notifications;
    protected $user , $comment , $post , $reaction;
    public function __construct(IUser $user , IComment $comment , IPost $post , IReaction $reaction){
        $this->user = $user;
        $this->comment =$comment;
        $this->post = $post;
        $this->reaction = $reaction;
    }
    /**
     * @OA\Post(
     *
     * path="/api/reaction/toggle/{type}/{id}",
     * operationId="create/delete/updeate_reaction",
     * tags={"reactions"},
     * summary="create/delete/updeate comment",
     * description="User create/delete/updeate reactions here",
     * security={{"JWT":{}}},
     *   @OA\Parameter(
     *         name="type",
     *         in="path",
     *         description="the type of reaction (post or comment)",
     *         required=true,
     *         name="id",
     *         in="path",
     *         description="the id of post/comment you want create reaction on",
     *         required=true,
     *      ),
     *     @OA\RequestBody(
     *         @OA\JsonContent(),
     *         @OA\MediaType(
     *            mediaType="multipart/form-data",
     *            @OA\Schema(
     *               type="object",
     *               required={},
     *               @OA\Property(property="type", type="text"),
     *            ),
     *        ),
     *    ),
     *      @OA\Response(
     *          response=200,
     *          description="reaction created successfully!",
     *          @OA\JsonContent()
     *       ),
     * )
     */

    public function toggle(ReactionRequest $request,$type,$id){
        $data = $request ->all();
        $user = auth()->user();

        //Processing post case
        if($type == "post") {
           $post =  $this->post->find($id);
           $PostReaction =  $this->reaction->findWhereType($post,'user_id',$user->id);
            if($PostReaction->isEmpty()){
                $data['user_id'] = $user->id;
                $data['reactionable_id'] = $post->id;
                $data['reactionable_type']  = $post::class;
                $PostReaction = $this->reaction->create($data);
                self::PostNotification($post->user_id,'post_reaction',$PostReaction->id);
                return self::returnData('reaction',new ReactionResource($PostReaction),'reaction created successfully',200);
            }

            else if(!$PostReaction->isEmpty() && array_key_exists('type',$data)){
                 $this->reaction->forceFill($data,$PostReaction->first()->id);
                return self::success('reaction updated successfully',200);

            }
            else {
                 $this->reaction->delete($PostReaction->first()->id);
                return self::success("reaction deleted successfully",200);
            }
        }

        //Processing comment case
        if($type == "comment") {
            $comment =  $this->comment->find($id);
            $CommentReaction =  $this->reaction->findWhereType($comment,'user_id',$user->id);
            if($CommentReaction->isEmpty()){
                $data['user_id'] = $user->id;
                $data['reactionable_id'] = $comment->id;
                $data['reactionable_type']  = $comment::class;
                $CommentReaction = $this->reaction->create($data);
                self::PostNotification($comment->user_id,'comment_reaction',$CommentReaction->id);
                return self::returnData('reaction',new ReactionResource($CommentReaction),'reaction created successfully',200);
            }
            else if(!$CommentReaction->isEmpty() && array_key_exists('type',$data)){
                 $this->reaction->forceFill($data,$CommentReaction->first()->id);
                return self::success('reaction updated successfully',200);

            }
            else {
                $this->reaction->delete($CommentReaction->first()->id);
                return self::success("reaction deleted successfully",200);
            }
        }

        return self::failure("check your type",400);

        }
        public function allPostReactions($id): \Illuminate\Http\Response
        {
        $post = $this->post->find($id);
        return self::returnData('allReactions',ReactionResource::collection($post->reactions),'all reactions on the post',200);

        }




}
