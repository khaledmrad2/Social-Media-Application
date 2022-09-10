<?php

namespace App\Http\Controllers\search;

use App\Http\Controllers\Controller;
use App\Http\Resources\search\historyResource;
use App\Http\Resources\search\SearchResource;
use App\Repositories\Contracts\ISearchHistory;
use App\Repositories\Contracts\IUser;
use App\Traits\HttpResponse;
use Carbon\Carbon;

class SearchUsersController extends Controller
{
    use HttpResponse;
    private $user, $searchHistory;

    public function __construct(IUser $user, ISearchHistory $searchHistory) {
        $this->user = $user;
        $this->searchHistory = $searchHistory;
    }

    /**
     *  @OA\Get(
     *      path="/api/users",
     *      operationId="search for users",
     *      tags={"Search"},
     *      summary="get users by search",
     *      security={{"JWT":{}}},
     *   @OA\Parameter(
     *         name="searrch",
     *         in="query",
     *         description="enter name of user you want to search for",
     *         required=true,
     *      ),
     *      @OA\Response(
     *          response=200,
     *          description="all found users",
     *      ),
     *      @OA\Response(
     *          response="401",
     *          description="unauthorized."
     *      ),
     *  )
     */
    public function search(): \Illuminate\Http\Response
    {
        return self::returnData("results", SearchResource::collection($this->user->searchUsers()), "all search results", 200);
    }

    /**
     * @OA\Post(
     * path="/api/search/add/{id}",
     * operationId="addToHistory",
     * tags={"Search"},
     * summary="add to history",
     *   @OA\Parameter(
     *         name="id",
     *         in="path",
     *         description="enter the user searched id to add",
     *         required=true,
     *      ),
     *      @OA\Response(
     *          response=200,
     *          description="added to search history",
     *          @OA\JsonContent()
     *       ),
     * )
     */
    public function addToHistory($id): \Illuminate\Http\Response
    {
        $check = $this->searchHistory->checkByTwoConditions("searched_id", $id, "user_id", auth()->user()->id);
        if ($check->exists()) {
            $this->searchHistory->forceFill(["created_at" => Carbon::now()->toDateTimeString()], $check->get()[0]->id);
            return self::success("updated search history successfully", 200);
        }

        $data = [
            "user_id" => auth()->user()->id,
            "searched_id" => $this->user->find($id)->id
        ];

        $this->searchHistory->create($data);
        return self::success("updated search history successfully", 200);
    }

    /**
     * @OA\Post(
     * path="/api/search/delete/{id}",
     * operationId="deleteFromHistory",
     * tags={"Search"},
     * summary="delete from search history",
     *   @OA\Parameter(
     *         name="id",
     *         in="path",
     *         description="enter the user searched id to remove from search history",
     *         required=true,
     *      ),
     *      @OA\Response(
     *          response=200,
     *          description="removed from search history",
     *          @OA\JsonContent()
     *       ),
     * )
     */
    public function deleteFromHistory($id): \Illuminate\Http\Response
    {
        $check = $this->searchHistory->checkByTwoConditions("searched_id", $id, "user_id", auth()->user()->id);
        if (!$check->exists()) {
            return self::failure("not found in history", 422);
        }

        $check->delete();
        return self::success("deleted from history", 200);
    }

    /**
     *  @OA\Get(
     *      path="/api/search/all",
     *      operationId="getSearchHistory",
     *      tags={"Search"},
     *      summary="get users by search",
     *      security={{"JWT":{}}},
     *      @OA\Response(
     *          response=200,
     *          description="all search history",
     *      ),
     *      @OA\Response(
     *          response="401",
     *          description="unauthorized."
     *      ),
     *  )
     */
    public function getSearchHistory(): \Illuminate\Http\Response
    {
       $user = auth()->user();
       return self::returnData("history", HistoryResource::collection($user->searchHistories()->get()), "all search history", 200);
    }
}
