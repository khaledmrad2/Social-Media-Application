<?php


namespace App\Repositories\Contracts;

use phpDocumentor\Reflection\Types\Boolean;

interface IPost_Image
{
    public function uploadImages($data,$post_id);
}
