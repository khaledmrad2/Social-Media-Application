<?php

namespace App\Repositories\Eloquent;

use App\Models\Reaction;
use App\Repositories\Contracts\IReaction;

class ReactionRepository extends BaseRepository implements IReaction
{
    public function model(): string
    {
        return Reaction::class;
    }
    public function findWhereType($type,$column,$value)
    {

        return $this->model->where('reactionable_type',$type::class)->where('reactionable_id',$type->id)->where($column,$value)->get();
    }

    public function isReaction($type,$id):bool
    {
        $user = auth()->user();
        if ($type == "post") {
            $result = $this->model->where('reactionable_type', "App\Models\Post")->where('reactionable_id', $id)->where('user_id', $user->id)->get();
            if ($result->isEmpty()) {
                return false;
            }

            return true;
        }
        $result = $this->model->where('reactionable_type', "App\Models\Comment")->where('reactionable_id', $id)->where('user_id', $user->id)->get();
        if ($result->isEmpty()) {
            return false;
        }

        return true;
    }


    public function myReactionType($type,$id):string
    {
        $user = auth()->user();
        if ($type == "post") {
            $result = $this->model->where('reactionable_type', "App\Models\Post")->where('reactionable_id', $id)->where('user_id', $user->id)->get();
            if ($result->isEmpty()) {
                return "";
            }

            return $result->first()->type;
        }
        $result = $this->model->where('reactionable_type', "App\Models\Comment")->where('reactionable_id', $id)->where('user_id', $user->id)->get();
        if ($result->isEmpty()) {
            return "";
        }

        return $result->first()->type;
    }

    public function count($type,$id):int
    {
        if ($type == "post") {
            $result = $this->model->where('reactionable_type', "App\Models\Post")->where('reactionable_id', $id)->get();
            if ($result->isEmpty()) {
                return 0;
            }

            return count($result);
        }
        $result = $this->model->where('reactionable_type', "App\Models\Comment")->where('reactionable_id', $id)->get();
        if ($result->isEmpty()) {
            return 0;
        }

        return count($result);
    }

    public function reactionsType($post) : array
    {
        $love = 0;
        $sad = 0;
        $angry = 0;
        $like = 0;
        $haha = 0;
        $data = [];
        foreach ($post->reactions()->get() as $reaction){
            if($reaction->type == "like")
                $like++;
            if($reaction->type == "love")
                $love++;
            if($reaction->type == "haha")
                $haha++;
            if($reaction->type == "sad")
                $sad++;
            if($reaction->type == "angry")
                $angry++;
        }
        $data['like'] = $like;
        $data['love'] = $love;
        $data['haha'] = $haha;
        $data['sad'] = $sad;
        $data['angry'] = $angry;

        return $data;
    }
}
