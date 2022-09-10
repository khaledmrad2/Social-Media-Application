<?php

namespace App\Http\Resources\group;

use Illuminate\Http\Resources\Json\JsonResource;

class UserGroupResource extends JsonResource
{
    public function toArray($request): array
    {
        return [
            "id" => $this->id,
            "name" => $this->name,
            "picture" => $this->picture,
        ];
    }
}
