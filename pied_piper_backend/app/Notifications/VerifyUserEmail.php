<?php

namespace App\Notifications;

use Illuminate\Bus\Queueable;
use Illuminate\Contracts\Queue\ShouldQueue;
use \Illuminate\Auth\Notifications\VerifyEmail as Notification;
use Illuminate\Support\Carbon;
use Illuminate\Support\Facades\URL;

class VerifyUserEmail extends Notification implements ShouldQueue
{
    use Queueable;

    protected function verificationUrl($notifiable): array|string
    {
        $appUrl = config('app.client_url', config('app.url'));

        $url = URL::temporarySignedRoute(
            'verification.verify',
            Carbon::now()->addMinutes(60),
            ['user' => $notifiable->id]
        );

        return str_replace(url('/api/verify'), $appUrl, $url);
    }
}
