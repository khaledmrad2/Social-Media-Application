<?php

namespace App\Http\Resources\Admin\AdminTables;

use App\Http\Resources\Post\Post_ImagesResource;
use App\Repositories\Eloquent\CommentRepository;
use App\Repositories\Eloquent\GroupRepository;
use App\Repositories\Eloquent\PostRepository;
use App\Repositories\Eloquent\ReactionRepository;
use App\Repositories\Eloquent\Saved_PostRepository;
use App\Repositories\Eloquent\SharedPostRepository;
use App\Repositories\Eloquent\UserRepository;
use Illuminate\Http\Resources\Json\JsonResource;

class PostTableResource extends JsonResource
{

    public function toArray($request)
    {
        $user = new UserRepository();
        $reaction = new ReactionRepository();
        $user = $user->find($this->user_id);
        $ReactionsData = $reaction->reactionsType($this);
        return [
            'id' => $this->id,
            'user_name' => $user->name,
            'group_id' => $this->group_id,
            'text'=> $this->text,
            'images' =>  Post_ImagesResource::collection($this->post_images),
            'voice_record'=>$this->voice_record,
            'video' => $this->video
        ];
    }
}
