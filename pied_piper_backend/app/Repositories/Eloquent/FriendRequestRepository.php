<?php

namespace App\Repositories\Eloquent;

use App\Models\FriendRequest;
use App\Repositories\Contracts\IFriendRequest;

class FriendRequestRepository extends BaseRepository implements IFriendRequest
{
    public function model(): string
    {
        return FriendRequest::class;
    }

    public function isRequested($user): bool
    {
        $user1 = auth()->user();
        foreach ($user1->friendRequests()->get() as $requester) {
            if ($user->id == $requester->receiver_id) {
                return true;
            }
        }
        return false;
    }
}
