<?php

namespace App\Http\Resources\Admin\AdminTables;

use App\Repositories\Eloquent\CommentRepository;
use App\Repositories\Eloquent\UserRepository;
use Illuminate\Http\Resources\Json\JsonResource;

class CommentsTableResource extends JsonResource
{

    public function toArray($request)
    {
        $user1 = new UserRepository();
        $user = $user1->find($this->user_id);
        $comment = new CommentRepository();

        return [
            'id'=>$this->id,
            "user_name" => $user->name,
            'image'=>$this->image,
            'post_id'=>$this->post_id,
            'text'=>$this->text,
        ];
    }
}
