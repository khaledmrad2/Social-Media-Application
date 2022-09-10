<?php

namespace App\Http\Requests\Group;

use Illuminate\Foundation\Http\FormRequest;

class GroupRequest extends FormRequest
{
    public function authorize(): bool
    {
        return true;
    }

    public function rules(): array
    {
        return [
            'title' => 'required',
            'cover'=> 'file',
            "security"=> 'string'
        ];
    }
}
