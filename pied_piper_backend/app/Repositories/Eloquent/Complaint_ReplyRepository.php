<?php

namespace App\Repositories\Eloquent;

use App\Models\Complaint_Reply;
use App\Repositories\Contracts\IComplaint_Reply;

class Complaint_ReplyRepository extends BaseRepository implements IComplaint_Reply
{
    public function model(): string
    {
        return Complaint_Reply::class;
    }
     public function check($id){
        return $this->findWhere('complaint_id',$id);
     }
}
