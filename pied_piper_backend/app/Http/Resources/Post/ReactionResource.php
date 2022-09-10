<?php

namespace App\Http\Resources\Post;

use App\Repositories\Eloquent\UserRepository;
use Illuminate\Http\Resources\Json\JsonResource;

class ReactionResource extends JsonResource
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
        return [
            'type'=>$this->type,
            'user_id'=>$this->user_id,
            'user_name'=>$user->name,
            'user_picture'=>$user->picture,
        ];
    }
}
