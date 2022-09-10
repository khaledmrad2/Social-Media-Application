<?php

namespace App\Repositories\Eloquent;

use App\Models\Admin;
use App\Repositories\Contracts\IAdmin;

class AdminRepository extends BaseRepository implements IAdmin
{
    public function model(): string
    {
        return Admin::class;
    }
}
