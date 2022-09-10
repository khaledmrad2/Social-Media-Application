<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Saved_Post extends Model
{
    use HasFactory;
    protected $table = 'saved_posts';
    protected $primaryKey = 'id';
    protected $guarded = [];
    public $timestamps = true;

    //////////////////////////////// relations ////////////////////////////////
     public function posts(): \Illuminate\Database\Eloquent\Relations\BelongsTo
     {
     return $this->belongsTo(Post::class);
     }
    public function users(): \Illuminate\Database\Eloquent\Relations\BelongsTo
    {
        return $this->belongsTo(Post::class);
    }


}
