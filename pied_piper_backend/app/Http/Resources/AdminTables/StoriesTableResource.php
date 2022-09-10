<?php

namespace App\Http\Resources\AdminTables;

use App\Repositories\Eloquent\StoryRepository;
use App\Repositories\Eloquent\UserRepository;
use Illuminate\Http\Resources\Json\JsonResource;

class StoriesTableResource extends JsonResource
{
    public function toArray($request)
    {
        $user = new UserRepository();
        $user1 = $user->find($this->user_id);
        return [
            'id'=>$this->id,
            'text'=>$this->text,
            'image_url'=>$this->image,
            'user_name'=>$user1->name,
        ];
    }

}
