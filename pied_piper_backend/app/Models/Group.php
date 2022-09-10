<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Group extends Model
{
    use HasFactory;
    protected $guarded= [];

    public function posts(): \Illuminate\Database\Eloquent\Relations\HasMany
    {
        return $this->hasMany(Post::class);
    }

    public function users(): \Illuminate\Database\Eloquent\Relations\BelongsToMany
    {
        return $this->belongsToMany(User::class);
    }

    public function groupRequests(): \Illuminate\Database\Eloquent\Relations\HasMany
    {
        return $this->hasMany(GroupRequest::class);
    }
    public function normalGroupRequests(): \Illuminate\Database\Eloquent\Relations\HasMany
    {
        return $this->hasMany(GroupRequest::class)
            ->where("type", "=", "normal");
    }

    public function groupRequestReceivers(): \Illuminate\Database\Eloquent\Relations\HasMany
    {
        return $this->hasMany(GroupRequestReceiver::class);
    }
    public function sent_as(): \Illuminate\Database\Eloquent\Relations\MorphMany
    {
        return $this->morphMany(Notification::class ,'sent_as');
    }

}
