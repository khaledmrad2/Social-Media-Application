<?php

namespace App\Http\Resources\Group;

use App\Http\Requests\Group\GroupRequest;
use App\Http\Resources\Post\PostFormatResource;
use App\Repositories\Eloquent\GroupRepository;
use App\Repositories\Eloquent\GroupRequestReceiverRepository;
use App\Repositories\Eloquent\GroupRequestRepository;
use App\Repositories\Eloquent\UserRepository;
use Illuminate\Http\Resources\Json\JsonResource;

class GroupResource extends JsonResource
{
    public function toArray($request): array
    {
        $user = new UserRepository();
        $admin = $user->find($this->user_id);
        $group = new GroupRepository();

        $group = $group->find($this->id);
        $request = new GroupRequestRepository();
        $receiver =new GroupRequestReceiverRepository();
        return [
            "isAdmin" => auth()->user()->id == $this->user_id,
            "admin_name" => $admin->name,
            "admin_id" => $this->user_id,
            "isMember"=> (bool) $group->users->contains(auth()->user()->id),
            "isRequested"=> $request->checkByThreeConditions('group_id',$group->id,'user_id',auth()->user()->id,'type','normal' )->exists(),
            "isInvited"=> $receiver->checkByThreeConditions('group_id',$group->id,'user_id',auth()->user()->id,'type','invite' )->exists(),
            "membersCount"=>count( $group->users),
            "id" => $this->id,
            "title" => $this->title,
            "privacy" => $this->security,
            "cover" => $this->cover,
            "posts"=> $group->security == "public"
            || ($group->security == "private" && $group->users->contains(auth()->user()->id))?(PostFormatResource::collection($group->posts)->sortByDesc('created_at'))->toArray(): [],
        ];
    }
}
