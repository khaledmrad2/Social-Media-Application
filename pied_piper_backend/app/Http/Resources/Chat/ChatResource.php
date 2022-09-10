<?php

namespace App\Http\Resources\Chat;

use App\Repositories\Eloquent\ChatRepository;
use App\Repositories\Eloquent\UserRepository;
use Illuminate\Http\Resources\Json\JsonResource;

class ChatResource extends JsonResource
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
        $chat = new ChatRepository();
        if($this->id!=null) {
            $otherUser = $user->find($chat->getOtherUser($this->id));
        }
        return [
            'id'=>$this->id,
            'otherUser_Id'=>$this->id!=null ? $otherUser->id : $this->otherUser_id,
            'otherUser_Pic'=>$this->id!=null ? $otherUser->picture: $this->otherUser_pic,
            'otherUser_Name'=>$this->id!=null ?  $otherUser->name: $this->otherUser_name,
            'latest_Message_created_at'=>$this->id!=null ? $this->getLatestMessage()->created_at:$this->latest_Message_created_at,
            'latest_Message_body'=>$this->id!=null ? $this->getLatestMessage()->body:$this->latest_Message_body,
            'unreadMessage_Count'=>$this->id!=null ? $this->unreaded(auth()->user()->id):0,
            'isUnread'=>$this->id!=null? $this->isUnread(auth()->user()->id):false ,
            'created_at'=>$this->created_at,
        ];
    }
}
