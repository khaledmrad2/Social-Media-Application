<?php

namespace App\Http\Resources\Admin\AdminTables;

use App\Repositories\Eloquent\AdminRepository;
use Illuminate\Http\Resources\Json\JsonResource;

class ComplaintReplayResource extends JsonResource
{
    /**
     * Transform the resource into an array.
     *
     * @param  \Illuminate\Http\Request  $request
     * @return array|\Illuminate\Contracts\Support\Arrayable|\JsonSerializable
     */
    public function toArray($request)
    {
        $admin = new AdminRepository();
        $admin1 = $admin->find($this->admin_id);
        return [
            'id'=>$this->id,
            'complaint_id'=>$this->complaint_id,
            'text'=>$this->text,
            'admin_name' => $admin1->name,
            'created_at'=>$this->created_at,
        ];
    }
}
