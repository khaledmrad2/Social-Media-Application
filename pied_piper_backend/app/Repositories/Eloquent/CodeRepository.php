<?php

namespace App\Repositories\Eloquent;

use App\Mail\SendCode;
use App\Models\Code;
use App\Repositories\Contracts\ICode;
use Illuminate\Support\Facades\Mail;

class CodeRepository extends BaseRepository implements ICode
{
    private $action;

    public function model(): string
    {
        return Code::class;
    }

    public function findAndDelete($column, $value, $column1, $value1)
    {
        $this->model->where($column, $value)
            ->where($column1, $value1)->delete();
    }

    public function findCode($column, $value, $column1, $value1) {
        return $this->model->where($column, $value)
            ->where($column1, $value1)->firstOrFail();
    }

    public function findExpiredCode($column, $value, $column1, $value1)
    {
        // find the code
        $code = $this->checkByTwoConditions($column, $value, $column1, $value1)->firstOrFail();

        // check if it does not expire: the time is one hour
        if ($code->created_at > now()->addHour()) {
            $code->delete();
            return self::failure('code has expired', 422);
        }
        return $code;
    }

    private function insertType(&$data, $type) {
        if ($type == 'send') {
            $data['type'] = 'send';
            $this->action = 'verify your email';
        } else {
            $data['type'] = 'reset';
            $this->action = 'reset your account password';
        }
    }

    public function generateCode($email, $type) {
        $data['email'] = $email;

        // Delete all old code that user send before.
        $this->findAndDelete('email', $email, 'type', $type);

        // Generate random code
        $data['code'] = mt_rand(100000, 999999);

        // insert type to code __reset __resend
        $this->insertType($data, $type);

        // Create a new code
        $codeData = $this->model->create($data);

        // Send email to user
        Mail::to($email)->send(new SendCode($codeData->code, $this->action));
    }
}
