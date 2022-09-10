<?php

namespace App\Repositories\Eloquent;

use App\Models\Complaint;
use App\Repositories\Contracts\IComplaint;

class ComplaintsRepository extends BaseRepository implements IComplaint
{
    public function model(): string
    {
        return Complaint::class;
    }

    public function check($type, $id): bool
    {
        if ($type == "post" && auth()->user()->post->contains($id)
            || $type == "comment" && auth()->user()->comments->contains($id)
            || $type == "user" && auth()->user()->id == $id
            || $type == "group" && auth()->user()->id == $id) {
            return true;
        }

        return false;
    }
}
