<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Shared_Post extends Model
{
    use HasFactory;
    protected $table = 'shared_posts';
    protected $primaryKey = 'id';
    protected $guarded = [];
    public $timestamps = true;

    //////////////////////////////// relations ////////////////////////////////

    public function users(): \Illuminate\Database\Eloquent\Relations\BelongsTo
    {
        return $this->belongsTo(User::class);
    }
    public function posts(): \Illuminate\Database\Eloquent\Relations\BelongsTo
    {
        return $this->belongsTo(Post::class);
    }

}



