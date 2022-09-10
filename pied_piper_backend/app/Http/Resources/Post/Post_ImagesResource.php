<?php

namespace App\Http\Resources\Post;

use Illuminate\Http\Resources\Json\JsonResource;

class Post_ImagesResource extends  JsonResource
{
    public function toArray($request): array
    {
        return [
            'url'=>$this->url,
            'id'=>$this->id,
            'post_id'=>$this->post_id
        ];
    }
}
