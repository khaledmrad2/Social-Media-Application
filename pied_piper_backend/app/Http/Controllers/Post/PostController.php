<?php

namespace App\Http\Controllers\Post;

use App\Http\Requests\Post\PostRequest;
use App\Http\Resources\Post\PostFormatResource;
use App\Repositories\Contracts\IGroup;
use App\Repositories\Contracts\INotification;
use App\Repositories\Contracts\IPost;
use App\Repositories\Contracts\IPost_Image;
use App\Repositories\Contracts\ISharedPost;
use App\Repositories\Contracts\IUser;
use App\Traits\Cloudinary;
use App\Traits\Notifications;
use Illuminate\Http\Request;
use App\Http\Controllers\Controller;
use App\Traits\HttpResponse;
use Cloudinary\Api\Admin\AdminApi;
use Cloudinary\Api\Search\SearchApi;
use Illuminate\Support\Facades\App;

class PostController extends Controller
{
    use HttpResponse, Cloudinary, Notifications;

    protected $post,$Post_Image,$user,$sharedPost,$group,$notification;

    public function __construct(IPost $post, IPost_Image $Post_Image,IUser $user,ISharedPost $sharedPost, IGroup $group, INotification $notification)
    {
        $this->post = $post;
        $this->Post_Image = $Post_Image;
        $this->user = $user;
        $this->sharedPost = $sharedPost;
        $this->group = $group;
        $this->notification = $notification;
    }

    /**
     * @OA\Post(
     * path="/api/post/create/{type}",
     * operationId="create post",
     * tags={"Posts"},
     * summary="create post",
     * description="User create post here",
     * security={{"JWT":{}}},
     *   @OA\Parameter(
     *         name="type",
     *         in="path",
     *         description="normal or job or profilePicture or coverPicture",
     *         required=true,
     *      ),
     *     @OA\RequestBody(
     *         @OA\JsonContent(),
     *         @OA\MediaType(
     *            mediaType="multipart/form-data",
     *            @OA\Schema(
     *               type="object",
     *               required={},
     *               @OA\Property(property="text", type="text"),
     *               @OA\Property(property="images[]", type="file"),
     *               @OA\Property(property="video", type="file"),
     *               @OA\Property(property="voice_record", type="file"),
     *               @OA\Property(property="background", type="text"),
     *            ),
     *        ),
     *    ),
     *      @OA\Response(
     *          response=200,
     *          description="post created successfully!",
     *          @OA\JsonContent()
     *       ),
     * )
     */
    public function create(PostRequest $request, $type): \Illuminate\Http\Response
    {
       $images = array();
       $user = auth()->user();
       $user = $this->user->find($user->id);
       $data = array_merge($request->all(), ['user_id'=>$user->id]);
       $data['type'] = $type;

       // check if user in group or not
        if ($request->group_id
            && !$this->group->find($request->group_id)->users->contains($user->id)) {
            return self::failure("cannot create post in this group", 422);
        }

       //check the data then upload it to cloudinary
       $uploaded_data = $this->post->uploadFiles($data);


       if(array_key_exists('images',$uploaded_data))
           for($i = 0 ;$i<sizeof($uploaded_data['images']) ; $i++)
               $images[$i] = $uploaded_data['images'][$i];
       unset($uploaded_data['images']);

       //add data to database
       $post = $this->post->create($uploaded_data);
       $this->Post_Image->uploadImages($images,$post->id);
       foreach ($user->friends()->get() as $friend){
           self::PostNotification($friend->friend_id,'post',$post->id);
       }

       return self::returnData('post',new PostFormatResource($post),"post created successfully!", 200);
   }
    /**
     * @OA\Post (
     * path="/api/post/update/{post_id}",
     * operationId="update post",
     * tags={"Posts"},
     * summary="update post",
     * description="User update post here",
     * security={{"JWT":{}}},
     *   @OA\Parameter(
     *         name="post_id",
     *         in="path",
     *         description="id of the post",
     *         required=true,
     *      ),
     *     @OA\RequestBody(
     *         @OA\JsonContent(),
     *         @OA\MediaType(
     *            mediaType="multipart/form-data",
     *            @OA\Schema(
     *               type="object",
     *               required={},
     *               @OA\Property(property="text", type="text"),
     *            ),
     *        ),
     *    ),
     *      @OA\Response(
     *          response=200,
     *          description="post Updated successfully!",
     *          @OA\JsonContent()
     *       ),
     * )
     */

    public function update(PostRequest $request,$id):\Illuminate\Http\Response
    {
       $user = auth()->user();
       $data = $request->all();
       $post = $this->post->find($id);
       if ($user->cannot('update', $post)) {
           App::abort(403, 'Access denied');
         }

       if($this->post->checkData($data)){
           return self::failure('wrong data, check your post elements please',400);
       }

       if(array_key_exists('text',$data) ) {
           $this->post->forceFill(['text' => $data['text']], $post->id);
       }
        else if(!array_key_exists('text',$data)) {
            $this->post->forceFill(['text' => null], $post->id);
        }

       if(array_key_exists('background',$data)) {
           $this->post->forceFill(['background' => $data['background']], $post->id);
       }
       else if(!array_key_exists('background',$data)) {
           $this->post->forceFill(['background' => null], $post->id);
       }

        if(array_key_exists('video',$data) ) {
           $video = self::uploadVideo($data['video'], $user->id, 'posts');
           $this->post->forceFill(['video'=>$video],$post->id);
        }
        else if(!array_key_exists('video',$data)){
            $this->post->forceFill(['video'=>null],$post->id);
        }

        if(array_key_exists('voice_record',$data) ) {
            $voice_record = self::uploadVoice($data['voice_record'], $user->id, 'posts');
            $this->post->forceFill(['voice_record'=>$voice_record],$post->id);
        }
        else if(!array_key_exists('voice_record',$data)){
            $this->post->forceFill(['voice_record'=>null],$post->id);
        }

        if(array_key_exists('images',$data)) {
            $images = $post->post_images()->get();
            foreach ($images as $image) {
                $this->Post_Image->delete($image->id);
            }
            $post_images = array();
            for($i = 0 ;$i<sizeof($data['images']) ; $i++) {
                $post_images[$i] = self::uploadVoice($data['images'][$i], $user->id, 'posts');
            }
            $this->Post_Image->uploadImages($post_images,$post->id);

        }
        else if(!array_key_exists('images',$data)){
            $images = $post->post_images()->get();
            foreach ($images as $image) {
                $this->Post_Image->delete($image->id);
            }
        }
        $post = $this->post->find($id);
       return self::returnData('post',new PostFormatResource($post),"post updated successfully!", 200);
    }

    /**
     *  @OA\delete(
     *      path="/api/post/delete/{post_id}",
     *      operationId="deletePost",
     *      tags={"Posts"},
     *      summary="delete post",
     *      security={{"JWT":{}}},
     *      @OA\Parameter(
     *         name="post_id",
     *         in="path",
     *         description="id of post you want to delete",
     *         required=true,
     *      ),
     *      @OA\Response(
     *          response=200,
     *          description="post deleted",
     *      ),
     *      @OA\Response(
     *          response="401",
     *          description="unauthorized."
     *      ),
     *  )
     */
    public function delete($post):\Illuminate\Http\Response
    {
        $user = auth()->user();
        $post = $this->post->find($post);
        if ($user->cannot('delete', $post)) {
            App::abort(403, 'Access denied');
        }
        $this->post->deleteFromCloudinary($post);
        $post = $this->post->delete($post->id);
        return self::success("post deleted successfully!", 200);
    }

    public function myPosts(){
        $user = auth()->user();
        return self::returnData('posts',PostFormatResource::collection($user->post()->get()),"success!", 200);

    }

    /**
     *  @OA\Get(
     *      path="/api/post/friendsPosts",
     *      operationId="friendsPosts",
     *      tags={"Posts"},
     *      summary="get all posts",
     *      security={{"JWT":{}}},
     *      @OA\Response(
     *          response=200,
     *          description="all posts",
     *      ),
     *      @OA\Response(
     *          response="401",
     *          description="unauthorized."
     *      ),
     *  )
     */
    public function friendsPosts(): \Illuminate\Http\Response
    {
        $user = auth()->user();
        $userFriends = $user->friends()->get();
        $friendPosts = [];
        foreach($userFriends as $friend)
            foreach(($this->post->findWhere('user_id',$friend->friend_id)) as $post) {
                if($post->group_id==null){
                $post['is_shared_post'] = false;
                array_push($friendPosts, (object)$post);
            }}

        foreach ($userFriends as $friend)
            foreach (($this->sharedPost->findWhere('user_id',$friend->friend_id)) as $sharedPost){
                $post = $this->post->find($sharedPost->post_id);
                $sharedUser = $this->user->find($sharedPost->user_id);
                $post['is_shared_post'] = true;
                $post['shared_user_id'] = $sharedUser->id;
                $post['shared_post_id'] = $sharedPost->id;
                $post['shared_user_picture'] = $sharedUser->picture;
                $post['shared_user_name'] = $sharedUser->name;
                $post['created_at'] = $sharedPost->created_at;
                array_push($friendPosts, (object)$post);
            }

        foreach($user->post as $myPost){
            $myPost['is_shared_post'] = false;
            array_push($friendPosts, (object)$myPost);
        }

        foreach($user->shared_posts()->get() as $myPost){
            $post = $this->post->find($myPost->post_id);
            $sharedUser = $this->user->find($myPost->user_id);
            $post['is_shared_post'] = true;
            $post['shared_user_id'] = $sharedUser->id;
            $post['shared_post_id'] = $myPost->id;
            $post['shared_user_picture'] = $sharedUser->picture;
            $post['shared_user_name'] = $sharedUser->name;
            $post['created_at'] = $myPost->created_at;
            array_push($friendPosts, (object)$post);
        }


        $allGroups = $this->group->all();
        $myGroups = array();
        foreach ($allGroups as $group){
            if($group->users->contains($user->id)){
            array_push($myGroups ,$group );
        }}

        foreach ($myGroups as $group){
            $groupPosts = $this->post->findwhere('group_id',$group->id);
            foreach ($groupPosts as $groupPost)
                if($groupPost->user_id!=$user->id)
                    array_push($friendPosts,$groupPost);
        }

        $friendPosts = collect($friendPosts)->sortByDesc('created_at');
        return self::returnData('posts',PostFormatResource::collection($friendPosts),"success!", 200);

    }

    public function getPost($id): \Illuminate\Http\Response
    {
        $post =  $this->post->find($id);
        return self::returnData('post',new PostFormatResource($post),'success',200);
    }
}

//$admin = new AdminApi();
//$search = new SearchApi();
//return $search ->expression('folder : test')  ->execute();
