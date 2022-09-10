<?php

namespace App\Notifications;

use Illuminate\Bus\Queueable;
use Illuminate\Contracts\Queue\ShouldQueue;
use Illuminate\Notifications\Messages\MailMessage;
use Illuminate\Notifications\Notification;
use Kutia\Larafirebase\Services\Larafirebase;

class SendPushNotification extends Notification implements ShouldQueue
{
    use Queueable;
    protected $title;
    protected $message;
    protected $fcmTokens;
    /**
     * Create a new notification instance.
     *
     * @return void
     */
    public function __construct($title,$message,$fcmTokens)
    {
        $this->title = $title;
        $this->message = $message;
        $this->fcmTokens = $fcmTokens;
    }

    /**
     * Get the notification's delivery channels.
     *
     * @param  mixed  $notifiable
     * @return array
     */
    public function via($notifiable)
    {
        return ['firebase'];
    }

    public function toFirebase($notifiable)
    {
        $l = new Larafirebase();
        return $l->withTitle($this->title)
            ->withBody($this->message)
            ->withIcon('https://res.cloudinary.com/dxntbhjao/image/upload/v1659123908/2/userPicture/creexpbwvp4cs9psrmc5.jpg')
            ->withClickAction('http://localhost:3000/home')
            ->sendNotification($this->fcmTokens);
    }

    /**
     * Get the array representation of the notification.
     *
     * @param  mixed  $notifiable
     * @return array
     */
    public function toArray($notifiable)
    {
        return [
            //
        ];
    }
}
