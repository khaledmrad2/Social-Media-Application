<?php

namespace App\Repositories\Eloquent;


use App\Models\Shared_Post;
use App\Repositories\Contracts\ISharedPost;

class SharedPostRepository extends BaseRepository implements ISharedPost
{
    public function model(): string
    {
        return Shared_Post::class;
    }

    public function checkIfShared($post): bool
    {
        $user = auth()->user();
        foreach($this->findWhere('post_id',$post->id) as $sharedPost){
            if($sharedPost->user_id==$user->id)
                return true;
        }
        return false;
    }

    public function count($post): int
    {
        $result = ($this->findWhere('post_id',$post->id));
        if ($result->isEmpty()) {
            return 0;
        }
        return count($result);
    }
}
