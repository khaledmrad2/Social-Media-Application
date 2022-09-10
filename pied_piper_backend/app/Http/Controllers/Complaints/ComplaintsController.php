<?php

namespace App\Http\Controllers\Complaints;

use App\Http\Controllers\Controller;
use App\Http\Requests\Complaint\ComplaintRequest;
use App\Repositories\Contracts\IAdmin;
use App\Repositories\Contracts\IComment;
use App\Repositories\Contracts\IComplaint;
use App\Repositories\Contracts\IGroup;
use App\Repositories\Contracts\IPost;
use App\Repositories\Contracts\IUser;
use App\Traits\HttpResponse;
use App\Traits\Notifications;
use Illuminate\Http\Request;

class ComplaintsController extends Controller
{
    use HttpResponse,Notifications;

    protected $user , $post , $comment ,  $complaint ,$group,$admin;

    public function __construct(IUser $user , IComment $comment , IPost $post , IComplaint $complaint,IGroup $group,IAdmin $admin)
    {
        $this->user = $user;
        $this->post = $post;
        $this->comment = $comment;
        $this->complaint = $complaint;
        $this->group = $group;
        $this->admin = $admin;
    }

    public function create($type, $id, ComplaintRequest $request)//: \Illuminate\Http\Response
    {
        $post = null;
        $comment = null;
        $user = null;
        $group = null;

        $type == "post" ? $post = $this->post->find($id)
            : ($type == "user" ? $user = $this->user->find($id)
            : ($type == "comment" ? $comment = $this->comment->find($id)
            : $group = $this->group->find($id)));


        if ($this->complaint->check($type, $id)) {
            return self::failure("cannot complaint", 422);
        }

        $complaint["text"] = $request->text;
        $complaint["user_id"] = auth()->user()->id;
        $complaint["complaintable_id"] = $id;
        $type == "post" ? $complaint["complaintable_type"] = $post::class
            : ($type == "user" ? $complaint["complaintable_type"] = $user::class
            :   ($type == "comment" ?  $complaint["complaintable_type"] = $comment::class
            :   $complaint["complaintable_type"] = $group::class ));

        $complaint = $this->complaint->create($complaint);

        //push a notification to the admins
        $admins = $this->admin->all();
        foreach($admins as $admin){
        $type == "post" ? self::CreateAdminNotification($admin->id,'post',$complaint->id)
            : ($type == "user" ? self::CreateAdminNotification($admin->id,'user',$complaint->id)
            : ($type == "comment" ? self::CreateAdminNotification($admin->id,'comment',$complaint->id)
            :self::CreateAdminNotification($admin->id,'group',$complaint->id)));
        }
        return self::success("complaint successfully", 201);
    }
}
