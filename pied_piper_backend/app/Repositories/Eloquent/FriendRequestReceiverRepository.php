<?php

namespace App\Repositories\Eloquent;

use App\Models\FriendRequestReceiver;
use App\Repositories\Contracts\IFriendRequestReceiver;

class FriendRequestReceiverRepository extends BaseRepository implements IFriendRequestReceiver
{
    public function model(): string
    {
        return FriendRequestReceiver::class;
    }

    public function isReceivedFrom($user): bool
    {
        $user1 = auth()->user();
        foreach ($user1->friendRequestReceivers()->get() as $receiver) {
            if ($user->id == $receiver->requester_id) {
                return true;
            }
        }
        return false;
    }
}
