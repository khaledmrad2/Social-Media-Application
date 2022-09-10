<?php

namespace App\Http\Requests\Post;

use Illuminate\Foundation\Http\FormRequest;

class  PostRequest extends FormRequest
{
    public function authorize(): bool
    {
        return true;
    }

    public function rules(): array
    {
        return  [
            'text'=>'string',
            'background'=>'string',
            'video'=>'file',
            'voice_record'=>'file',
            'images',
            'group_id' => 'integer'
        ];

    }
}
