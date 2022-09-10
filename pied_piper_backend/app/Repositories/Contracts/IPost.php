<?php

namespace App\Repositories\Contracts;

use phpDocumentor\Reflection\Types\Boolean;

interface IPost
{
public function uploadFiles($data);
public function checkData($data):bool;
}


