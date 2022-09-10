<?php

namespace App\Http\Controllers\Chats;

use App\Http\Controllers\Controller;
use App\Http\Resources\Chat\MessageResource;
use App\Models\Message;
use App\Notifications\SendPushNotification;
use App\Repositories\Contracts\IChat;
use App\Repositories\Contracts\IMessage;
use App\Repositories\Contracts\IUser;
use App\Repositories\Eloquent\Criteria\WithTrashed;
use App\Traits\HttpResponse;
use App\Traits\Notifications;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\App;
use Kutia\Larafirebase\Services\Larafirebase;
use Illuminate\Support\Facades\Notification;

class MessageController extends Controller
{
    use HttpResponse,Notifications;
    private $user,$chat,$message,$withTrashed;
    public function __construct(IUser $user,IChat $chat,IMessage $message,WithTrashed $withTrashed){
        $this->user = $user;
        $this->chat = $chat;
        $this->message = $message;
        $this->withTrashed = $withTrashed;
    }

    public function create(Request $request,$user_id): \Illuminate\Http\Response
    {
        $sender = $this->user->find(auth()->user()->id);
        $receiver = $this->user->find($user_id);
        $body = $request->input('body');
        $chat = $sender->getChatWithUser($receiver->id);

        if($chat==null){
            $chat = $this->chat->create([]);
            $this->user->syncManyToManyRelationCU($sender->id,$chat->id);
            $this->user->syncManyToManyRelationCU($receiver->id,$chat->id);
        }
        $message = $this->message->create(['user_id'=>$sender->id,'chat_id'=>$chat->id,'body'=>$body]);
        $l = new Larafirebase();
        $l->withtitle('new message!')
            ->withbody($message->body)
            ->withAdditionalData([
                'message_id'=>$message->id,
                'is_visitor'=>$message->user_id!=auth()->user()->id,
                'body'=>$message->body,
                'user_id'=>$message->user_id,
                'user_picture'=>$this->user->find($message->user_id)->picture,
                'user_name'=>$this->user->find($message->user_id)->name,
                'chat_id'=>$message->chat_id,
                'last_read'=>$message->last_read,
                'created_at'=>$message->created_at,
                'deleted_at'=>$message->deleted_at,
            ])
            ->sendMessage($this->user->getTokensAsArray($receiver->id));

            Notification::send($receiver, new SendPushNotification('new message!', $sender->name . " send to you a new message: ".$message->body, $this->user->getTokensAsArray($receiver->id)));

        return self::returnData('message',new MessageResource($message),'message created successfully',200);

    }

    public function getMessages($chat_id): \Illuminate\Http\Response
    {
        $chat = $this->chat->find($chat_id);
        $chat->markAsReadForUser(auth()->user()->id);
        $messages = $this->message->withCriteria([new WithTrashed()])->findWhere('chat_id', $chat->id);
        foreach( $messages as $message)
            if($message->deleted_at != null){
                if($message->user_id == auth()->user()->id){
                    $message->body = "You have deleted this message";
                }
                else
                    $message->body = "This message has been deleted";
            }
        return self::returnData('messages',MessageResource::collection($messages),'all chat messages',200);
    }

    public function unreadMessages($chat_id): \Illuminate\Http\Response
    {
        $chat = $this->chat->find($chat_id);
        return  self::returnData('count',[$chat->unreaded(auth()->user()->id)],'unreadMessages count',200);
    }

    public function deleteMessage($id): \Illuminate\Http\Response
    {
        $user = $this->user->find(auth()->user()->id);
        $message = $this->message->find($id);
        if ($user->cannot('delete', $message)) {
            App::abort(403, 'Access denied');
        }
        $this->message->delete($message->id);
        return self::success('message deleted successfully',200);

    }



}
