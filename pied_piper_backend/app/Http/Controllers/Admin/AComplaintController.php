<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Http\Resources\Admin\AComplaintResource;
use App\Repositories\Contracts\IAdmin;
use App\Repositories\Contracts\IComplaint;
use App\Repositories\Contracts\IComplaint_Reply;
use App\Traits\HttpResponse;
use App\Traits\Notifications;
use Illuminate\Http\Request;

class AComplaintController extends Controller
{
    use HttpResponse,Notifications;
    private  $admin,$complaint_reply,$complaint;
    public function __construct(IAdmin $admin,IComplaint_Reply $complaint_reply,IComplaint $complaint){
        $this->admin = $admin;
        $this->complaint_reply = $complaint_reply;
        $this->complaint = $complaint;
    }

    public function allComplaints(): \Illuminate\Http\Response
    {
        $complaint =  $this->complaint->all();
        return self::returnData('complaints',AComplaintResource::collection($complaint),'all complaints',200);
    }
}
