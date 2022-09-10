<?php

namespace App\Repositories\Contracts;

interface IFriend
{
    public function findFriendAndDelete($user_id, $friend_id);
}
