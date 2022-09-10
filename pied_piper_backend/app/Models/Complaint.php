<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Complaint extends Model
{
    use HasFactory;

    protected $guarded = [];

    public function complaintable(): \Illuminate\Database\Eloquent\Relations\MorphTo
    {
        return $this->morphTo();
    }

    public function user(): \Illuminate\Database\Eloquent\Relations\BelongsTo
    {
        return  $this->belongsTo(User::class);
    }
    public function complaints_replies(): \Illuminate\Database\Eloquent\Relations\HasOne
    {
        return $this->hasOne(Complaint_Reply::class);
    }
}
