<?php

namespace App\Http\Resources\auth;

use App\Repositories\Eloquent\Fcm_TokenRepository;
use Illuminate\Http\Resources\Json\JsonResource;
use Jenssegers\Agent\Agent;

class LoggedInUserResource extends JsonResource
{
    public function toArray($request)
    {
        $fcm_token = new Fcm_TokenRepository();
        $agent = new Agent();
        return [
            'id' => $this->id,
            'name' => $this->name,
            'email' => $this->email,
            'picture' => $this->picture,
            'cover' => $this->cover,
            'available_to_hire' => $this->available_to_hire,
            'location' => $this->location,
            'job_title' => $this->job_title,
            'token' => $this->token,
            'fcm_token'=>$agent->isAndroidOS() == true ? $fcm_token->checkByTwoConditions('device','android','user_id', $this->id)->value('fcm_token'): $fcm_token->checkByTwoConditions('device',$agent->browser(),'user_id', $this->id)->value('fcm_token'),
        ];
    }
}
