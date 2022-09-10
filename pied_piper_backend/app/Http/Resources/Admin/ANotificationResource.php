<?php

namespace App\Http\Resources\Admin;

use App\Repositories\Eloquent\NotificationRepository;
use App\Repositories\Eloquent\UserRepository;
use Illuminate\Http\Resources\Json\JsonResource;

class ANotificationResource extends JsonResource
{
    /**
     * Transform the resource into an array.
     *
     * @param  \Illuminate\Http\Request  $request
     * @return array|\Illuminate\Contracts\Support\Arrayable|\JsonSerializable
     */
    public function toArray($request)
    {
        $notification = new NotificationRepository();
        $user = new UserRepository();
        $user1 = $user->find($this->causer_id);
        return[
            'type'=>$notification->checkType($this->sent_as_type),
            'id'=>$this->sent_as_id,
            'user_picture' => $user1->picture,
            'content'=>$this->content,
            'created_at'=>$this->created_at,
            ];
    }
}
