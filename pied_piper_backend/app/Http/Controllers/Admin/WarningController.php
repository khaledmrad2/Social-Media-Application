<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Http\Resources\Admin\WarningResource;
use App\Repositories\Contracts\IAdmin;
use App\Repositories\Contracts\IUser;
use App\Repositories\Contracts\IWarning;
use App\Traits\HttpResponse;
use App\Traits\Notifications;
use Illuminate\Http\Request;

class WarningController extends Controller
{
    use HttpResponse,Notifications;
    private  $admin,$user,$warning;
    public function __construct(IAdmin $admin,IUser $user,IWarning $warning)
    {
        $this->admin = $admin;
        $this->user = $user;
        $this->warning = $warning;
    }

    public function create(Request $request,$id): \Illuminate\Http\Response
    {
        $admin = $this->admin->find(auth()->user()->id);
        $user = $this->user->find($id);
        $text = $request->input('text');
        $warning = $this->warning->create(['admin_id'=>$admin->id,'user_id'=>$user->id,'text'=>$text]);
         self::ComplaintNotification('user',$user->id,'warning',$warning->id);

        return self::success('warning created successfully',200);
    }

    public function allWarnings(): \Illuminate\Http\Response
    {
        $admin = $this->admin->find(auth()->user()->id);
        $warning = $this->warning->all();
        return self::returnData('warning',WarningResource::collection($warning),'all warnings ',200);



    }
}
