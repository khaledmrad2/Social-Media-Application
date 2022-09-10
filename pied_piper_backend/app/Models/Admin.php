<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Tymon\JWTAuth\Contracts\JWTSubject;
use Illuminate\Foundation\Auth\User as Authenticatable;

class Admin extends Authenticatable implements JWTSubject
{
    use HasFactory;

    protected $guarded = [];
    public $timestamps = true;


//////////////////////////////// relations ////////////////////////////////
    public function notifications(): \Illuminate\Database\Eloquent\Relations\MorphMany
    {
        return $this->morphMany(Notification::class,'notifiable');
    }

    public function complaints_replies(): \Illuminate\Database\Eloquent\Relations\HasMany
    {

        return $this->hasMany(Complaint_Reply::class);
    }
    public function warnings(): \Illuminate\Database\Eloquent\Relations\HasMany
    {
        return $this->hasMany(Warning::class);
    }
    /////////////////////////////// JWT Functions //////////////////////////////
    public function getJWTIdentifier()
    {
        return $this->getKey();
    }

    public function getJWTCustomClaims(): array
    {
        return [];
    }
}
