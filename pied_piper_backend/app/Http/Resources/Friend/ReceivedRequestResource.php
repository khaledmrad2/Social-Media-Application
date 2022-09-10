<?php

namespace App\Http\Resources\friend;

use App\Repositories\Eloquent\UserRepository;
use Illuminate\Http\Resources\Json\JsonResource;

class ReceivedRequestResource extends JsonResource
{
    public function toArray($request): array
    {
        $user = new UserRepository();
        $requester = $user->find($this->requester_id);
        return [
            'id' => $this->requester_id,
            'name' => $requester->name,
            'picture' => $requester->picture,
        ];
    }
}
