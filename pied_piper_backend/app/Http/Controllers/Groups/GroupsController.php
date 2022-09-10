<?php

namespace App\Http\Controllers\Groups;

use App\Http\Controllers\Controller;
use App\Http\Requests\Group\GroupRequest;
use App\Http\Resources\Group\GroupResource;
use App\Http\Resources\group\NormalGroupResource;
use App\Http\Resources\Group\RUGResource;
use App\Http\Resources\Group\UGResource;
use App\Http\Resources\group\UserGroupResource;
use App\Http\Resources\Post\PostFormatResource;
use App\Repositories\Contracts\IGroup;
use App\Repositories\Contracts\IGroupRequest;
use App\Repositories\Contracts\IGroupRequestReceiver;
use App\Repositories\Contracts\INotification;
use App\Repositories\Contracts\IUser;
use App\Traits\Cloudinary;
use App\Traits\HttpResponse;
use App\Traits\Notifications;
use Illuminate\Http\Request;

class GroupsController extends Controller
{
    use HttpResponse, Cloudinary,Notifications;

    protected $group, $user, $groupRequest, $groupRequestReceivers;

    public function __construct(IGroup $group, IUser $user, IGroupRequest $groupRequest, IGroupRequestReceiver $groupRequestReceivers)
    {
        $this->group = $group;
        $this->user = $user;
        $this->groupRequest = $groupRequest;
        $this->groupRequestReceivers = $groupRequestReceivers;
    }

    public function groupUsers($id): \Illuminate\Http\Response
    {
        $group = $this->group->find($id);
        return self::returnData("users", UserGroupResource::collection($group->users), "all users", 200);
    }

    public function allGroups(): \Illuminate\Http\Response
    {
        return self::returnData("groups", GroupResource::collection($this->group->all()), "my groups", 200);
    }

    public function getGroup($id): \Illuminate\Http\Response
    {
        return self::returnData("group", new GroupResource($this->group->find($id)), "group", 200);
    }

    public function myGroups(): \Illuminate\Http\Response
    {
        return self::returnData("groups", GroupResource::collection(auth()->user()->groups), "my groups", 200);
    }

    public function getGroupsInvolvedIn(): \Illuminate\Http\Response
    {
        $allGroups = $this->group->all();
        $myGroups = [];
        foreach ($allGroups as $group) {
            if ($group->users->contains(auth()->user()->id)) {
                array_push($myGroups, $group);
            }
        }

        return self::returnData("groups", GroupResource::collection($myGroups), "groups", 200);
    }

    public function sentInvitations(): \Illuminate\Http\Response
    {
        return self::returnData("invitations", UGResource::collection(auth()->user()->myInvitations), "sent invitations", 200);
    }

    public function sentRequests(): \Illuminate\Http\Response
    {
        return self::returnData("requests", UGResource::collection(auth()->user()->myRequests), "sent requests", 200);
    }

    public function groupRequests($id): \Illuminate\Http\Response
    {
        $group = $this->group->find($id);
        $this->authorize("groupRequests", $group);
        return self::returnData("requests", RUGResource::collection($group->normalGroupRequests), "sent requests", 200);
    }

    public function getInvitedToGroups(): \Illuminate\Http\Response
    {
        $data = [];
        $groups = [];
        foreach (auth()->user()->groupRequestReceivers as $request) {
            if ($request->user_id == auth()->user()->id && $request->type == "invite") {
                if (!in_array($request->group_id, $data)) {
                    array_push($data, $request->group_id);
                }
            }
        }
        foreach ($data as $group_id) {
            array_push($groups, $this->group->find($group_id));
        }
        return self::returnData("groups", NormalGroupResource::collection($groups), "invitations", 200);
    }

    public function getFriendsToInvite($id): \Illuminate\Http\Response
    {
        $group = $this->group->find($id);
        $this->authorize("getFriendsToInvite", $group);
        $friends = auth()->user()->friends;
        $InvitedFriends = auth()->user()->myInvitations;

        foreach ($friends as $friendKey => $friend) {
            foreach ($InvitedFriends as $invitedFriend) {
                if ($invitedFriend->receiver_id == $friend->friend_id) {
                    unset($friends[$friendKey]);
                }
            }
        }

        foreach ($friends as $friendKey => $friend) {
            $friend = $this->user->find($friend->friend_id);
            if ($friend->groups->contains($id)) {
                unset($friends[$friendKey]);
            }
        }
        return self::returnData("friends", RUGResource::collection($friends), "friends you can invite", 200);
    }

    public function sendIR($user_id, $group_id): \Illuminate\Http\Response
    {
        $group = $this->group->find($group_id);
        $user = $this->user->find($user_id);

        if ((auth()->user()->groups->contains($group_id) && $user->id == $group->user_id)
            || ($user->groups->contains($group_id) && $user->id != $group->user_id) ) {
            return self::failure("already in the group", 422);
        }

        // checking if the user already sent invite/request to the user
        if ($this->groupRequestReceivers->checkByThreeConditions("user_id", $user_id, "group_id", $group_id, "requester_id", auth()->user()->id)->exists()) {
            return self::failure("already sent a request/invite to this user", 404);
        }

        // inserting to db as requester and sender
        $groupRequestReceivers = $this->groupRequestReceivers->insertAsReceiver($group, $user_id);
        $groupRequest = $this->groupRequest->insertAsRequester($group, $user_id);

        //send notification
        if($groupRequest->type == 'normal'){
            self::UserNotification($user_id,'sendRequest',$groupRequest->id);
        }
        else if($groupRequestReceivers->type=='invite') {
            self::GroupNotification( $user_id, 'sendInvite', $groupRequestReceivers->id);
        }
        return self::success("sent successfully", 201);
    }

    public function acceptInvite($group_id): \Illuminate\Http\Response
    {
        $participant = auth()->user();

        // checking if user doesn't have a request to this group
        if (!$this->groupRequest->checkByTwoConditions("receiver_id", $participant->id, "group_id", $group_id)) {
            return self::failure("you don't have a request to accept", 404);
        }

        // checking if user already in the group
        if ($participant->groups->contains($group_id))
            return self::failure("already in the group", 422);

        // adding the user to the group
        $this->user->syncingManyToManyRelationGU($participant->id, $group_id);

        // removing from request receivers and requests tables
        $this->groupRequestReceivers->findAndDelete2("user_id", $participant->id, "group_id", $group_id);
        $this->groupRequest->findAndDelete2("receiver_id", $participant->id, "group_id", $group_id);
        $this->groupRequest->findAndDelete2("user_id", $participant->id, "type", "normal");
        $this->groupRequestReceivers->findAndDelete2("requester_id", $participant->id, "type", "normal");

        self::UserNotification($participant->id,'acceptInvite',$group_id);
        return self::success("added to group successfully", 201);
    }

    public function acceptRequest($user_id, $group_id): \Illuminate\Http\Response
    {
        $group = $this->group->find($group_id);
        $user = $this->user->find($user_id);

        if ($user->groups->contains($group_id))
            return self::failure("already in the group", 422);

        if (auth()->user()->id != $group->user_id ||
            !$this->groupRequest->checkByThreeConditions("user_id", $user_id, "group_id", $group_id, "receiver_id", auth()->user()->id))
        {
            return self::failure("cannot accept request", 422);
        }

        // adding the user to the group
        $this->user->syncingManyToManyRelationGU($user_id, $group_id);

        $this->groupRequestReceivers->findAndDelete2("group_id", $group_id, "user_id", $user_id);
        $this->groupRequest->findAndDelete2("receiver_id", $user_id, "group_id", $group_id);
        $this->groupRequest->findAndDelete2("receiver_id", auth()->user()->id, "type", "normal");
        $this->groupRequestReceivers->findAndDelete2("user_id", auth()->user()->id, "type", "normal");

        //send notification
        self::GroupNotification($user->id,'acceptRequest',$group_id);
        return self::success("added to group successfully", 201);
    }

    public function create(GroupRequest $groupRequest): \Illuminate\Http\Response
    {
        $user = auth()->user();
        $data = $groupRequest->all();
        if(array_key_exists('cover',$data)){
            $data['cover'] = self::uploadImages( $data['cover'],'groups','covers');
        }
        $group = $this->group->create(array_merge($data, ['user_id' => $user->id]));
        $this->user->syncingManyToManyRelationGU($user->id, $group->id);
        return self::returnData('group', new GroupResource($group), "group created successfully",201);
    }

    public function delete($id): \Illuminate\Http\Response
    {
        $group = $this->group->find($id);
        $this->authorize('delete', $group);
        $group->delete();
        return self::success("group deleted successfully", 200);
    }

    public function leaveGroup($id): \Illuminate\Http\Response
    {
        $group = $this->group->find($id);
        if ($group->user_id == auth()->user()->id) {
            $this->group->delete($id);
        }

        if (!auth()->user()->groups->contains($id))
            return self::failure("not in the group", 422);

        $this->user->detachingManyToManyRelationGU($id);

        return self::success("left successfully", 200);
    }

    public function updatePrivacy($id): \Illuminate\Http\Response
    {
        $group = $this->group->find($id);
        $this->authorize('updatePrivacy', $group);
        if ($group->security == 'public') $this->group->forceFill(["security" => "private"], $group->id);
        else if($group->security == 'private') $this->group->forceFill(["security" => "public"], $group->id);
        return self::success("group privacy updated successfully", 200);
    }

    public function getGroupPosts($id): \Illuminate\Http\Response
    {
        $group = $this->group->find($id);
        $group_posts = null;
        if ($group->security == "public"
            || $group->contains($id)) {
            $group_posts = PostFormatResource::collection($group->posts);
            return self::returnData("group_posts", $group_posts, "all group posts", 200);
        }
        return self::returnData("group_posts", $group_posts, "empty", 200);
    }

    public function getMixedGroupPosts(): \Illuminate\Http\Response
    {
        $mixedPosts = array();
        $groups = $this->group->all();
        foreach ($groups as $group) {
            if (($group->security == "public" && !$group->users->contains(auth()->user()->id))
                || $group->users->contains(auth()->user()->id)) {
                foreach ($group->posts as $post) {
                    array_push($mixedPosts, $post);
                }
            }
        }
        $mixedPosts = collect($mixedPosts)->sortByDesc('created_at');
        return self::returnData("group_posts", PostFormatResource::collection($mixedPosts), "all mixed group posts", 200);
    }

    public function cancelRequest($id): \Illuminate\Http\Response
    {
        $this->group->find($id);
        if (auth()->user()->groups->contains($id))
            return self::failure("already in the group", 422);
        if (!$this->groupRequest->checkByTwoConditions("user_id", auth()->user()->id, "group_id", $id, )->exists())
            return self::failure("cannot cancel request", 422);
        $this->groupRequest->findAndDelete3("user_id", auth()->user()->id, "group_id", $id, "type", "normal");
        $this->groupRequestReceivers->findAndDelete3("requester_id", auth()->user()->id, "group_id", $id,"type", "normal");
        return self::success("canceled", 200);
    }

    public function updateCover(Request $request,$id): \Illuminate\Http\Response
    {
        $cover = $request->file('cover');
        $group = $this->group->find($id);
        $this->authorize('updateCover', $group);
       $cover = self::uploadImages($cover,'groups','covers');
        $this->group->forcefill(['cover'=>$cover],$group->id);
        return self::returnData('cover',$cover,'cover updated successfully',200);
    }
    public function deleteCover($id): \Illuminate\Http\Response
    {
        $group = $this->group->find($id);
        $this->authorize('deleteCover',$group);
        $newCover = "https://res.cloudinary.com/dxntbhjao/image/upload/v1658823449/groups/covers/bh6skvmorc1xvhgwtptr.webp";
        $this->group->update($group->id,['cover'=>$newCover]);
        return self::returnData('cover',$newCover,"cover deleted successfully",200);
    }

    public function removeRequest($user_id,$group_id): \Illuminate\Http\Response
    {
        $admin = $this->user->find(auth()->user()->id);
        $user = $this->user->find($user_id);
        $group = $this->group->find($group_id);
        $this->authorize('removeRequest',$group);

        if ($user->groups->contains($group->id))
            return self::failure("already in the group", 422);

        if(!$this->groupRequest->checkByTwoConditions('group_id', $group->id, 'user_id', $user->id)->exists()){
            return self::failure("cannot cancel request", 422);
        }
        $this->groupRequest->findAndDelete3("user_id", $user->id, "group_id", $group->id, "type", "normal");
        $this->groupRequestReceivers->findAndDelete3("requester_id",  $user->id, "group_id",  $group->id,"type", "normal");

        return self::success("request removed", 200);
    }
}
