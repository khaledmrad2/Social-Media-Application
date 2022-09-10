<?php

namespace App\Repositories\Eloquent;

use App\Models\Group;
use App\Repositories\Contracts\IGroup;

class GroupRepository extends BaseRepository implements IGroup
{
    public function model(): string
    {
        return Group::class;
    }

    private $is_admin;

    public function checkFromAdmin($id)
    {
        $id != null
        && $this->model->find($id)
        && (($this->model->find($id)->user_id == auth()->user()->id ?
            $this->is_admin = true : $this->is_admin = false));
        return $this->is_admin;
    }
}
