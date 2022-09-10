<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Http\Resources\Admin\AdminTables\CommentsTableResource;
use App\Repositories\Contracts\IComment;
use App\Repositories\Contracts\IUser;
use App\Traits\HttpResponse;
use Illuminate\Http\Request;

class ACommentsController extends Controller
{
    use HttpResponse;
    private $user, $comment;
    public function __construct(IComment $comment,IUser $user){
        $this->comment = $comment;
        $this->user = $user;
    }

    public function getAllComments(): \Illuminate\Http\Response
    {
        $allComments = $this->comment->all();
        return self::returnData('comments',CommentsTableResource::collection($allComments),'all comments',200);
    }

    public function delete($id): \Illuminate\Http\Response
    {
        $this->comment->find($id)->delete();
        return self::success("deleted successfully", 200);
    }
}
