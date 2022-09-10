<?php

namespace App\Http\Controllers\user;

use App\Http\Controllers\Controller;
use App\Http\Requests\Auth\UpdateJobTitles;
use App\Http\Requests\user\deleteAccountRequest;
use App\Http\Resources\Cloudinary\CloudinaryResource;
use App\Http\Resources\user\OtherUserResource;
use App\Http\Resources\user\UserResource;
use App\Repositories\Contracts\IUser;
use App\Traits\Cloudinary;
use App\Traits\HttpResponse;
use Illuminate\Http\Request;
use Cloudinary\Api\Search\SearchApi;
use Illuminate\Support\Facades\Auth;

class UserProfileController extends Controller
{
    use Cloudinary;
    use HttpResponse;
    private $user;

    public function __construct(IUser $user) {
        $this->user = $user;
    }


    /**
     *  @OA\Get(
     *      path="/api/profile/{id}",
     *      operationId="profile",
     *      tags={"user_profile"},
     *      summary="get user profile",
     *      security={{"JWT":{}}},
     *       @OA\Parameter(
     *         name="id",
     *         in="path",
     *         description="id of your profile or of other user profile",
     *         required=true,
     *      ),
     *      @OA\Response(
     *          response=200,
     *          description="user profile",
     *      ),
     *      @OA\Response(
     *          response="401",
     *          description="unauthorized."
     *      ),
     *  )
     */
    public function getMyProfile($id): \Illuminate\Http\Response
    {
        if ($id == auth()->user()->id) {
            return self::returnData("profile", new UserResource(auth()->user()), "user profile", 200);
        }
        return self::returnData("profile", new OtherUserResource($this->user->find($id)), "user profile", 200);
    }

    /**
     * @OA\Post(
     * path="/api/updatePicture",
     * operationId="update_picture",
     * tags={"user_profile"},
     * summary="update picture",
     * description="User update his picutre here",
     * security={{"JWT":{}}},
     *     @OA\RequestBody(
     *         @OA\JsonContent(),
     *         @OA\MediaType(
     *            mediaType="multipart/form-data",
     *            @OA\Schema(
     *               type="object",
     *               required={},
     *               @OA\Property(property="picture", type="file"),
     *            ),
     *        ),
     *    ),
     *      @OA\Response(
     *          response=200,
     *          description="picture updated successfully!",
     *          @OA\JsonContent()
     *       ),
     * )
     */


    public function updatePicture (Request $request): \Illuminate\Http\Response
    {
        $newImage['picture'] = $request->file('picture');
        $folder = (string) auth()->user()->id;
        $subFolder = "userPicture";
        $newImageUrl['picture'] = self::uploadImages( $newImage['picture'] ,$folder,$subFolder );
        $this->user->forceFill($newImageUrl , auth()->user()->id );
        return self::returnData('picture_url',$newImageUrl['picture'],"picture updated successfully", 200);
    }

    public function deletePicture(): \Illuminate\Http\Response
    {
        $user = auth()->user();
        $this->user->forceFill(['picture'=>'https://res.cloudinary.com/dxntbhjao/image/upload/v1659863927/1/posts/pjfemlrvoh3dlokoccpp.jpg'],$user->id);
        return self::returnData('picture_url','https://res.cloudinary.com/dxntbhjao/image/upload/v1659863927/1/posts/pjfemlrvoh3dlokoccpp.jpg',"picture deleted successfully", 200);

    }

    /**
     * @OA\Post(
     * path="/api/updateCover",
     * operationId="update_cover",
     * tags={"user_profile"},
     * summary="update cover",
     * description="User update his cover here",
     * security={{"JWT":{}}},
     *     @OA\RequestBody(
     *         @OA\JsonContent(),
     *         @OA\MediaType(
     *            mediaType="multipart/form-data",
     *            @OA\Schema(
     *               type="object",
     *               required={},
     *               @OA\Property(property="cover", type="file"),
     *            ),
     *        ),
     *    ),
     *      @OA\Response(
     *          response=200,
     *          description="cover updated successfully!",
     *          @OA\JsonContent()
     *       ),
     * )
     */
    public function updateCover (Request $request): \Illuminate\Http\Response
    {
        $newImage['cover'] = $request->file('cover');
        $newImageUrl['cover'] = self::uploadImages( $newImage['cover'] ,(string)auth()->user()->id,'covers');
        $this->user->forceFill($newImageUrl , auth()->user()->id );
        return self::returnData('cover_url',$newImageUrl['cover'],'cover updated successfully', 200);
    }

    public function deleteCover(): \Illuminate\Http\Response
    {
        $user = auth()->user();
        $this->user->forceFill(['cover'=>'https://res.cloudinary.com/dxntbhjao/image/upload/v1659863975/1/posts/oox0omtyvag3egnfq7h9.webp'],$user->id);
        return self::returnData('cover_url','https://res.cloudinary.com/dxntbhjao/image/upload/v1659863975/1/posts/oox0omtyvag3egnfq7h9.webp','cover deleted successfully', 200);
    }
    /**
     *  @OA\Get(
     *      path="/api/userPictures",
     *      operationId="profile_pictures",
     *      tags={"user_profile"},
     *      summary="get user pictures",
     *      security={{"JWT":{}}},
     *      @OA\Response(
     *          response=200,
     *          description="user pictures",
     *      ),
     *      @OA\Response(
     *          response="401",
     *          description="unauthorized."
     *      ),
     *  )
     */
    public function allUserPictures ()//: \Illuminate\Http\Response
    {
        $search = new SearchApi();
        $folder = auth()->user()->id;
        $subFolder = '/'.'userPicture';
        $folder = $folder.$subFolder;
        $search = $search ->expression($folder)->execute();
        //        TODO
//        return $search['resources'][0]["url"];
        $search['resources'] = (object)collect($search['resources']);
        $new_images=[];
        $images=[];
        $i=1;
        foreach($search['resources'] as $image) {
            $images[$i] = $image['url'];
            array_push($new_images, ["picture" => $images[$i]]);
            $i++;
        }
        return  self::returnData("user_profile_images",$new_images , "your images", 200);

    }
    /**
     * @OA\Post(
     * path="/api/updateJobTitles",
     * operationId="update_JobTitles",
     * tags={"user_profile"},
     * summary="update JobTitles",
     * description="User update his JobTitles here",
     * security={{"JWT":{}}},
     *     @OA\RequestBody(
     *         @OA\JsonContent(),
     *         @OA\MediaType(
     *            mediaType="multipart/form-data",
     *            @OA\Schema(
     *               type="object",
     *               required={"available_to_hire","job_title","location"},
     *               @OA\Property(property="available_to_hire"),
     *               @OA\Property(property="job_title", type="string"),
     *               @OA\Property(property="location", type="string"),
     *
     *            ),
     *        ),
     *    ),
     *      @OA\Response(
     *          response=200,
     *          description="JobTitles updated successfully!",
     *          @OA\JsonContent()
     *       ),
     * )
     */
    public function updateJobTitles(UpdateJobTitles $request) : \Illuminate\Http\Response
    {
        $data = $request->all();
        $this->user->forceFill($data , auth()->user()->id );
        $user = auth()->user();
        $user = $this->user->find($user->id);
        return self::returnData("job_titles",['available_to_hire'=>$user->available_to_hire,'location'=>$user->location,'job_title'=>$user->job_title],'job titles updated successfully' ,200);
    }

    public function allPostPictures($id): \Illuminate\Http\Response
    {
        $user = $this->user->find($id);
        return  self::returnData("user_posts_images",$this->user->allPostImages($user->id) , "all user posts images", 200);
    }

    public function deleteAccount(deleteAccountRequest $request): \Illuminate\Http\Response
    {
        $token = Auth::guard('user')->attempt(array_merge($request->all(),['email'=>auth()->user()->email]));

        if (!$token) {
            return self::failure("wrong password, please check your inputs again", 403);
        }

        $this->user->delete(auth()->user()->id);

        return self::success('account deleted successfully',200);

    }

}
