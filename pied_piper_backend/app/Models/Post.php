<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Post extends Model
{
    use HasFactory;
    protected $table = "posts";
    protected $primaryKey = "id";
    public $timestamps = true;
    protected $guarded = [];
    public $with = ['post_images','comments','reactions'];

    //////////////////////////////// relations ////////////////////////////////
    public function post_images():  \Illuminate\Database\Eloquent\Relations\HasMany
    {
    return $this->hasMany(Post_Image::class);
    }

    public function comments(): \Illuminate\Database\Eloquent\Relations\HasMany
    {
        return $this->hasMany(Comment::class)->latest();
    }

    public function groups():  \Illuminate\Database\Eloquent\Relations\BelongsTo
    {
        return $this->belongsTo(Group::class);
    }

    public function reactions():\Illuminate\Database\Eloquent\Relations\MorphMany
    {
        return $this->morphMany(Reaction::class, 'reactionable');
    }

    public function shared_posts(): \Illuminate\Database\Eloquent\Relations\HasMany
    {
        return $this->hasMany(Shared_Post::class);
    }

    public function saved_posts(): \Illuminate\Database\Eloquent\Relations\HasMany
    {
        return $this->hasMany(Saved_Post::class);
    }

    public function sent_as(): \Illuminate\Database\Eloquent\Relations\MorphMany
    {
        return $this->morphMany(Notification::class ,'sent_as');
    }

    public function complaints(): \Illuminate\Database\Eloquent\Relations\MorphMany
    {
        return $this->morphMany(Complaint::class,'complaintable');
    }

    public function group(): \Illuminate\Database\Eloquent\Relations\BelongsTo
    {
        return $this->belongsTo(Group::class);
    }
}

