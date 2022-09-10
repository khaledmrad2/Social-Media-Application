<?php

namespace App\Http\Resources\Admin;

use App\Models\Complaint_Reply;
use App\Repositories\Eloquent\Complaint_ReplyRepository;
use App\Repositories\Eloquent\UserRepository;
use Illuminate\Http\Resources\Json\JsonResource;

class AComplaintResource extends JsonResource
{
    /**
     * Transform the resource into an array.
     *
     * @param  \Illuminate\Http\Request  $request
     * @return array|\Illuminate\Contracts\Support\Arrayable|\JsonSerializable
     */
    public function toArray($request)
    {
        $complaint_reply = new Complaint_ReplyRepository();
        $user = new UserRepository();
        $user1 = $user->find($this->user_id);
        return [
            'id'=>$this->id,
            'user_id'=>$this->user_id,
            'user_name' => $user1->name,
            'complaintable_id'=>$this->complaintable_id,
            'complaintable_type'=>substr($this->complaintable_type, 11),
            'text'=>$this->text,
            'processed'=> !$complaint_reply->check($this->id)->isEmpty(),
            'created_at'=>$this->created_at,
        ];
    }
}
