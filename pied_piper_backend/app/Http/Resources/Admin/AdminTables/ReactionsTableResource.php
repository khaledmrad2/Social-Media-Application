<?php

namespace App\Http\Resources\Admin\AdminTables;

use App\Repositories\Eloquent\ReactionRepository;
use App\Repositories\Eloquent\UserRepository;
use Illuminate\Http\Resources\Json\JsonResource;

class ReactionsTableResource extends JsonResource
{
    public function toArray($request)
    {
        $user = new UserRepository();
        $user1 = $user->find($this->user_id);
        return [
            'id' => $this->id,
            'post_id' => $this->reactionable_id,
            'user_name' => $user1->name,
            'type' => $this->type,
        ];
    }
}
