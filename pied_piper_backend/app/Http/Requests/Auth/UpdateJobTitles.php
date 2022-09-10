<?php

namespace App\Http\Requests\Auth;

use Illuminate\Foundation\Http\FormRequest;

class UpdateJobTitles extends FormRequest
{
    public function authorize(): bool
    {
        return true;
    }

    public function rules(): array
    {
        return [
            'available_to_hire' => 'required',
            'job_title' => 'required|string',
            'location' => 'required|string',
        ];
    }
}
