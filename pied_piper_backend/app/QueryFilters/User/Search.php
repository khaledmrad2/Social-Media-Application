<?php

namespace App\QueryFilters\User;

use App\QueryFilters\Filter;

class Search extends Filter
{
    protected function applyFilter($builder)
    {
        $searchTerm = request($this->filterName());
        return $builder->where('name', 'like', "%{$searchTerm}%");
    }
}
