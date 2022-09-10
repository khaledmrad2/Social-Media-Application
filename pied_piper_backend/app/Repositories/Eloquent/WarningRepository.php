<?php

namespace App\Repositories\Eloquent;

use App\Models\Warning;
use App\Repositories\Contracts\IWarning;

class WarningRepository extends BaseRepository implements IWarning
{
    public function model(): string
     {
        return Warning::class;
     }

}
