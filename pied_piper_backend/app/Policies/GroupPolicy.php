<?php

namespace App\Policies;

use App\Models\Group;
use App\Models\User;
use Illuminate\Auth\Access\HandlesAuthorization;

class GroupPolicy
{
    use HandlesAuthorization;

    public function __construct()
    {
        //
    }

    public function delete(User $user, Group $group): bool
    {
        return $group->user_id === $user->id;
    }

    public function updatePrivacy(User $user, Group $group): bool
    {
        return $group->user_id === $user->id;
    }

    public function groupRequests(User $user, Group $group): bool
    {
        return $group->user_id === $user->id;
    }

    public function getFriendsToInvite(User $user, Group $group): bool
    {
        return $group->user_id === $user->id;
    }

    public function updateCover(User $user, Group $group): bool
    {
        return $group->user_id === $user->id;
    }

    public function deleteCover(User $user, Group $group): bool
    {
        return $group->user_id === $user->id;
    }

    public function removeRequest(User $user, Group $group): bool
    {
        return $group->user_id === $user->id;
    }
}
