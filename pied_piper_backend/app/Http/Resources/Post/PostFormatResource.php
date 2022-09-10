<?php

namespace App\Http\Resources\Post;

use App\Http\Resources\user\UserResource;
use App\Models\Saved_Post;
use App\Repositories\Eloquent\CommentRepository;
use App\Repositories\Eloquent\GroupRepository;
use App\Repositories\Eloquent\PostRepository;
use App\Repositories\Eloquent\ReactionRepository;
use App\Repositories\Eloquent\Saved_PostRepository;
use App\Repositories\Eloquent\SharedPostRepository;
use App\Repositories\Eloquent\UserRepository;
use Illuminate\Http\Resources\Json\JsonResource;

class PostFormatResource extends JsonResource
{
    public function toArray($request): array
    {
        $user = new UserRepository();
        $reaction = new ReactionRepository();
        $comment = new CommentRepository();
        $group = new GroupRepository();
        $saved_post = new Saved_PostRepository();
        $shared_post = new SharedPostRepository();
        $post = new PostRepository();
        $user = $user->find($this->user_id);
        $ReactionsData = $reaction->reactionsType($this);

        return [
            'is_visitor'=> $post->isVisitor($this),
            'is_saved_post'=>$saved_post->check($this),
            'is_shared_post'=>$this->is_shared_post!=null?$this->is_shared_post:false,
            'shared_user_id'=>$this->shared_user_id,
            'shared_post_id'=>$this->shared_post_id,
            'shared_user_name'=>$this->shared_user_name,
            'shared_user_picture'=>$this->shared_user_picture,
            'is_the_post_shared'=>$shared_post->checkIfShared($this),
            'shared_count'=>$shared_post->count($this),
            'admin_id'=> $this->group_id ? $group->find($this->group_id)->user_id : null,
            'group_name'=>$this->group_id?$group->find($this->group_id)->title:null,
            'group_cover'=>$this->group_id?$group->find($this->group_id)->cover:null,
            'is_admin' => $group->checkFromAdmin($this->group_id),
            'post_id' => $this->id,
            'user_id' => $user->id,
            'user_name' => $user->name,
            'user_picture' => $user->picture,
            'user_cover' => $user->cover,
            'user_job_title' => $user->job_title,
            'user_email' => $user->email,
            'user_location' => $user->location,
            'user_hire' => $user->available_to_hire,
            'group_id' => $this->group_id,
            'text'=> $this->text,
            'type'=>$this->type,
            'background'=>$this->background,
            'video'=>$this->video,
            'voice_record'=>$this->voice_record,
            'created_at'=>$this->created_at,
            'updated_at'=>$this->updated_at,
            'images'=>Post_ImagesResource::collection($this->post_images()->get()),
            'commentsCount'=>$comment->commentsCount($this),
            'comments'=>CommentResource::collection($this->comments()->get()),
            'reactions'=>ReactionResource::collection($this->reactions()->get()),
            'AllReactionsCount'=>$reaction->count('post',$this->id),
            'likeCount'=>['type'=>'like','count'=>$ReactionsData['like']],
            'loveCount'=>['type'=>'love','count'=>$ReactionsData['love']],
            'angryCount'=>['type'=>'angry','count'=>$ReactionsData['angry']],
            'sadCount'=>['type'=>'sad','count'=>$ReactionsData['sad']],
            'hahaCount'=>['type'=>'haha','count'=>$ReactionsData['haha']],
            'isReaction'=>$reaction->isReaction("post",$this->id),
            'myReactionType'=>$reaction->myReactionType("post",$this->id),

        ];
    }
}
