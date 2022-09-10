<?php

namespace App\Repositories\Eloquent;

use App\Models\Friend;
use App\Repositories\Contracts\IFriend;

class FriendRepository extends BaseRepository implements IFriend
{
    public function model(): string
    {
        return Friend::class;
    }

    public function findFriendAndDelete($user_id, $friend_id)
    {
        $this->model->where("user_id", $user_id)
            ->where("friend_id", $friend_id)->delete();
        $this->model->where("user_id", $friend_id)
            ->where("friend_id", $user_id)->delete();
    }

    public function isFriend($user): bool
    {
        $user1 = auth()->user();
        foreach ($user->friends()->get() as $friend) {
            if ($user1->id == $friend->friend_id) {
                return true;
            }
        }
        return false;
    }
}
