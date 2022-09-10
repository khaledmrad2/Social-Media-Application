<?php

namespace App\Http\Resources\Post;

use App\Repositories\Eloquent\CommentRepository;
use App\Repositories\Eloquent\ReactionRepository;
use App\Repositories\Eloquent\UserRepository;
use Illuminate\Http\Resources\Json\JsonResource;

class CommentResource extends  JsonResource
{
    public function toArray($request)
    {
        $reaction = new ReactionRepository();
        $user1 = new UserRepository();
        $user = $user1->find($this->user_id);
        $comment = new CommentRepository();
        return [
            'is_visitor'=> $comment->isVisitor($this->id),
            'comment_id'=>$this->id,
            'user_id'=>$user->id,
            'user_picture' => $user->picture,
            "user_name" => $user->name,
            'post_id'=>$this->post_id,
            'image'=>$this->image,
            'text'=>$this->text,
            'created_at'=>$this->created_at,
            'updated_at'=>$this->updated_at,
            'reactions'=>ReactionResource::collection($this->reactions()->get()),
            'reactionsCount'=>$reaction->count('comment',$this->id),
            'isReaction'=>$reaction->isReaction("comment",$this->id),
            'myReactionType'=>$reaction->myReactionType("comment",$this->id),
        ];
    }

}
