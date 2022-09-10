<?php

namespace App\Http\Resources\Story;

use App\Repositories\Eloquent\StoryRepository;
use App\Repositories\Eloquent\UserRepository;
use Illuminate\Http\Resources\Json\JsonResource;

class StoryResource extends JsonResource
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
        $story = new StoryRepository();
        return [
            'id'=>$this->id,
            'is_visitor'=> $story->isVisitor($this),
            'text'=>$this->text,
            'image_url'=>$this->image,
            'user'=>$user,
        ];
    }

}
