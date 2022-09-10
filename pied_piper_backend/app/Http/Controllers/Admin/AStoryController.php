<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Http\Resources\AdminTables\StoriesTableResource;
use App\Http\Resources\search\historyResource;
use App\Http\Resources\Story\StoryResource;
use App\Repositories\Contracts\IPost;
use App\Repositories\Contracts\IStory;
use App\Repositories\Contracts\IUser;
use App\Traits\HttpResponse;
use Illuminate\Http\Request;

class AStoryController extends Controller
{
    use HttpResponse;

    private $story, $user;

    public function __construct(IStory $story, IUser $user)
    {
        $this->story = $story;
        $this->user = $user;
    }

    public function getAllStories()
    {
        $stories = $this->story->all();
       return  self::returnData('stories', StoriesTableResource::collection($stories), 'all stories', 200);
    }

    public function allUserStories($id): \Illuminate\Http\Response
    {
        $user = $this->user->find($id);
        $stories = $user->stories()->get();
        return self::returnData('stories', StoryResource::collection($stories), 'all user stories', 200);
    }

    public function deleteUserStory($id): \Illuminate\Http\Response
    {
        $story = $this->story->find($id);
        $this->story->delete($story->id);
        return self::success('story deleted successfully',200);
    }


}
