<?php

namespace App\Repositories\Criteria;

interface ICriterion
{
    public function apply($model);
}
