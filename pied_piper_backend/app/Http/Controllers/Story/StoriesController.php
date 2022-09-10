<?php

namespace App\Http\Controllers\Story;

use App\Http\Controllers\Controller;
use App\Http\Requests\Story\StoryRequest;
use App\Http\Resources\Story\StoryResource;
use App\Repositories\Contracts\IStory;
use App\Repositories\Contracts\IUser;
use App\Traits\Cloudinary;
use App\Traits\HttpResponse;
use Carbon\Carbon;
use Cloudinary\Api\Admin\AdminApi;
use Cloudinary\Api\Search\SearchApi;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\App;

class StoriesController extends Controller
{
    use HttpResponse, Cloudinary;
    Protected $user , $story ;
    public function __construct(IUser $user , IStory $story)
    {
        $this->user = $user;
        $this->story = $story;
    }
    /**
     * @OA\Post(
     * path="/api/story/create",
     * operationId="create story",
     * tags={"Stories"},
     * summary="create story",
     * description="User create story here",
     * security={{"JWT":{}}},
     *     @OA\RequestBody(
     *         @OA\JsonContent(),
     *         @OA\MediaType(
     *            mediaType="multipart/form-data",
     *            @OA\Schema(
     *               type="object",
     *               required={},
     *               @OA\Property(property="text", type="text"),
     *               @OA\Property(property="image", type="file"),
     *            ),
     *        ),
     *    ),
     *      @OA\Response(
     *          response=200,
     *          description="story created successfully!",
     *          @OA\JsonContent()
     *       ),
     * )
     */

    public function create(StoryRequest $request): \Illuminate\Http\Response
    {
        $user = auth()->user();
        $data = $request->all();
        if($this->story->check($data)){
            return self::failure('check your data',400);
        }
        if(array_key_exists('image',$data)){
            $data['image'] = self::uploadImages($data['image'],(string)auth()->user()->id,"stories");
        }
        $data['user_id'] = $user->id;
        $story = $this->story->create($data);

        return self::returnData('story',new StoryResource($story),' story created successfully',200);
    }


    /**
     *  @OA\delete(
     *      path="/api/story/delete/{story_id}",
     *      operationId="delete_story",
     *      tags={"Stories"},
     *      summary="delete story",
     *      security={{"JWT":{}}},
     *      @OA\Parameter(
     *         name="story_id",
     *         in="path",
     *         description="id of story you want to delete",
     *         required=true,
     *      ),
     *      @OA\Response(
     *          response=200,
     *          description="story deleted",
     *      ),
     *      @OA\Response(
     *          response="401",
     *          description="unauthorized."
     *      ),
     *  )
     */
    public function delete($story): \Illuminate\Http\Response
    {
        $user = auth()->user();
        $story = $this->story->find($story);

        if($user->cannot('delete',$story))
            App::abort(403, 'Access denied');

        $this->story->delete($story->id);
        return self::success("story deleted successfully",200);
    }

    /**
     *  @OA\Get(
     *      path="/api/story/getAllStories",
     *      operationId="friends_Stories",
     *      tags={"Stories"},
     *      summary="get all stories",
     *      security={{"JWT":{}}},
     *      @OA\Response(
     *          response=200,
     *          description="all stories",
     *      ),
     *      @OA\Response(
     *          response="401",
     *          description="unauthorized."
     *      ),
     *  )
     */
    public function getStories(): \Illuminate\Http\Response
    {
        $user = auth()->user();
        $userFriends = $user->friends()->get();
        $data=[];
        foreach ($userFriends as $friend) {
            $stories = $this->story->findWhere('user_id', $friend->friend_id);
            foreach ($stories as $story){
                array_push($data ,$story);
            }
        }
        foreach ($user->stories()->get() as $story){
            array_push($data ,$story);
        }

        $data = collect($data)->sortByDesc('created_at');
        return self::returnData('stories',StoryResource::collection($data),'your stories',200);


    }
    public function storiesArchive(): \Illuminate\Http\Response
    {
        $search = new SearchApi();
        $user = auth()->user();
        $folder = $user->id;
        $subFolder = '/'.'stories';
        $folder = $folder.$subFolder;
        $search = $search ->expression($folder)->execute();
        $search['resources'] = (object)collect($search['resources']);
        $new_images=[];
        $images=[];
        $i=1;
        foreach($search['resources'] as $image) {
            $images[$i] = $image['url'];
            array_push($new_images, ["picture" => $images[$i]]);
            $i++;
        }
        return self::returnData("all_user_stories",$new_images , "your stories archive", 200);

    }


}
