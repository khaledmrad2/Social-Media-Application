<?php

namespace App\Repositories\Eloquent;

use App\Models\Story;

class StoryRepository extends BaseRepository implements \App\Repositories\Contracts\IStory
{

    public function model(): string
    {
        return Story::class;
    }

    public function check($data): bool
    {
        if(!array_key_exists('image',$data) && array_key_exists('text',$data))
            return true;
        if($data==null)
            return true;
        return false;
    }
    public function isVisitor($story): bool
    {
        $user = auth()->user();
        if($story->user_id==$user->id)
            return false;
        return true;
    }
}
