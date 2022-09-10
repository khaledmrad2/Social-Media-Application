<?php

namespace App\Repositories\Eloquent;

use App\Models\GroupRequestReceiver;
use App\Repositories\Contracts\IGroupRequestReceiver;

class GroupRequestReceiverRepository extends BaseRepository implements IGroupRequestReceiver
{
    public function model(): string
    {
        return GroupRequestReceiver::class;
    }

    public function insertAsReceiver($group, $user_id)
    {
        if ($group->user_id == $user_id) {
            return $group->GroupRequestReceivers()->save(new $this->model(["user_id" => $user_id, "requester_id" => auth()->user()->id, "type" => "normal"]));
        } else {
            return $group->GroupRequestReceivers()->save(new $this->model(["user_id" => $user_id, "requester_id" => auth()->user()->id, "type" => "invite"]));
        }
    }
}
