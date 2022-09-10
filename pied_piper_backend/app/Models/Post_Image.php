<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Post_Image extends Model
{
    use HasFactory;
    protected $table = "post_images";
    protected $primaryKey = "id";
    public $timestamps = true;
    protected $guarded = [];

    //////////////////////////////// relations ////////////////////////////////
    public function posts() :\Illuminate\Database\Eloquent\Relations\BelongsTo
    {
        return $this->belongsTo(Post::class);
    }
}
