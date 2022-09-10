<?php

namespace App\Repositories\Eloquent;

use App\Models\Fcm_Token;
use App\Repositories\Contracts\IFcm_Token;

class Fcm_TokenRepository extends BaseRepository implements IFcm_Token
{
    public function model(): string
    {
        return Fcm_Token::class;
    }


}
