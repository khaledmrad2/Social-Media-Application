<?php

namespace App\Http\Resources\Group;

use App\Repositories\Eloquent\GroupRepository;
use App\Repositories\Eloquent\UserRepository;
use Illuminate\Http\Resources\Json\JsonResource;

class UGResource extends JsonResource
{
    public function toArray($request): array
    {
        $user = new UserRepository();
        $group = new GroupRepository();
        $IUser = $user->find($this->receiver_id);
        $IGroup = $group->find($this->group_id);
        return [
            "user_id" => $IUser->id,
            "user_name" => $IUser->name,
            "user_picture" => $IUser->picture,
            "group_id" => $IGroup->id,
            "group_title" => $IGroup->title,
        ];
    }
}
