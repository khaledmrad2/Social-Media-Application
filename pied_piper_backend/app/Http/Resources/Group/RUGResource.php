<?php

namespace App\Http\Resources\Group;

use App\Repositories\Eloquent\GroupRepository;
use App\Repositories\Eloquent\UserRepository;
use Illuminate\Http\Resources\Json\JsonResource;

class RUGResource extends JsonResource
{
    public function toArray($request): array
    {
        $user = new UserRepository();
        if ($this->friend_id) {
            $RUser = $user->find($this->friend_id);
        }
        else {
            $RUser = $user->find($this->user_id);
        }
        return [
            "user_id" => $RUser->id,
            "user_name" => $RUser->name,
            "user_picture" => $RUser->picture,
        ];
    }
}
