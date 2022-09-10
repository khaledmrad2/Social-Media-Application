<?php

namespace App\Repositories\Eloquent\Criteria;

use App\Repositories\Criteria\ICriterion;

class WithTrashed implements ICriterion
{
    public function apply($model) {
        return $model->withTrashed();
    }
}
