<?php

namespace App\Repositories\Eloquent;

use App\Models\Saved_Post;

use App\Repositories\Contracts\ISaved_Post;

class Saved_PostRepository extends BaseRepository implements ISaved_Post
{
    public function model(): string
    {
        return Saved_Post::class;
    }


    public function check($post):bool
    {
        $user = auth()->user();
        foreach($this->findWhere('post_id',$post->id) as $savedPost){
            if($savedPost->user_id==$user->id)
                return true;
        }
        return false;
    }

    public function FindMySavedPost($user_id,$post_id){
        return $this->checkByTwoConditions('user_id', $user_id, 'post_id',$post_id)->first();
    }

}
