<?php

namespace App\Http\Resources\search;

use App\Repositories\Eloquent\FriendRepository;
use App\Repositories\Eloquent\FriendRequestReceiverRepository;
use App\Repositories\Eloquent\FriendRequestRepository;
use Illuminate\Http\Resources\Json\JsonResource;

class SearchResource extends JsonResource
{
    public function toArray($request)
    {
        $friend = new FriendRepository();
        $requested = new FriendRequestRepository();
        $receiver = new FriendRequestReceiverRepository();
        return [
            'id' => $this->id,
            'name' => $this->name,
            'picture' => $this->picture,
            'isMe' => auth()->user()-> id === $this->id,
            'isFriend' => $friend->isFriend($this),
            'isSentToHim' => $requested->isRequested($this),
            'isSendToMe' => $receiver->isReceivedFrom($this),
        ];
    }
}
