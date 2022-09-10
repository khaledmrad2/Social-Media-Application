<?php

namespace App\Http\Controllers\Notification;

use App\Http\Controllers\Controller;
use App\Http\Resources\Notification\NotificationResource;
use App\Repositories\Contracts\IGroup;
use App\Repositories\Contracts\INotification;
use App\Repositories\Contracts\IPost;
use App\Repositories\Contracts\IUser;
use App\Traits\HttpResponse;
use Illuminate\Http\Request;

class NotificationsController extends Controller
{
    use HttpResponse;
    protected $user,$notification,$group,$post;
    public function __construct(IUser $user, INotification $notification, IGroup $group,IPost $post){
        $this->user = $user;
        $this->notification = $notification;
        $this->group = $group;
        $this->post = $post;
    }
    public function getAllNotification() :\Illuminate\Http\Response
    {
        $user = auth()->user();
        $user = $this->user->find($user->id);
        $notifications = $user->notifications;
        foreach($notifications as $notification){
            if($notification->sent_as_type == 'App\Models\User' && $this->user->findWhere('id',$notification->sent_as_id)->isEmpty())
            {
                    $this->notification->delete($notification->id);
            }
            else if($notification->sent_as_type == 'App\Models\Group' && $this->group->findWhere('id',$notification->sent_as_id)->isEmpty())
            {
                $this->notification->delete($notification->id);
            }
            else if($notification->sent_as_type == 'App\Models\Post'  && ($this->post->findWhere('id',$notification->sent_as_id)->isEmpty())) {
                $this->notification->delete($notification->id);
            }
        }
        $notifications = $user->notifications;
        $notifications =  collect($notifications)->sortByDesc('created_at');
        return self::returnData('notifications',NotificationResource::collection($notifications),'your notifications:',200);
    }

    public function isSeen($id): \Illuminate\Http\Response
    {
        $notification =  $this->notification->find($id);
        $this->notification->forceFill(['isSeen'=>true],$notification->id);
        return self::success('notification seen successfully',200);

    }

    public function unreadCount(): \Illuminate\Http\Response
    {
        $user = $this->user->find(auth()->user()->id);
        return self::returnData('unread_count',['count'=>count($this->notification->checkByTwoConditions('notifiable_id',$user->id,'isSeen',false)->get())],'success',200);
    }

}
