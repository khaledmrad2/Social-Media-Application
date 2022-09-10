<?php

namespace App\Models;

use App\Notifications\VerifyUserEmail;
use Illuminate\Contracts\Auth\MustVerifyEmail;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Foundation\Auth\User as Authenticatable;
use Illuminate\Notifications\Notifiable;
use Laravel\Sanctum\HasApiTokens;
use Tymon\JWTAuth\Contracts\JWTSubject;

class User extends Authenticatable  implements JWTSubject, MustVerifyEmail
{
    use HasApiTokens, HasFactory, Notifiable;

    protected $fillable = [
        'name',
        'email',
        'password',
        'fcm_token',
    ];


    protected $hidden = [
        'password',
        'remember_token',
    ];


    protected $casts = [
        'email_verified_at' => 'datetime',
    ];

    public function sendEmailVerificationNotification()
    {
        $this->notify(new VerifyUserEmail());
    }

    //////////////////////////////// relations ////////////////////////////////
    public function friendRequests(): \Illuminate\Database\Eloquent\Relations\HasMany
    {
        return $this->hasMany(FriendRequest::class);
    }

    public function friendRequestReceivers(): \Illuminate\Database\Eloquent\Relations\HasMany
    {
        return $this->hasMany(FriendRequestReceiver::class);
    }

    public function friends(): \Illuminate\Database\Eloquent\Relations\HasMany
    {
        return $this->hasMany(Friend::class);
    }

    public function searchHistories(): \Illuminate\Database\Eloquent\Relations\HasMany
    {
        return $this->hasMany(SearchHistory::class)->latest();
    }
    public function post(): \Illuminate\Database\Eloquent\Relations\HasMany
    {
        return $this->hasMany(Post::class)->latest();
    }
    public function comments(): \Illuminate\Database\Eloquent\Relations\HasMany
    {
        return $this->hasMany(Comment::class)->latest();

    }

    public function shared_posts(): \Illuminate\Database\Eloquent\Relations\HasMany
    {
        return $this->hasMany(Shared_Post::class);
    }
    public function saved_posts(): \Illuminate\Database\Eloquent\Relations\HasMany
    {
        return $this->hasMany(Saved_Post::class);
    }
    public function  stories(): \Illuminate\Database\Eloquent\Relations\HasMany
    {
        return $this->hasMany(Story::class);
    }

    public function notifications(): \Illuminate\Database\Eloquent\Relations\MorphMany
    {
        return $this->morphMany(Notification::class,'notifiable');
    }
    public function sent_as(): \Illuminate\Database\Eloquent\Relations\MorphMany
    {
        return $this->morphMany(Notification::class ,'sent_as');
    }

    public function groups() : \Illuminate\Database\Eloquent\Relations\BelongsToMany
    {
        return $this->belongsToMany(Group::class)->withTimestamps();
    }

    public function groupRequests(): \Illuminate\Database\Eloquent\Relations\HasMany
    {
        return $this->hasMany(GroupRequest::class);
    }

    public function myInvitations(): \Illuminate\Database\Eloquent\Relations\HasMany
    {
        return $this->hasMany(GroupRequest::class)
            ->where("type", "=", "invite");
    }

    public function myRequests(): \Illuminate\Database\Eloquent\Relations\HasMany
    {
        return $this->hasMany(GroupRequest::class)
            ->where("type", "=", "normal");
    }

    public function groupRequestReceivers(): \Illuminate\Database\Eloquent\Relations\HasMany
    {
        return $this->hasMany(GroupRequestReceiver::class);
    }

    public function complaints(): \Illuminate\Database\Eloquent\Relations\MorphMany
    {
        return $this->morphMany(Complaint::class,'complaintable');
    }
    public function warnings(): \Illuminate\Database\Eloquent\Relations\HasMany
    {
        return $this->hasMany(Warning::class);
    }

    public function chats()
    {
        return $this->belongsToMany(Chat::class, 'participants');
    }

    public function messages()
    {
        return $this->hasMany(Message::class);
    }

    public function getChatWithUser($user_id)
    {
        return $this->chats()->whereHas('participants', function ($query) use ($user_id) {
            $query->where('user_id', $user_id);
        })->first();
    }
    public function fcm_tokens(): \Illuminate\Database\Eloquent\Relations\HasMany
    {
        return $this->hasMany(Fcm_Token::class);
    }
    /////////////////////////////// JWT Functions //////////////////////////////
    public function getJWTIdentifier()
    {
        return $this->getKey();
    }

    public function getJWTCustomClaims(): array
    {
        return [];
    }
}
