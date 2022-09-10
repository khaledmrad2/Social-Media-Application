<?php

namespace App\Http\Resources\Admin;

use App\Repositories\Eloquent\AdminRepository;
use App\Repositories\Eloquent\UserRepository;
use Illuminate\Http\Resources\Json\JsonResource;

class WarningResource extends JsonResource
{
    /**
     * Transform the resource into an array.
     *
     * @param  \Illuminate\Http\Request  $request
     * @return array|\Illuminate\Contracts\Support\Arrayable|\JsonSerializable
     */
    public function toArray($request)
    {
        $user = new UserRepository();
        $user1 = $user->find($this->user_id);
        $admin = new AdminRepository();
        $admin1 = $admin->find($this->admin_id);
        return [
            'id'=>$this->id,
            'user_id'=>$this->user_id,
            'user_name' => $user1->name,
            'admin_id'=>$this->admin_id,
            'admin_name' => $admin1->name,
            'text'=>$this->text,
        ];
    }
}
