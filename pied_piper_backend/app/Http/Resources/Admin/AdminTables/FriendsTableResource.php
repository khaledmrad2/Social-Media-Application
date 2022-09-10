<?php

namespace App\Http\Resources\Admin\AdminTables;

use App\Repositories\Eloquent\UserRepository;
use Illuminate\Http\Resources\Json\JsonResource;

class FriendsTableResource extends JsonResource
{
    public function toArray($request): array
    {
        $friend = new UserRepository();
        $friend1 =$friend->find($this->friend_id);
        return [
            'id' => $this->friend_id,
            'name' => $friend1->name,
            'email' => $friend1->email,
            'picture' => $friend1->picture,
            'available_to_hire' => $friend1->available_to_hire,
            'location' => $friend1->location,
            'job_title' => $friend1->job_title,
        ];
    }
}
