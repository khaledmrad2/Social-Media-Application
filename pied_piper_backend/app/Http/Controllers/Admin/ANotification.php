<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Http\Resources\Admin\ANotificationResource;
use App\Http\Resources\Notification\NotificationResource;
use App\Repositories\Contracts\IAdmin;
use App\Repositories\Contracts\INotification;
use App\Traits\HttpResponse;
use App\Traits\Notifications;
use Illuminate\Http\Request;

class ANotification extends Controller
{
    use HttpResponse,Notifications;
    private $admin,$notification;

    public function __construct(IAdmin $admin,INotification $notification){
        $this->admin = $admin;
        $this->notification = $notification;
    }

    public function getAdminNotifications(){
        $admin = $this->admin->find(auth()->user()->id);
        $notifications = $admin->notifications;
        return self::returnData('notifications',ANotificationResource::collection($notifications),'your notifications',200);
    }


}
