<?php

namespace App\Repositories\Eloquent;

use App\Models\GroupRequest;
use App\Repositories\Contracts\IGroupRequest;

class GroupRequestRepository extends BaseRepository implements IGroupRequest
{
    public function model(): string
    {
        return GroupRequest::class;
    }

    public function insertAsRequester($group, $user_id)
    {
        if ($group->user_id == $user_id) {
            return $group->GroupRequests()->save(new $this->model(["user_id" => auth()->user()->id, "receiver_id" => $user_id, "type" => "normal"]));
        } else {
            return $group->GroupRequests()->save(new $this->model(["user_id" => auth()->user()->id, "receiver_id" => $user_id, "type" => "invite"]));
        }
    }
}
