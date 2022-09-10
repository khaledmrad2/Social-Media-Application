<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Http\Resources\Admin\AdminTables\ComplaintReplayResource;
use App\Repositories\Contracts\IAdmin;
use App\Repositories\Contracts\IComplaint;
use App\Repositories\Contracts\IComplaint_Reply;
use App\Traits\HttpResponse;
use App\Traits\Notifications;
use Illuminate\Http\Request;

class Complaint_ReplyController extends Controller
{
    use HttpResponse,Notifications;
    private  $admin,$complaint_reply,$complaint;
    public function __construct(IAdmin $admin,IComplaint_Reply $complaint_reply,IComplaint $complaint){
        $this->admin = $admin;
        $this->complaint_reply = $complaint_reply;
        $this->complaint = $complaint;
    }
    public function create(Request $request,$id): \Illuminate\Http\Response
    {
        $admin = $this->admin->find(auth()->user()->id);
        $complaint = $this->complaint->find($id);
        $reply =$request->string('reply');
        $complaint_reply = $this->complaint_reply->create(['admin_id'=>$admin->id,'complaint_id'=>$complaint->id,'text'=>$reply]);
        $this->complaint->update($complaint->id,['isProcessed'=>true]);
        self::ComplaintNotification($complaint->user_id,'complaint',$complaint_reply->id);
        return self::success('Complaint Reply Done',200);
    }
    public function complaintReplay($complaint_id): \Illuminate\Http\Response
    {
        $admin = $this->admin->find(auth()->user()->id);
        $complaint = $this->complaint->find($complaint_id);
        $complaint_replay = $this->complaint_reply->findWhere('complaint_id',$complaint->id);
        return self::returnData('Complaint_Reply',ComplaintReplayResource::collection($complaint_replay),'success',200);
    }






}
