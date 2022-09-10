<?php

namespace App\Repositories\Eloquent;

use App\Models\Comment;
use App\Models\Post;
use App\Repositories\Contracts\IComment;


class CommentRepository extends BaseRepository implements IComment
{
    public function model(): string
    {
        return Comment::class;
    }

    public function commentsCount($post):int
    {
        return count($post->comments()->get());
    }

    public function isVisitor($id): bool
    {
        $comment = $this->find($id);
        if($comment->user_id == auth()->user()->id)
            return false;
        return true;
    }
}
