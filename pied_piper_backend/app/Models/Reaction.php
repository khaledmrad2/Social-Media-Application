<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Reaction extends Model
{
    use HasFactory;
    protected $table = "reactions";
    protected $primaryKey = "id";
    public $timestamps = true;
    protected $guarded = [];

    //////////////////////////////// relations ////////////////////////////////
      public function ractionable():\Illuminate\Database\Eloquent\Relations\MorphTo
        {
            return $this->morphTo();
        }
}
