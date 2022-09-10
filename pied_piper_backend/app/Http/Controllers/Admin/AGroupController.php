<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Http\Resources\Admin\AdminTables\GroupsTableResource;
use App\Http\Resources\Admin\AdminTables\PostTableResource;
use App\Http\Resources\Admin\AUserResource;
use App\Http\Resources\Group\GroupResource;
use App\Http\Resources\Post\PostFormatResource;
use App\Repositories\Contracts\IGroup;
use App\Repositories\Contracts\IPost;
use App\Repositories\Contracts\IUser;
use App\Traits\HttpResponse;
use Illuminate\Http\Request;

class AGroupController extends Controller
{
    use HttpResponse;
    private $group,$user,$post;
    public function __construct(IGroup $group,IUser $user,IPost $post){
        $this->user = $user;
        $this->group =$group;
        $this->post =$post;
    }

    public function getAllGroups(): \Illuminate\Http\Response
    {
        $groups = $this->group->all();
        return self::returnData('groups',GroupsTableResource::collection($groups),'all groups',200);
    }

    public function getGroupMembers($id): \Illuminate\Http\Response
    {
        $group = $this->group->find($id);
        return self::returnData('users',AUserResource::collection($group->users),'all group users',200);
    }

    public function getGroupPosts($id): \Illuminate\Http\Response
    {
        $group = $this->group->find($id);
        return self::returnData('posts',PostTableResource::collection($group->posts),'all group posts',200);
    }

    public function deleteGroupPost($id): \Illuminate\Http\Response
    {
        $post = $this->post->find($id);
        $this->post->delete($post->id);
        return self::success('post deleted successfully',200);
    }
    public function deleteGroup($id): \Illuminate\Http\Response
    {
        $group = $this->group->find($id);
        $this->group->delete($group->id);
        return self::success('group deleted successfully',200);

    }
}
