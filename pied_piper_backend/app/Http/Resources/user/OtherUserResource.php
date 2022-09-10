<?php

namespace App\Http\Resources\user;

use App\Http\Resources\friend\FriendRequestResource;
use App\Http\Resources\friend\FriendResource;
use App\Http\Resources\Post\PostFormatResource;
use App\Http\Resources\Post\SharedPostsResource;
use App\Repositories\Eloquent\FriendRepository;
use App\Repositories\Eloquent\FriendRequestReceiverRepository;
use App\Repositories\Eloquent\FriendRequestRepository;
use App\Repositories\Eloquent\UserRepository;
use Illuminate\Http\Resources\Json\JsonResource;

class OtherUserResource extends JsonResource
{
    public function toArray($request): array
    {
        $friend = new FriendRepository();
        $requested = new FriendRequestRepository();
        $receiver = new FriendRequestReceiverRepository();
        $user = new UserRepository();
        return [
            'visitor' => true,
            'id' => $this->id,
            'name' => $this->name,
            'email' => $this->email,
            'picture' => $this->picture,
            'cover' => $this->cover,
            'available_to_hire' => $this->available_to_hire,
            'location' => $this->location,
            'job_title' => $this->job_title,
            'isFriend' => $friend->isFriend($this),
            'isSentToHim' => $requested->isRequested($this),
            'isSendToMe' => $receiver->isReceivedFrom($this),
            'friends' => FriendResource::collection($this->friends()->get()),
            'mutual_friends_count'=>count($user->mutualFriends($this->id)),
            'posts'=>PostFormatResource::collection(($this->post()->where('group_id',null)->get())),
            'shared_posts'=>SharedPostsResource::collection($this->shared_posts()->get()),
        ];
    }
}
