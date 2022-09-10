<?php

namespace App\Repositories\Contracts;

interface ICode
{
    public function findAndDelete($column, $value, $column1, $value1);
    public function findCode($column, $value, $column1, $value1);
}
