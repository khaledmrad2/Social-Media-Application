<?php

namespace App\Providers;

use App\Http\Controllers\Chats\MessageController;
use App\Models\Message;
use App\Repositories\Contracts\IAdmin;
use App\Repositories\Contracts\IChat;
use App\Repositories\Contracts\ICode;
use App\Repositories\Contracts\IComment;
use App\Repositories\Contracts\IComplaint;
use App\Repositories\Contracts\IComplaint_Reply;
use App\Repositories\Contracts\IFcm_Token;
use App\Repositories\Contracts\IFriend;
use App\Repositories\Contracts\IFriendRequest;
use App\Repositories\Contracts\IFriendRequestReceiver;
use App\Repositories\Contracts\IGroup;
use App\Repositories\Contracts\IGroupRequest;
use App\Repositories\Contracts\IGroupRequestReceiver;
use App\Repositories\Contracts\IMessage;
use App\Repositories\Contracts\INotification;
use App\Repositories\Contracts\IPost;
use App\Repositories\Contracts\IPost_Image;
use App\Repositories\Contracts\IReaction;
use App\Repositories\Contracts\ISaved_Post;
use App\Repositories\Contracts\ISearchHistory;
use App\Repositories\Contracts\ISharedPost;
use App\Repositories\Contracts\IStory;
use App\Repositories\Contracts\IUser;
use App\Repositories\Contracts\IWarning;
use App\Repositories\Eloquent\AdminRepository;
use App\Repositories\Eloquent\ChatRepository;
use App\Repositories\Eloquent\CodeRepository;
use App\Repositories\Eloquent\CommentRepository;
use App\Repositories\Eloquent\Complaint_ReplyRepository;
use App\Repositories\Eloquent\ComplaintsRepository;
use App\Repositories\Eloquent\Fcm_TokenRepository;
use App\Repositories\Eloquent\FriendRepository;
use App\Repositories\Eloquent\FriendRequestReceiverRepository;
use App\Repositories\Eloquent\FriendRequestRepository;
use App\Repositories\Eloquent\GroupRepository;
use App\Repositories\Eloquent\GroupRequestReceiverRepository;
use App\Repositories\Eloquent\GroupRequestRepository;
use App\Repositories\Eloquent\MessageRepository;
use App\Repositories\Eloquent\NotificationRepository;
use App\Repositories\Eloquent\Post_ImageRepository;
use App\Repositories\Eloquent\PostRepository;
use App\Repositories\Eloquent\ReactionRepository;
use App\Repositories\Eloquent\Saved_PostRepository;
use App\Repositories\Eloquent\SearchHistoryRepository;
use App\Repositories\Eloquent\SharedPostRepository;
use App\Repositories\Eloquent\StoryRepository;
use App\Repositories\Eloquent\UserRepository;
use App\Repositories\Eloquent\WarningRepository;
use Illuminate\Support\ServiceProvider;

class RepositoryServiceProvider extends ServiceProvider
{
    public function register()
    {
        $this->app->bind(IUser::class, UserRepository::class);
        $this->app->bind(ICode::class, CodeRepository::class);
        $this->app->bind(IFriendRequest::class, FriendRequestRepository::class);
        $this->app->bind(IFriendRequestReceiver::class, FriendRequestReceiverRepository::class);
        $this->app->bind(IFriend::class, FriendRepository::class);
        $this->app->bind(ISearchHistory::class, SearchHistoryRepository::class);
        $this->app->bind(IPost::class, PostRepository::class);
        $this->app->bind(IPost_Image::class, Post_ImageRepository::class);
        $this->app->bind(IComment::class , CommentRepository::class);
        $this->app->bind(IReaction::class , ReactionRepository::class);
        $this->app->bind(ISharedPost::class , SharedPostRepository::class);
        $this->app->bind(ISaved_Post::class , Saved_PostRepository::class);
        $this->app->bind(IStory::class , StoryRepository::class);
        $this->app->bind(INotification::class , NotificationRepository::class);
        $this->app->bind(IGroup::class , GroupRepository::class);
        $this->app->bind(IGroupRequest::class , GroupRequestRepository::class);
        $this->app->bind(IGroupRequestReceiver::class , GroupRequestReceiverRepository::class);
        $this->app->bind(IComplaint::class , ComplaintsRepository::class);
        $this->app->bind(IComplaint_Reply::class , Complaint_ReplyRepository::class);
        $this->app->bind(IAdmin::class , AdminRepository::class);
        $this->app->bind(IWarning::class , WarningRepository::class);
        $this->app->bind(IChat::class , ChatRepository::class);
        $this->app->bind(IMessage::class , MessageRepository::class);
        $this->app->bind(IFcm_Token::class , Fcm_TokenRepository::class);
    }

    public function boot()
    {

    }
}
