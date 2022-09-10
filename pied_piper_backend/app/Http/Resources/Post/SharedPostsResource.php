<?php

namespace App\Http\Resources\Post;

use App\Repositories\Eloquent\PostRepository;
use App\Repositories\Eloquent\UserRepository;
use Illuminate\Http\Resources\Json\JsonResource;

class SharedPostsResource extends JsonResource
{
    /**
     * Transform the resource into an array.
     *
     * @param  \Illuminate\Http\Request  $request
     * @return array|\Illuminate\Contracts\Support\Arrayable|\JsonSerializable
     */
    public function toArray($request)
    {
        $user = new UserRepository();
        $user = $user->find($this->user_id);
        $post = new PostRepository();
        $post = $post->find($this->post_id);
        return [
            'shared_post_id'=>$this->id,
            'user_name'=>$user->name,
            'user_picture'=>$user->picture,
            'user_cover'=>$user->cover,
            'user_id'=>$user->id,
            'post'=>new PostFormatResource($post)
        ];
    }
}
