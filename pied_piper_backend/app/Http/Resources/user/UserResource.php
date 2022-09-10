<?php

namespace App\Http\Resources\user;

use App\Http\Resources\friend\FriendRequestResource;
use App\Http\Resources\friend\FriendResource;
use App\Http\Resources\friend\ReceivedRequestResource;
use App\Http\Resources\Post\PostFormatResource;
use App\Http\Resources\Post\SharedPostsResource;
use App\Repositories\Eloquent\PostRepository;
use App\Repositories\Eloquent\UserRepository;
use Illuminate\Http\Resources\Json\JsonResource;

class UserResource extends JsonResource
{
    public function myPosts($userID): \Illuminate\Support\Collection
    {
        $post = new PostRepository();
        $user = new UserRepository();
        $user = $user->find($userID);
        $posts = [];
        foreach($user->post as $myPost){
            if($myPost->group_id==null){
            $myPost['is_shared_post'] = false;
            array_push($posts, (object)$myPost);
        }}

        foreach($user->shared_posts()->get() as $myPost){
            $post = $post->find($myPost->post_id);
            $sharedUser = $user->find($myPost->user_id);
            $post['is_shared_post'] = true;
            $post['shared_user_id'] = $sharedUser->id;
            $post['shared_post_id'] = $myPost->id;
            $post['shared_user_picture'] = $sharedUser->picture;
            $post['shared_user_name'] = $sharedUser->name;
            $post['created_at'] = $myPost->created_at;
            array_push($posts, (object)$post);
        }
        return collect($posts)->sortByDesc('created_at');


    }
    public function toArray($request): array
    {
        $user = new UserRepository();
        return [
            'visitor' => false,
            'id' => $this->id,
            'name' => $this->name,
            'email' => $this->email,
            'is_default_pic'=> $this->picture == "https://res.cloudinary.com/dxntbhjao/image/upload/v1659863927/1/posts/pjfemlrvoh3dlokoccpp.jpg",
            'picture' => $this->picture,
            'is_default_cover'=> $this->cover=="https://res.cloudinary.com/dxntbhjao/image/upload/v1659863975/1/posts/oox0omtyvag3egnfq7h9.webp",
            'cover' => $this->cover,
            'available_to_hire' => $this->available_to_hire,
            'location' => $this->location,
            'job_title' => $this->job_title,
            'friends' => FriendResource::collection($this->friends()->get()),
            'sent_requests' => FriendRequestResource::collection($this->friendRequests()->get()),
            'received_requests' => ReceivedRequestResource::collection($this->friendRequestReceivers()->get()),
            'posts' => PostFormatResource::collection($this->myPosts($this->id)),
        ];
    }
}

