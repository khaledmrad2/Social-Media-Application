<?php

namespace App\Repositories\Eloquent;

use App\Models\Message;
use App\Repositories\Contracts\IMessage;

class MessageRepository extends BaseRepository implements IMessage
{
    public function model(): string
    {
        return Message::class;
    }

}
