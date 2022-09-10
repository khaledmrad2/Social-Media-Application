<?php

namespace App\Http\Resources\Admin;

use App\Http\Resources\friend\FriendResource;
use App\Http\Resources\Post\PostFormatResource;
use App\Http\Resources\Post\SharedPostsResource;
use Illuminate\Http\Resources\Json\JsonResource;

class AUserResource extends JsonResource
{
    public function toArray($request): array
    {
        return [
            'id' => $this->id,
            'name' => $this->name,
            'email' => $this->email,
            'picture' => $this->picture,
            'cover' => $this->cover,
            'available_to_hire' => $this->available_to_hire,
            'location' => $this->location,
            'job_title' => $this->job_title,
        ];
    }
}
