<?php

namespace App\Repositories\Criteria;

interface ICriteria
{
    public function withCriteria(...$criteria);
}
