<?php

namespace App\Mail;

use Illuminate\Bus\Queueable;
use Illuminate\Contracts\Queue\ShouldQueue;
use Illuminate\Mail\Mailable;
use Illuminate\Queue\SerializesModels;

class SendCode extends Mailable implements ShouldQueue
{
    use Queueable, SerializesModels;

    public $code, $action;

    public function __construct($code, $action)
    {
        $this->code = $code;
        $this->action = $action;
    }

    public function build(): SendCode
    {
        return $this->markdown('mail.send-code');
    }
}
