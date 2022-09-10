<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Comment extends Model
{
    use HasFactory;
    protected $table = "comments";
    protected $primaryKey = "id";
    public $timestamps = true;
    protected $guarded = [];
    public $with = ['reactions'];

    //////////////////////////////// relations ////////////////////////////////
     public function posts():\Illuminate\Database\Eloquent\Relations\BelongsTo
     {
         return $this->belongsTo(Post::class);
     }

    public function users():\Illuminate\Database\Eloquent\Relations\BelongsTo
    {
        return $this->belongsTo(User::class);
    }

    public function reactions():\Illuminate\Database\Eloquent\Relations\MorphMany
    {
        return $this->morphMany(Reaction::class, 'reactionable');
    }

    public function complaints(): \Illuminate\Database\Eloquent\Relations\MorphMany
    {
        return $this->morphMany(Complaint::class,'complaintable');
    }
}
