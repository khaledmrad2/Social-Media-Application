<?php

namespace App\Http\Resources\Chat;

use App\Http\Resources\user\UserResource;
use App\Repositories\Eloquent\UserRepository;
use Illuminate\Http\Resources\Json\JsonResource;

class MessageResource extends JsonResource
{
    /**
     * Transform the resource into an array.
     *
     * @param  \Illuminate\Http\Request  $request
     * @return array|\Illuminate\Contracts\Support\Arrayable|\JsonSerializable
     */
    public function toArray($request)
    {
        $user = new UserRepository();
        return [
            'message_id'=>$this->id,
            'is_visitor'=>$this->user_id!=auth()->user()->id,
            'body'=>$this->body,
            'user_id'=>$this->user_id,
            'user_picture'=>$user->find($this->user_id)->picture,
            'user_name'=>$user->find($this->user_id)->name,
            'chat_id'=>$this->chat_id,
            'last_read'=>$this->last_read,
            'created_at'=>$this->created_at,
            'deleted_at'=>$this->deleted_at,
        ];
    }
}
