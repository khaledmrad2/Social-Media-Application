<?php

namespace App\Http\Resources\Friend;

use App\Repositories\Eloquent\FriendRepository;
use Illuminate\Http\Resources\Json\JsonResource;

class SuggestedFriendsResource extends JsonResource
{
    public function toArray($request)
    {
        $friend = new FriendRepository();
        return [
            'id' => $this->id,
            'name' => $this->name,
            'picture' => $this->picture,
            'cover' => $this->cover,
            'location' => $this->location,
            'job_title' => $this->job_title,
            'isFriend' => $friend->isFriend($this),
        ];
    }
}
