<?php

namespace App\Repositories\Contracts;

interface IComment
{
    public function commentsCount($post):int;
}
