<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Warning extends Model
{
    use HasFactory;
    protected $table = 'warnings';
    protected $primaryKey = 'id';
    public $timestamps = true;
    protected $guarded = [];

    //////////////////////////////// relations ////////////////////////////////
    public function admins(): \Illuminate\Database\Eloquent\Relations\BelongsTo
    {
        return $this->belongsTo(Admin::class);
    }
    public function users(): \Illuminate\Database\Eloquent\Relations\BelongsTo
    {
        return $this->belongsTo(User::class);
}

}
