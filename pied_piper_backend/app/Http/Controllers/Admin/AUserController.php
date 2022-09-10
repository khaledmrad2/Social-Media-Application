<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Http\Resources\Admin\AdminTables\FriendsTableResource;
use App\Http\Resources\Admin\AUserResource;
use App\Http\Resources\friend\ReceivedRequestResource;
use App\Http\Resources\user\OtherUserResource;
use App\Http\Resources\user\UserResource;
use App\Repositories\Contracts\IFriendRequestReceiver;
use App\Repositories\Contracts\IUser;
use App\Traits\HttpResponse;
use Illuminate\Http\Request;

class AUserController extends Controller
{
    use HttpResponse;
    private $user,$friendRequestReceiver;
    public function __construct(IUser $user, IFriendRequestReceiver $friendRequestReceiver){
        $this->user = $user;
        $this->friendRequestReceiver = $friendRequestReceiver;
    }

    public function getAllUsers(): \Illuminate\Http\Response
    {
        $users = $this->user->all();
        return self::returnData('all_users',AUserResource::collection($users),'all users in app',200);


    }

    public function getFriendsRequest($id): \Illuminate\Http\Response
    {
        $user = $this->user->find($id);
        $friendRequestReceiver = $this->friendRequestReceiver->findwhere('user_id',$user->id);
        return self::returnData('requests',ReceivedRequestResource::collection($friendRequestReceiver),'all user request receiver',200);
    }


    public function getUserFriends($id)
    {
        $user = $this->user->find($id);
        $friends = $user->friends;
        return self::returnData('friends',FriendsTableResource::collection($friends),'all user friends',200);
    }

    public function deleteUser($id): \Illuminate\Http\Response
    {
        $user = $this->user->find($id);
        $this->user->delete($user->id);
        return self::success('user deleted successfully',200);
    }


}
