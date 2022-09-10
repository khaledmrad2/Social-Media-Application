<?php

namespace App\Http\Resources\Notification;

use App\Repositories\Eloquent\NotificationRepository;
use App\Repositories\Eloquent\PostRepository;
use App\Repositories\Eloquent\UserRepository;
use Illuminate\Http\Resources\Json\JsonResource;

class NotificationResource extends JsonResource
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
        $notification = new NotificationRepository();
        $post = new PostRepository();

        if($this->causer_id!=0){
        $user_pic = $user->find($this->causer_id)->picture;
        }
        else
            $user_pic = "https://res.cloudinary.com/dxntbhjao/image/upload/v1659863927/1/posts/pjfemlrvoh3dlokoccpp.jpg";
        return [
            'notification_id'=>$this->id,
            'user_pic'=>$user_pic,
            'type'=>$notification->checkType($this->sent_as_type),
            'id'=>$this->sent_as_id,
            'post_group_id'=> $notification->checkType($this->sent_as_type) =='post' && $post->find($this->sent_as_id)->group_id!=null?$post->find($this->sent_as_id)->group_id:null,
            'content'=>$this->content,
            'created_at'=>$this->created_at,
            'date'=>$this->created_at->diffForHumans(),
            'isSeen'=>$this->isSeen,
        ];
    }
}
