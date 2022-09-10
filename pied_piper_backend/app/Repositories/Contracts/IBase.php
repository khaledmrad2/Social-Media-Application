<?php

namespace App\Repositories\Contracts;

interface IBase
{
    public function all();
    public function find($id);
    public function findWhere($column, $value);
    public function findWhereFirst($column, $value);
    public function create(array $data);
    public function update($id, array $data);
    public function delete($id);
    public function forceFill(array $data, $id);
    public function checkByTwoConditions($column, $value, $column1, $value1);
    public function findAndDelete2($column, $value, $column1, $value1);
    public function checkByThreeConditions($column, $value, $column1, $value1, $column2, $value2);
    public function findAndDelete3($column, $value, $column1, $value1, $column2, $value2);
}
