<?php

namespace App\Repositories\Eloquent;

use App\Models\Chat;
use App\Repositories\Contracts\IChat;

class ChatRepository extends BaseRepository implements IChat
{
    public function model(): string
    {
        return Chat::class;
    }

    public function getOtherUser($chat_id){
        $chat = $this->find($chat_id);
        $participants = $chat->participants()->get();

        foreach ($participants as $participant){
            if(auth()->user()->id != $participant->id){
                   $user = $participant->id ;
                }
        }
        return $user;
    }

}
