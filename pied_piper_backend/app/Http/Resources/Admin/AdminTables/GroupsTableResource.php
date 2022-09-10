<?php

namespace App\Http\Resources\Admin\AdminTables;

use App\Repositories\Eloquent\GroupRepository;
use App\Repositories\Eloquent\GroupRequestReceiverRepository;
use App\Repositories\Eloquent\GroupRequestRepository;
use App\Repositories\Eloquent\UserRepository;
use Illuminate\Http\Resources\Json\JsonResource;

class GroupsTableResource extends JsonResource
{
    public function toArray($request)
    {
        $user = new UserRepository();
        $admin = $user->find($this->user_id);
        $group = new GroupRepository();

        $group = $group->find($this->id);
        $request = new GroupRequestRepository();
        $receiver =new GroupRequestReceiverRepository();
        return [
            "id" => $this->id,
            "admin_name" => $admin->name,
            "title" => $this->title,
            "privacy" => $this->security,
            "cover" => $this->cover,
            "membersCount"=>count($group->users),
        ];
    }
}
