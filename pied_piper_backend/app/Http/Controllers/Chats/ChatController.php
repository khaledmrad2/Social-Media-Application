<?php

namespace App\Http\Controllers\Chats;

use App\Http\Controllers\Controller;
use App\Http\Resources\Chat\ChatResource;
use App\Repositories\Contracts\IChat;
use App\Repositories\Contracts\IMessage;
use App\Repositories\Contracts\IUser;
use App\Repositories\Eloquent\Criteria\WithTrashed;
use App\Traits\HttpResponse;
use App\Traits\Notifications;
use Illuminate\Http\Request;

class ChatController extends Controller
{
    use HttpResponse,Notifications;
    private $user,$chat,$message,$withTrashed;
    public function __construct(IUser $user,IChat $chat,IMessage $message,WithTrashed $withTrashed){
        $this->user = $user;
        $this->chat = $chat;
        $this->message = $message;
        $this->withTrashed = $withTrashed;
    }

    public function allChats()//: \Illuminate\Http\Response
    {
        $user = $this->user->find(auth()->user()->id);
        $chats = $user->chats()->get();
        $friends =  $user->friends()->get();
        $chat_friends = array();
        $diff =  array();
        foreach ($chats as $chat)
            array_push($chat_friends,$this->chat->getOtherUser($chat->id));

        foreach ($friends as $friend)
            if(!in_array($friend->friend_id, $chat_friends))
                array_push($diff,$friend);

        foreach ($diff as $newFriendChat){
             $friend = $this->user->find($newFriendChat->friend_id);
             $data['updated_at'] = $newFriendChat->updated_at;
             $data['created_at'] = $newFriendChat->updated_at;
             $data['otherUser_id']  = $friend->id;
             $data['otherUser_pic']  = $friend->picture;
             $data['otherUser_name']  = $friend->name;
             $data['latest_Message_created_at'] = $newFriendChat->updated_at;
             $data['latest_Message_body'] = 'Say Hi To Your Friend !';
             $data['id'] = null;
             $chats->push((object)$data);
    }
        $chats = collect($chats)->sortByDesc('updated_at');
        return self::returnData('chats',ChatResource::collection($chats),'all chats',200);
    }


}
