<?php

namespace App\Http\Resources\Admin;

use Illuminate\Http\Resources\Json\JsonResource;

class CountOfAllResource extends JsonResource
{
    /**
     * Transform the resource into an array.
     *
     * @param  \Illuminate\Http\Request  $request
     * @return array|\Illuminate\Contracts\Support\Arrayable|\JsonSerializable
     */
    public function toArray($request)
    {
        return [
            'users_count'=>$this->users,
            'posts_count'=>$this->posts,
            'comments_count'=>$this->comments,
            'stories_count'=>$this->stories,
            'groups_count'=>$this->groups,
            'complaints_count'=>$this->complaints,
            'warnings_count'=>$this->warnings,
        ];
    }
}
