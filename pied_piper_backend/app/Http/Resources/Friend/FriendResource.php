<?php

namespace App\Http\Resources\friend;

use App\Repositories\Eloquent\UserRepository;
use Illuminate\Http\Resources\Json\JsonResource;

class FriendResource extends JsonResource
{
    public function toArray($request): array
    {
        $user = new UserRepository();
        $friend = $user->find($this->friend_id);
        return [
            'id' => $this->friend_id,
            'name' => $friend->name,
            'picture' => $friend->picture,
        ];
    }
}
