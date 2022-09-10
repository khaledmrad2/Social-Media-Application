<?php

namespace App\Traits;

trait Cloudinary
{
    public static function uploadImages($image,$folder,$subFolder)
    {
        $subFolder = "/".$subFolder;
        $folder = $folder.$subFolder;
        return cloudinary()->uploadFile($image->getRealPath(),['folder'=>$folder])->getSecurePath();
    }

    public static function uploadVoice($voice,$folder,$subFolder): array|string
    {
        $subFolder = "/".$subFolder;
        $folder = $folder.$subFolder;
        return  str_replace(".mp4",".mp3",cloudinary()->uploadFile($voice->getRealPath(),['folder'=>$folder])->getSecurePath());
    }

    public static function uploadVideo($video,$folder,$subFolder)
    {
        $subFolder = "/".$subFolder;
        $folder = $folder.$subFolder;
        return cloudinary()->uploadFile($video->getRealPath(),['folder'=>$folder])->getSecurePath();
    }

    public function deleteFile($url)
    {
        $id = '/'.(string)auth()->user()->id.'/';
        $public_id =  strstr($url,$id);
        $public_id[0] = " ";
        $suffix = strstr($public_id,".");
        $public_id = str_replace($suffix,'',$public_id);
        $public_id = ltrim($public_id) ;
        if($suffix=='.png' || $suffix=='.jpg' || $suffix=='.webp' ) {
            return cloudinary()->uploadApi()->destroy($public_id);
        }
        else {
            return cloudinary()->uploadApi()->destroy($public_id, ['resource_type' => 'video']);
        }
    }



}
