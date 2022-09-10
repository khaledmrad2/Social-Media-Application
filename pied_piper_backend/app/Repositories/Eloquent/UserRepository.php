<?php

namespace App\Repositories\Eloquent;

use App\Models\User;
use App\QueryFilters\User\Search;
use App\Repositories\Contracts\IUser;
use Cloudinary\Api\Search\SearchApi;
use Illuminate\Pipeline\Pipeline;

class UserRepository extends BaseRepository implements IUser
{
    public function model(): string
    {
        return User::class;
    }

    public function forceFillPassword($email, $data) {
        $record = $this->findWhereFirst('email', $email);
        return $record->forceFill($data)->save();
    }

    public function findAndVerify($email) {
        $record = $this->findWhereFirst('email', $email);
        return $record->markEmailAsVerified();
    }

    public function searchUsers()
    {
        return app(Pipeline::class)
            ->send(User::query())
            ->through([
                Search::class,
            ])
            ->thenReturn()
            ->get();
    }

    public function suggestedFriends($user): array
    {
        $friends = $user->friends()->get();
        $my_friends = array();
        $suggested = array();
        $new_suggested = array();

        foreach ($friends as $friend) {
            array_push($my_friends, $friend->friend_id);
            $u_f = $this->model->find($friend->friend_id);
            foreach ($u_f ->friends()->get() as $u_friend) {
                if ($u_friend->friend_id != $user->id) {
                    array_push($suggested, $u_friend->friend_id);
                }
            }
        }
        $suggested = (object)array_diff(array_unique($suggested), $my_friends);
        foreach ($suggested as $s) {
            array_push($new_suggested, $this->model->find($s));
        }
        return $new_suggested;
    }

    public function mutualFriends($friendId): array
    {
        $mutual = array();
        $user = auth()->user();
        $user2 = $this->find($friendId);
        $user_friends = $user->friends()->get();
        $user1_friends = $user2->friends()->get();

        foreach ($user_friends as $u_f) {
            foreach ($user1_friends as $u1_f) {
                if ($u_f->friend_id == $u1_f->friend_id && $u_f->friend_id != $u1_f->user_id) {
                    array_push($mutual, (object)["friend_id" => $u_f->friend_id]);
                }
            }
        }
        return $mutual;
    }

    public function allPostImages($id): array
    {
        $user = $this->find($id);
        $search = new SearchApi();
        $folder = $user->id;
        $subFolder = '/'.'posts';
        $folder = $folder.$subFolder;
        $search = $search ->expression($folder.' AND resource_type:image')->execute();
        $search['resources'] = (object)collect($search['resources']);
        $new_images=[];
        $images=[];
        $i=1;
        foreach($search['resources'] as $image) {
            $images[$i] = $image['url'];
            array_push($new_images, ["picture" => $images[$i]]);
            $i++;
        }
        return $new_images;
    }

    public function syncingManyToManyRelationGU($user_id, $group_id)
    {
        $user = $this->model->find($user_id);
        $user->groups()->syncWithoutDetaching($group_id);
    }

    public function detachingManyToManyRelationGU($group_id)
    {
        auth()->user()->groups()->detach($group_id);
    }

    public function syncManyToManyRelationCU($user_id, $chat_id){
        $user = $this->model->find($user_id);
        $user->chats()->syncWithoutDetaching($chat_id);
    }

    public function getTokensAsArray($user_id): array
    {
        $user = $this->find($user_id);
        $tokens = $user->fcm_tokens()->get(['fcm_token']);
        $array = array();

        foreach ($tokens as $token)
            array_push($array ,$token->fcm_token );
        return $array;
    }
}
