<?php

namespace App\Listeners;

use Illuminate\Contracts\Queue\ShouldQueue;
use Illuminate\Queue\InteractsWithQueue;

class NewUserHasRegistered
{
    public function handle($event)
    {
        if ($event->from == "web") {
            $event->user->sendEmailVerificationNotification();
        } else {
            $event->code->generateCode($event->user->email, "send");
        }
    }
}
