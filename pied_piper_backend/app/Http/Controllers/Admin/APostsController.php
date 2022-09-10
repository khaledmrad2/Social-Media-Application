<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Http\Resources\Admin\AdminTables\CommentsTableResource;
use App\Http\Resources\Admin\AdminTables\PostTableResource;
use App\Http\Resources\Admin\AdminTables\ReactionsTableResource;
use App\Http\Resources\Post\PostFormatResource;
use App\Repositories\Contracts\IPost;
use App\Repositories\Contracts\IUser;
use App\Repositories\Eloquent\PostRepository;
use App\Traits\HttpResponse;
use Illuminate\Http\Request;

class APostsController extends Controller
{
    use HttpResponse;
    private $post,$user;
    public function __construct(IPost $post,IUser $user){
        $this->post = $post;
        $this->user = $user;
    }

    public function getAllPosts(): \Illuminate\Http\Response
    {
        $allPosts = $this->post->all();
        return self::returnData('all_posts',PostTableResource::collection($allPosts),'all post',200);
    }

    public function getPostComments($id): \Illuminate\Http\Response
    {
        $comments = $this->post->find($id)->comments;
        return self::returnData('comments',CommentsTableResource::collection($comments),'all post comments',200);
    }

    public function getPostReactions($id): \Illuminate\Http\Response
    {
        $reactions = $this->post->find($id)->reactions;
        return self::returnData('reactions',ReactionsTableResource::collection($reactions),'all post reactions',200);
    }

    public function allUserPosts($id): \Illuminate\Http\Response
    {
        $user = $this->user->find($id);
        $posts = $user->post()->get();
        return self::returnData('all_posts',PostTableResource::collection($posts),'all post',200);
    }

    public function deleteUserPost($id): \Illuminate\Http\Response
    {
        $post = $this->post->find($id);
        $this->post->delete($post->id);
        return self::success('post deleted successfully',200);
    }
}
