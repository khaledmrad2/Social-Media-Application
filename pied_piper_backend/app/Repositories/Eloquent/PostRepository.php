<?php

namespace App\Repositories\Eloquent;

use App\Models\Post;
use App\Models\Post_Image;
use App\Repositories\Contracts\IPost;
use App\Traits\Cloudinary;
use Illuminate\Support\Facades\App;
use phpDocumentor\Reflection\Types\Boolean;
use Symfony\Component\HttpKernel\Exception\BadRequestHttpException;


class PostRepository extends BaseRepository implements IPost{
    use Cloudinary;
    public function model(): string
    {
        return Post::class;
    }
    public function uploadFiles($data)
    {
        //check the data
       if($this->checkData($data)){
            throw new BadRequestHttpException('wrong data, check your post elements please');
       }

       //check if there is a voice record then upload it to the cloudinary
       if(array_key_exists('voice_record',$data)){
           $record = self::uploadVoice($data['voice_record'],(string)auth()->user()->id,"posts");
           $data['voice_record'] = $record;
       }

        //check if there is a video then upload it to the cloudinary
       if(array_key_exists('video',$data))
           $data['video'] =  self::uploadVideo($data['video'],(string)auth()->user()->id,"posts");

        //check if there is images then upload it to the cloudinary
       if(array_key_exists('images',$data)) {
           for($i=0;$i<sizeof($data['images']);$i++)
               $data['images'][$i] =  self::uploadImages( $data['images'][$i],(string)auth()->user()->id,"posts");}

       //return the data after upload it
       return  $data;// self::returnData('post',$data,"uploaded successfully",200);
    }



    public function checkData($data):bool
    {
        if(array_key_exists('background',$data) && (array_key_exists('voice_record',$data)|| array_key_exists('video',$data)||  array_key_exists('images',$data)) ){
            return true;
        }
        if(array_key_exists('images',$data) && (array_key_exists('voice_record',$data)|| array_key_exists('video',$data)) ){
            return true;
        }
        if(array_key_exists('voice_record',$data) && (array_key_exists('images',$data) ||  array_key_exists('video',$data)) ){
            return true;
        }
        if( array_key_exists('video',$data) && (array_key_exists('images',$data) || array_key_exists('voice_record',$data)) ){
            return true;
        }
    return false;
    }

    public function isVisitor($post): bool
    {
        $user = auth()->user();
        if($user->id == $post->user_id)
            return false;

        return true;
    }

    public function deleteFromCloudinary($post){
        if($post->voice_record!=null){
            self::deleteFile($post->voice_record);
        }

        if($post->video!=null){
            self::deleteFile($post->video);
        }
        $images = $post->post_images()->get();
        if($images!=null){
            foreach ($images as $image)
                self::deleteFile($image->url);
        }

    }


}

