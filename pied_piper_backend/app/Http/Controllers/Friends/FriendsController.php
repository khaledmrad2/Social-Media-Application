<?php

namespace App\Http\Controllers\Friends;

use App\Http\Controllers\Controller;
use App\Http\Resources\Friend\FriendRequestResource;
use App\Http\Resources\friend\FriendResource;
use App\Http\Resources\friend\ReceivedRequestResource;
use App\Http\Resources\Friend\SuggestedFriendsResource;
use App\Repositories\Contracts\IFriend;
use App\Repositories\Contracts\IFriendRequest;
use App\Repositories\Contracts\IFriendRequestReceiver;
use App\Repositories\Contracts\IUser;
use App\Traits\HttpResponse;
use App\Traits\Notifications;

class FriendsController extends Controller
{
    use HttpResponse,Notifications;
    private $friendRequest, $friendRequestReceiver, $user, $friend;

    public function __construct(IUser $user, IFriend $friend, IFriendRequest $friendRequest, IFriendRequestReceiver $friendRequestReceiver)
    {
        $this->friendRequest = $friendRequest;
        $this->friendRequestReceiver = $friendRequestReceiver;
        $this->friend = $friend;
        $this->user = $user;
    }

    /**
     * @OA\Post(
     * path="/api/friend/add/{id}",
     * operationId="add friend",
     * tags={"Friends"},
     * summary="send request to a person",
     *   @OA\Parameter(
     *         name="id",
     *         in="path",
     *         description="enter the person id you want to add as a friend",
     *         required=true,
     *      ),
     *      @OA\Response(
     *          response=201,
     *          description="request sended successfully",
     *          @OA\JsonContent()
     *       ),
     * )
     */
    public function addFriend($id): \Illuminate\Http\Response
    {
        $user = auth()->user();
        $receiver = $this->user->find($id);

        if ($id == $user->id ||
            $this->friendRequest->checkByTwoConditions('user_id', $user->id, 'receiver_id', $receiver->id)->exists() ||
            $this->friendRequestReceiver->checkByTwoConditions('user_id', $user->id, 'requester_id', $receiver->id)->exists()) {
            return self::failure("idiot", 422);
        }

        if ($this->friend->checkByTwoConditions('user_id', $user->id, 'friend_id', $receiver->id)->exists()){{
            return self::failure("he is already your friend idiot", 422);
        }}

        $request_data = [
            "user_id" => $user->id,
            "receiver_id" => $receiver->id
        ];
        $receiver_data = [
            "user_id" => $receiver->id,
            "requester_id" => $user->id
        ];
        $f_request = $this->friendRequest->create($request_data);
        $this->friendRequestReceiver->create($receiver_data);

        self::UserNotification($receiver->id,'friend_request',$user->id);

        return self::success("request sent successfully", 201);
    }

    /**
     * @OA\Post(
     * path="/api/friend/refuse/{id}",
     * operationId="refuse friend request",
     * tags={"Friends"},
     * summary="refuse friend request",
     *   @OA\Parameter(
     *         name="id",
     *         in="path",
     *         description="enter the person id you want to refuse friend request",
     *         required=true,
     *      ),
     *      @OA\Response(
     *          response=200,
     *          description="request refuesd successfully",
     *          @OA\JsonContent()
     *       ),
     * )
     */
    public function refuseFriendRequest($id): \Illuminate\Http\Response
    {
        $user = auth()->user();
        $from = $this->user->find($id);

        if (!$this->friendRequest->checkByTwoConditions('user_id', $from->id, 'receiver_id', $user->id)->exists()) {
            return self::failure("there is no request to refuse", 422);
        }
        $this->friendRequestReceiver->checkByTwoConditions("user_id", $user->id, "requester_id", $from->id)->delete();
        $this->friendRequest->checkByTwoConditions("user_id", $from->id, "receiver_id", $user->id)->delete();

        return self::success("request refused successfully", 200);
    }

    /**
     * @OA\Post(
     * path="/api/friend/cancel/{id}",
     * operationId="cancel sended friend request",
     * tags={"Friends"},
     * summary="cancel friend request",
     *   @OA\Parameter(
     *         name="id",
     *         in="path",
     *         description="enter the person id you want to cancel friend request",
     *         required=true,
     *      ),
     *      @OA\Response(
     *          response=200,
     *          description="request canceled successfully",
     *          @OA\JsonContent()
     *       ),
     * )
     */
    public function cancelFriendRequest($id): \Illuminate\Http\Response
    {
        $user = auth()->user();
        $to = $this->user->find($id);

        if (!$this->friendRequestReceiver->checkByTwoConditions('user_id', $to->id, 'requester_id', $user->id)->exists()) {
            return self::failure("there is no cancel to refuse", 422);
        }
        $this->friendRequestReceiver->checkByTwoConditions("user_id", $to->id, "requester_id", $user->id)->delete();
        $this->friendRequest->checkByTwoConditions("user_id", $user->id, "receiver_id", $to->id)->delete();

        return self::success("request canceled successfully", 200);
    }

    /**
     * @OA\Post(
     * path="/api/friend/accept/{id}",
     * operationId="accept friend request",
     * tags={"Friends"},
     * summary="accept friend request",
     *   @OA\Parameter(
     *         name="id",
     *         in="path",
     *         description="enter the person id you want to accept his friend request",
     *         required=true,
     *      ),
     *      @OA\Response(
     *          response=200,
     *          description="request accepted successfully",
     *          @OA\JsonContent()
     *       ),
     * )
     */
    public function acceptFriendRequest($id): \Illuminate\Http\Response
    {
        $user = auth()->user();
        $requester = $this->user->find($id);

        if (!$this->friendRequest->checkByTwoConditions("user_id", $id, "receiver_id", $user->id)->exists()) {
            return self::failure("you don't have a friend request from this user", 422);
        }

        $this->friendRequestReceiver->checkByTwoConditions("user_id", $user->id, "requester_id", $requester->id)->delete();
        $this->friendRequest->checkByTwoConditions("user_id", $requester->id, "receiver_id", $user->id)->delete();

        $acceptor_data = [
            "user_id" => $user->id,
            "friend_id" => $requester->id,
        ];
        $requester_data = [
            "user_id" => $requester->id,
            "friend_id" => $user->id,
        ];
        $this->friend->create($acceptor_data);
        $f_data = $this->friend->create($requester_data);

        self::UserNotification($requester->id,'friend_accept',$user->id);

        return self::success("you have a new friend now", 201);
    }

    /**
     * @OA\Post(
     * path="/api/friend/remove/{id}",
     * operationId="remove friend",
     * tags={"Friends"},
     * summary="remove friend",
     *   @OA\Parameter(
     *         name="id",
     *         in="path",
     *         description="enter the friend id you want to remove",
     *         required=true,
     *      ),
     *      @OA\Response(
     *          response=200,
     *          description="friend removed successfully",
     *          @OA\JsonContent()
     *       ),
     * )
     */
    public function removeFriend($id): \Illuminate\Http\Response
    {
        $user = auth()->user();
        $friend = $this->user->find($id);

        if (!$this->friend->checkByTwoConditions("user_id", $user->id, "friend_id", $friend->id)->exists()) {
            return self::failure("you don't have a friendship with him idiot", 422);
        }

        $this->friend->findFriendAndDelete($user->id, $friend->id);

        return self::success("deleted from friends successfully", 200);
    }

    /**
     *  @OA\Get(
     *      path="/api/friend/suggested",
     *      operationId="suggested",
     *      tags={"Friends"},
     *      summary="get all suggested friends",
     *      security={{"JWT":{}}},
     *      @OA\Response(
     *          response=200,
     *          description="all suggested friends",
     *      ),
     *      @OA\Response(
     *          response="401",
     *          description="unauthorized."
     *      ),
     *  )
     */
    public function suggestedFriends(): \Illuminate\Http\Response
    {
        $user = auth()->user();
        return self::returnData("suggested", SuggestedFriendsResource::collection($this->user->suggestedFriends($user)), "suggested friends", 200);
    }

    /**
     *  @OA\Get(
     *      path="/api/friend/getMy",
     *      operationId="getMyFriends",
     *      tags={"Friends"},
     *      summary="get my friends",
     *      security={{"JWT":{}}},
     *   @OA\Parameter(
     *         name="id",
     *         in="path",
     *         description="enter the person id you want to get mutual friends with",
     *         required=true,
     *      ),
     *      @OA\Response(
     *          response=200,
     *          description="all mutual friends",
     *      ),
     *      @OA\Response(
     *          response="401",
     *          description="unauthorized."
     *      ),
     *  )
     */
    public function getMyFriends(): \Illuminate\Http\Response
    {
        $user = auth()->user();
        return self::returnData("friends", FriendResource::collection($user->friends()->get()), "all friends", 200);
    }

    /**
     *  @OA\Get(
     *      path="/api/friend/getMutual/{id}",
     *      operationId="getMutualFriends",
     *      tags={"Friends"},
     *      summary="get mutule friends",
     *      security={{"JWT":{}}},
     *      @OA\Response(
     *          response=200,
     *          description="my friends",
     *      ),
     *      @OA\Response(
     *          response="401",
     *          description="unauthorized."
     *      ),
     *  )
     */
    public function getMutualFriends($id): \Illuminate\Http\Response
    {
        $mutual = $this->user->mutualFriends($id);
        return self::returnData("mutual_friends", FriendResource::collection($mutual), "all mutual friends", 200);
    }

    public function getUserFriends($id): \Illuminate\Http\Response
    {
        $user = $this->user->find($id);
        return self::returnData("friends", FriendResource::collection($user->friends), "all mutual friends", 200);
    }

    /**
     *  @OA\Get(
     *      path="/api/friend/getSentRequests",
     *      operationId="getSentRequests",
     *      tags={"Friends"},
     *      summary="get my sent requests",
     *      security={{"JWT":{}}},
     *      @OA\Response(
     *          response=200,
     *          description="all requests",
     *      ),
     *      @OA\Response(
     *          response="401",
     *          description="unauthorized."
     *      ),
     *  )
     */
    public function getSentRequests(): \Illuminate\Http\Response
    {
        $user = auth()->user();
        return self::returnData("requests", FriendRequestResource::collection($user->friendRequests()->get()), "all your requests",200);
    }

    /**
     *  @OA\Get(
     *      path="/api/friend/receivedRequests",
     *      operationId="receivedRequests",
     *      tags={"Friends"},
     *      summary="get received requests",
     *      security={{"JWT":{}}},
     *      @OA\Response(
     *          response=200,
     *          description="all received requests",
     *      ),
     *      @OA\Response(
     *          response="401",
     *          description="unauthorized."
     *      ),
     *  )
     */
    public function getReceivedRequests(): \Illuminate\Http\Response
    {
        $user = auth()->user();
        return self::returnData("requests", ReceivedRequestResource::collection($user->friendRequestReceivers()->get()), "all your requests",200);
    }
}
