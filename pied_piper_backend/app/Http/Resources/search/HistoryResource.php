<?php

namespace App\Http\Resources\search;

use App\Repositories\Eloquent\UserRepository;
use Illuminate\Http\Resources\Json\JsonResource;

class historyResource extends JsonResource
{
    public function toArray($request): array
    {
        $user = new UserRepository();
        $seached = $user->find($this->searched_id);
        return [
            'id' => $seached->id,
            'name' => $seached->name,
            'picture' => $seached->picture
        ];
    }
}
