<?php

namespace App\Http\Controllers\Admin;

use App\Http\Resources\Admin\AdminResource;
use App\Http\Resources\Admin\CountOfAllResource;
use App\Repositories\Contracts\IAdmin;
use App\Repositories\Contracts\IComment;
use App\Repositories\Contracts\IComplaint;
use App\Repositories\Contracts\IGroup;
use App\Repositories\Contracts\IPost;
use App\Repositories\Contracts\IStory;
use App\Repositories\Contracts\IUser;
use App\Repositories\Contracts\IWarning;
use App\Traits\HttpResponse;

class AdminController
{
    use HttpResponse;
    private $admin,$post,$user,$comment,$story,$group,$complaint,$warning;
    public function __construct(IAdmin $admin,IPost $post,IUser $user,IComment $comment,IStory $story,IGroup $group, IComplaint $complaint,IWarning $warning){
        $this->admin =$admin;
        $this->post =$post;
        $this->user =$user;
        $this->comment =$comment;
        $this->story =$story;
        $this->group =$group;
        $this->complaint =$complaint;
        $this->warning =$warning;
    }
    public function allAdmins(): \Illuminate\Http\Response
    {
        $admins = $this->admin->all();
        return self::returnData('all_admins',AdminResource::collection($admins),'all admins',200);
    }

    public function countOfAll(): \Illuminate\Http\Response
    {

        $data['posts'] = count($this->post->all());
        $data['users'] = count($this->user->all());
        $data['comments'] = count($this->comment->all());
        $data['stories'] = count($this->story->all());
        $data['groups'] = count($this->group->all());
        $data['complaints'] = count($this->complaint->all());
        $data['warnings'] = count($this->warning->all());
        return  self::returnData('count_of_all',new CountOfAllResource((object)$data),'count of all features in app',200);
    }
}
