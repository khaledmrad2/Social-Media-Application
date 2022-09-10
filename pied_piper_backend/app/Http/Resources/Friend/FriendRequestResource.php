<?php

namespace App\Http\Resources\friend;

use App\Repositories\Eloquent\UserRepository;
use Illuminate\Http\Resources\Json\JsonResource;

class FriendRequestResource extends JsonResource
{
    public function toArray($request): array
    {
        $user = new UserRepository();
        $requestTo = $user->find($this->receiver_id);
        return [
            'id' => $this->receiver_id,
            'name' => $requestTo->name,
            'picture' => $requestTo->picture,
        ];
    }
}
