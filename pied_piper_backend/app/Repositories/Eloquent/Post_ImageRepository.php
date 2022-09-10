<?php

namespace App\Repositories\Eloquent;

use App\Models\Post_Image;
use App\Repositories\Contracts\IPost_Image;
use App\Traits\Cloudinary;

class Post_ImageRepository extends BaseRepository implements  IPost_Image
{
    use Cloudinary;
    public function model(): string
    {
        return Post_Image::class;
    }

    public function uploadImages($images,$post_id){
        for($i=0; $i<sizeof($images) ; $i++){
            $this->model->create([
                'url'=>$images[$i],
                'post_id'=>$post_id]);}
    }

    }

