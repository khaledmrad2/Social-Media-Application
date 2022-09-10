<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Complaint_Reply extends Model
{
    use HasFactory;
    protected $table = 'complaints_replies';
    protected $primaryKey = 'id';
    public $timestamps = true;
    protected $guarded = [];
    //////////////////////////////// relations ////////////////////////////////
    public function complaints(): \Illuminate\Database\Eloquent\Relations\BelongsTo
    {
        return $this->belongsTo(Complaint::class);
    }
    public function admins(): \Illuminate\Database\Eloquent\Relations\BelongsTo
    {
        return $this->belongsTo(Admin::class);
    }

}
