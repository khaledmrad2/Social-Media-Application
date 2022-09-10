<?php

namespace App\Traits;

use App\Models\User;
use App\Notifications\SendPushNotification;
use App\Repositories\Eloquent\CommentRepository;
use App\Repositories\Eloquent\Complaint_ReplyRepository;
use App\Repositories\Eloquent\ComplaintsRepository;
use App\Repositories\Eloquent\GroupRepository;
use App\Repositories\Eloquent\GroupRequestReceiverRepository;
use App\Repositories\Eloquent\GroupRequestRepository;
use App\Repositories\Eloquent\NotificationRepository;
use App\Repositories\Eloquent\PostRepository;
use App\Repositories\Eloquent\ReactionRepository;
use App\Repositories\Eloquent\UserRepository;
use App\Repositories\Eloquent\WarningRepository;
use Illuminate\Support\Facades\Notification;
use Kutia\Larafirebase\Services\Larafirebase;


trait Notifications
{
    public static function PostNotification($notifiable_id, $sent_as_type, $sent_as_id)
    {
        $notifications = new NotificationRepository();
        $comment = new CommentRepository();
        $user = new UserRepository();
        $post = new PostRepository();
        $reaction = new ReactionRepository();
        $data = array();


        if ($sent_as_type == 'comment') {
            $comment = $comment->find($sent_as_id);
            $user1 = $user->find($comment->user_id);
            $post = $post->find($comment->post_id);

            if($user1->id == $notifiable_id)
                return;
            $data['notifiable_id'] = $notifiable_id;
            $data['notifiable_type'] = "App\Models\User";
            $data['sent_as_id'] = $post->id;
            $data['sent_as_type'] = "App\Models\Post";
            $data['content'] = $user1->name . " added a comment to your post";
            $data['causer_id'] = $user1->id;
            $notifications->create($data);

            $user2 = $user->find($notifiable_id);
            Notification::send($user2, new SendPushNotification('new comment added', $user1->name . " added a comment to your post", $user->getTokensAsArray($user2->id)));
        }
        else if ($sent_as_type == 'post') {
            $post = $post->find($sent_as_id);
            $user1 = $user->find($post->user_id);

            if($user1->id == $notifiable_id)
                return;

            $data['notifiable_id'] = $notifiable_id;
            $data['notifiable_type'] = "App\Models\User";
            $data['sent_as_id'] = $sent_as_id;
            $data['sent_as_type'] = "App\Models\Post";
            $data['content'] = "your friend: " . $user1->name . " added a new post";
            $data['causer_id'] = $user1->id;
            $notifications->create($data);

            $user2 = $user->find($notifiable_id);
            Notification::send($user2, new SendPushNotification('new post added', "your friend: " . $user1->name . " added a new post",$user->getTokensAsArray($user2->id)));
        }
        else if ($sent_as_type == 'post_reaction') {
            $reaction = $reaction->find($sent_as_id);
            $user1 = $user->find($reaction->user_id);
            $post = $post->find($reaction->reactionable_id);

            if($user1->id == $notifiable_id)
                return;

            $data['notifiable_id'] = $notifiable_id;
            $data['notifiable_type'] = "App\Models\User";
            $data['sent_as_id'] = $post->id;
            $data['sent_as_type'] = "App\Models\Post";
            $data['content'] = $user1->name . " added " . $reaction->type . " to your post";
            $data['causer_id'] = $user1->id;
            $notifications->create($data);

            $user2 = $user->find($notifiable_id);
            Notification::send($user2, new SendPushNotification("new reaction added", $user1->name . " added " . $reaction->type . " to your post",$user->getTokensAsArray($user2->id)));

        }
        else if ($sent_as_type == 'comment_reaction') {
            $reaction = $reaction->find($sent_as_id);
            $user1 = $user->find($reaction->user_id);
            $comment = $comment->find($reaction->reactionable_id);
            $post = $post->find($comment->post_id);

            if($user1->id == $notifiable_id)
                return;

            $data['notifiable_id'] = $notifiable_id;
            $data['notifiable_type'] = "App\Models\User";
            $data['sent_as_id'] = $post->id;
            $data['sent_as_type'] = "App\Models\Post";
            $data['content'] = $user1->name . " added " . $reaction->type . " to your comment";
            $data['causer_id'] = $user1->id;
            $notifications->create($data);
            $user2 = $user->find($notifiable_id);
            Notification::send($user2, new SendPushNotification("new reaction added", $user1->name . " added " . $reaction->type . " to your comment",  $user->getTokensAsArray($user2->id)));

        }
    }


    public static function UserNotification($notifiable_id, $sent_as_type, $sent_as_id)
    {
        $notifications = new NotificationRepository();
        $user = new UserRepository();
        $data = array();
        $group = new GroupRepository();
        $groupRequest = new GroupRequestRepository();

        if ($sent_as_type == 'friend_request') {
            $requester = $user->find($sent_as_id);
            if($requester->id == $notifiable_id)
                return;
            $data['notifiable_id'] = $notifiable_id;
            $data['notifiable_type'] = "App\Models\User";
            $data['sent_as_id'] = $sent_as_id;
            $data['sent_as_type'] = "App\Models\User";
            $data['content'] = $requester->name . " sent to you a friend request";
            $data['causer_id'] = $requester->id;
            $notifications->create($data);

            $user2 = $user->find($notifiable_id);
            Notification::send($user2, new SendPushNotification('a new friend request', $requester->name . " sent to you a friend request",  $user->getTokensAsArray($user2->id)));

        }
        else if ($sent_as_type == 'friend_accept') {
            $receiver = $user->find($sent_as_id);
            if( $receiver->id == $notifiable_id)
                return;
            $data['notifiable_id'] = $notifiable_id;
            $data['notifiable_type'] = "App\Models\User";
            $data['sent_as_id'] = $sent_as_id;
            $data['sent_as_type'] = "App\Models\User";
            $data['content'] = $receiver->name . " accept your friend request";
            $data['causer_id'] = $receiver->id;
            $notifications->create($data);

            $user2 = $user->find($notifiable_id);
            Notification::send($user2, new SendPushNotification('a new friend!', $receiver->name . " accept your friend request",  $user->getTokensAsArray($user2->id)));
        }
        else if ($sent_as_type == 'sendRequest') {
            //get group request information
            $groupRequest = $groupRequest->find($sent_as_id);
            //get group admin information
            $groupAdmin = $user->find($notifiable_id);
            //get group information
            $group = $group->find($groupRequest->group_id);
            //get requester information
            $requester = $user->find($groupRequest->user_id);

            if( $requester->id == $groupAdmin->id)
                return;
            $data['notifiable_id'] = $groupAdmin->id;
            $data['notifiable_type'] = "App\Models\User";
            $data['sent_as_id'] = $groupRequest->user_id;
            $data['sent_as_type'] = "App\Models\User";
            $data['content'] = $requester->name . " has requested to join your group: " . $group->title;
            $data['causer_id'] = $requester->id;
            $notifications->create($data);

            $user2 = $user->find($groupAdmin->id);
            Notification::send($user2, new SendPushNotification("a new group request!", $requester->name . " has requested to join your group: " . $group->title,  $user->getTokensAsArray($user2->id)));
        }
        else if ($sent_as_type == 'acceptInvite') {
            $group = $group->find($sent_as_id);
            $groupAdmin = $user->find($group->user_id);
            $invitedUser = $user->find($notifiable_id);
            if( $invitedUser->id == $groupAdmin->id)
                return;
            $data['notifiable_id'] = $groupAdmin->id;
            $data['notifiable_type'] = "App\Models\User";
            $data['sent_as_id'] = $invitedUser->id;
            $data['sent_as_type'] = "App\Models\User";
            $data['content'] = $invitedUser->name . " has joined to your group: " . $group->title;
            $data['causer_id'] = $invitedUser->id;
            $notifications->create($data);

            $user2 = $user->find($groupAdmin->id);
            Notification::send($user2, new SendPushNotification("a new group member!", $invitedUser->name . " has joined to your group: " . $group->title,  $user->getTokensAsArray($user2->id)));
        }
    }


    public static function GroupNotification($notifiable_id, $sent_as_type, $sent_as_id)
    {
        $notifications = new NotificationRepository();
        $user = new UserRepository();
        $data = array();
        $group = new GroupRepository();
        $groupRequestReceivers = new GroupRequestReceiverRepository();


        if ( $sent_as_type == 'acceptRequest') {
            $group = $group->find($sent_as_id);
            $groupAdmin = $user->find($group->user_id);
            $requester = $user->find($notifiable_id);
            if( $groupAdmin->id == $requester->id)
                return;
            $data['notifiable_id'] = $requester->id;
            $data['notifiable_type'] = "App\Models\User";
            $data['sent_as_id'] = $group->id;
            $data['sent_as_type'] = "App\Models\Group";
            $data['content'] = $groupAdmin->name . " has accepted your request to join his group: " . $group->title;
            $data['causer_id'] = $groupAdmin->id;
            $notifications->create($data);

            $user2 = $user->find($requester->id);
            Notification::send($user2, new SendPushNotification("a new group!", $groupAdmin->name . " has accepted your request to join his group: " . $group->title . $group->title,  $user->getTokensAsArray($user2->id)));
        }
        else if ( $sent_as_type == 'sendInvite') {
            //get group invite information
            $groupRequestReceivers = $groupRequestReceivers->find($sent_as_id);
            //get invited user information
            $invitedUser = $user->find($notifiable_id);
            //get group information
            $group = $group->find($groupRequestReceivers->group_id);
            //get requester information
            $requester = $user->find($groupRequestReceivers->requester_id);
            if( $invitedUser->id == $requester->id)
                return;
            $data['notifiable_id'] = $invitedUser->id;
            $data['notifiable_type'] = "App\Models\User";
            $data['sent_as_id'] = $group->id;
            $data['sent_as_type'] = "App\Models\Group";
            $data['content'] = $requester->name . " has invited you to join " . $group->title . " group";
            $data['causer_id'] = $requester->id;
            $notifications->create($data);

            $user2 = $user->find($invitedUser->id);
            Notification::send($user2, new SendPushNotification("a new group invite!", $requester->name . " has invited you to join " . $group->title . " group",  $user->getTokensAsArray($user2->id)));
        }

    }

    public function ComplaintNotification($notifiable_id, $sent_as_type, $sent_as_id)
    {
        $notifications = new NotificationRepository();
        $comment = new CommentRepository();
        $user = new UserRepository();
        $post = new PostRepository();
        $data = array();
        $complaint_reply = new Complaint_ReplyRepository();
        $complaint = new ComplaintsRepository();
        $warning = new WarningRepository();

        if ($sent_as_type == 'complaint') {
            $user1 = $user->find($notifiable_id);
            $complaint_reply = $complaint_reply->find($sent_as_id);
            $complaint = $complaint->find($complaint_reply->complaint_id);
            $user2 = $user->find($complaint->user_id);
            $data['notifiable_id'] = $user1->id;
            $data['notifiable_type'] = "App\Models\User";
            $data['sent_as_id'] = $complaint->complaintable_type == "App\Models\Comment" ? $post->find($comment->find($complaint->complaintable_id)->post_id)->id : $complaint->complaintable_id;
            $data['sent_as_type'] = $complaint->complaintable_type == "App\Models\Comment" ? "App\Models\Post" : $complaint->complaintable_type;
            $data['content'] = "System has replied your complaint on " . $user2->name . " post: " . $complaint_reply->text;
            $data['causer_id'] = 0;
            $notifications->create($data);

            Notification::send($user1, new SendPushNotification("complaint replay!", "System has replied your complaint on : " . $complaint_reply->text, $user1->fcm_tokens()->get()));

        }
        else if ($sent_as_type == 'warning') {
            $user2 = $user->find($notifiable_id);
            $warning = $warning->find($sent_as_id);
            $data['notifiable_id'] = $user2->id;
            $data['notifiable_type'] = "App\Models\User";
            $data['sent_as_id'] = $user2->id;
            $data['sent_as_type'] = "App\Models\User";
            $data['content'] = "You have received a warning from the system for your behavior, text of the report: " . $warning->text;
            $data['causer_id'] = 0;
            $notifications->create($data);

            Notification::send($user2, new SendPushNotification("WARNING!", "You have received a warning from the system for your behavior, text of the report: " . $warning->text,  $user->getTokensAsArray($user2->id)));
        }

    }

    public static function CreateAdminNotification($notifiable_id, $sent_as_type, $sent_as_id)
    {
        $notifications = new NotificationRepository();
        $comment = new CommentRepository();
        $user = new UserRepository();
        $post = new PostRepository();
        $data = array();
        $group = new GroupRepository();
        $complaint = new ComplaintsRepository();

        if ($sent_as_type == 'user') {
            $complaint = $complaint->find($sent_as_id);
            $complaint_sender = $user->find($complaint->user_id);
            $complaint_receiver = $user->find($complaint->complaintable_id);
            $data['notifiable_id'] = $notifiable_id;
            $data['notifiable_type'] = "App\Models\Admin";
            $data['sent_as_id'] = $complaint_receiver->id;
            $data['sent_as_type'] = "App\Models\User";
            $data['content'] = $complaint_sender->name . " has sent a report on user: " . $complaint_receiver->name;
            $data['causer_id'] = $complaint_sender->id;
            $notifications->create($data);
        }
        else if ($sent_as_type == 'post') {
            $complaint = $complaint->find($sent_as_id);
            $complaint_sender = $user->find($complaint->user_id);
            $complaint_receiver = $post->find($complaint->complaintable_id);
            $data['notifiable_id'] = $notifiable_id;
            $data['notifiable_type'] = "App\Models\Admin";
            $data['sent_as_id'] = $complaint_receiver->id;
            $data['sent_as_type'] = "App\Models\Post";
            $data['content'] = $complaint_sender->name . " has sent a report on  a post, Post ID: " . $complaint_receiver->id;
            $data['causer_id'] = $complaint_sender->id;
            $notifications->create($data);
        }
        else if ($sent_as_type == 'comment') {
            $complaint = $complaint->find($sent_as_id);
            $complaint_sender = $user->find($complaint->user_id);
            $complaint_receiver = $comment->find($complaint->complaintable_id);
            $post = $post->find($complaint_receiver->post_id);
            $data['notifiable_id'] = $notifiable_id;
            $data['notifiable_type'] = "App\Models\Admin";
            $data['sent_as_id'] = $post->id;
            $data['sent_as_type'] = "App\Models\Post";
            $data['content'] = $complaint_sender->name . " has sent a report on a comment: " . $complaint_receiver->id . " that on the post: " . $post->id;
            $data['causer_id'] = $complaint_sender->id;
            $notifications->create($data);
        }
        else if ($sent_as_type == 'group') {
            $complaint = $complaint->find($sent_as_id);
            $complaint_sender = $user->find($complaint->user_id);
            $complaint_receiver = $group->find($complaint->complaintable_id);
            $data['notifiable_id'] = $notifiable_id;
            $data['notifiable_type'] = "App\Models\Admin";
            $data['sent_as_id'] = $complaint_receiver->id;
            $data['sent_as_type'] = "App\Models\Group";
            $data['content'] = $complaint_sender->name . " has sent a report on group: " . $complaint_receiver->title;
            $data['causer_id'] = $complaint_sender->id;
            $notifications->create($data);
        }}
    }


//public static function createNotification($notifiable_type,$notifiable_id,$sent_as_type,$sent_as_id){
//    $notifications = new NotificationRepository();
//    $comment = new CommentRepository();
//    $user = new UserRepository();
//    $post = new PostRepository();
//    $reaction = new ReactionRepository();
//    $data = array();
//    $group = new GroupRepository();
//    $groupRequest = new GroupRequestRepository();
//    $groupRequestReceivers = new GroupRequestReceiverRepository();
//    $complaint_reply = new Complaint_ReplyRepository();
//    $complaint = new ComplaintsRepository();
//    $warning = new WarningRepository();

//    if($notifiable_type == 'user' && $sent_as_type == 'comment'){
//        $comment = $comment->find($sent_as_id);
//        $user1 = $user->find($comment->user_id);
//        $post = $post->find($comment->post_id);
//        $data['notifiable_id'] = $notifiable_id;
//        $data['notifiable_type'] = "App\Models\User";
//        $data['sent_as_id'] = $post->id;
//        $data['sent_as_type'] = "App\Models\Post";
//        $data['content'] =$user1->name." added a comment to your post";
//        $data['causer_id'] = $user1->id;
//        $notifications->create($data);
//
//        $user2 = $user->find($notifiable_id);
//        Notification::send($user2,new SendPushNotification('new comment added',$user1->name." added a comment to your post",$user2->fcm_token));
//    }
//
//    else if($notifiable_type == 'user' && $sent_as_type == 'post'){
//        $post  = $post->find($sent_as_id);
//        $user1 = $user->find($post->user_id);
//        $data['notifiable_id'] = $notifiable_id;
//        $data['notifiable_type'] = "App\Models\User";
//        $data['sent_as_id'] = $sent_as_id;
//        $data['sent_as_type'] = "App\Models\Post";
//        $data['content'] ="your friend: ".$user1->name." added a new post";
//        $data['causer_id'] = $user1->id;
//        $notifications->create($data);
//
//        $user2 = $user->find($notifiable_id);
//        Notification::send($user2,new SendPushNotification('new post added',"your friend: ".$user1->name." added a new post",$user2->fcm_token));
//    }

//    else if($notifiable_type == 'user' && $sent_as_type == 'friend_request'){
//        $requester = $user->find($sent_as_id);
//        $data['notifiable_id'] = $notifiable_id;
//        $data['notifiable_type'] = "App\Models\User";
//        $data['sent_as_id'] = $sent_as_id;
//        $data['sent_as_type'] = "App\Models\User";
//        $data['content'] =$requester->name . " sent to you a friend request";
//        $data['causer_id'] = $requester->id;
//        $notifications->create($data);
//
//        $user2 = $user->find($notifiable_id);
//        Notification::send($user2,new SendPushNotification('a new friend request',$requester->name . " sent to you a friend request",$user2->fcm_token));
//
//    }
//
//    else if($notifiable_type == 'user' && $sent_as_type == 'friend_accept'){
//        $receiver = $user->find($sent_as_id);
//        $data['notifiable_id'] = $notifiable_id;
//        $data['notifiable_type'] = "App\Models\User";
//        $data['sent_as_id'] = $sent_as_id;
//        $data['sent_as_type'] = "App\Models\User";
//        $data['content'] =$receiver->name . " accept your friend request";
//        $data['causer_id'] = $receiver->id;
//        $notifications->create($data);
//
//        $user2 = $user->find($notifiable_id);
//        Notification::send($user2,new SendPushNotification('a new friend!',$receiver->name . " accept your friend request",$user2->fcm_token));
//    }
//
//    else if($notifiable_type == 'user' && $sent_as_type == 'post_reaction'){
//        $reaction = $reaction->find($sent_as_id);
//        $user1 = $user->find($reaction->user_id);
//        $post = $post->find($reaction->reactionable_id);
//        $data['notifiable_id'] = $notifiable_id;
//        $data['notifiable_type'] = "App\Models\User";
//        $data['sent_as_id'] = $post->id;
//        $data['sent_as_type'] = "App\Models\Post";
//        $data['content'] =$user1->name." added ".$reaction->type." to your post";
//        $data['causer_id'] = $user1->id;
//        $notifications->create($data);
//
//        $user2 = $user->find($notifiable_id);
//         Notification::send($user2,new SendPushNotification("new reaction added",$user1->name." added ".$reaction->type." to your post",$user2->fcm_token));
//
//    }
//
//
//    else if($notifiable_type == 'user' && $sent_as_type == 'comment_reaction'){
//        $reaction = $reaction->find($sent_as_id);
//        $user1 = $user->find($reaction->user_id);
//        $comment = $comment->find($reaction->reactionable_id);
//        $post = $post->find($comment->post_id);
//        $data['notifiable_id'] = $notifiable_id;
//        $data['notifiable_type'] = "App\Models\User";
//        $data['sent_as_id'] = $post->id;
//        $data['sent_as_type'] = "App\Models\Post";
//        $data['content'] = $user1->name." added ".$reaction->type." to your comment";
//        $data['causer_id'] = $user1->id;
//        $notifications->create($data);
//
//        $user2 = $user->find($notifiable_id);
//        Notification::send($user2,new SendPushNotification("new reaction added",$user1->name." added ".$reaction->type." to your comment",$user2->fcm_token));
//
//    }

//    else if($notifiable_type == 'user' && $sent_as_type == 'sendRequest' ){
//        //get group request information
//        $groupRequest = $groupRequest->find($sent_as_id);
//        //get group admin information
//        $groupAdmin = $user->find($notifiable_id);
//        //get group information
//        $group = $group->find($groupRequest->group_id);
//        //get requester information
//        $requester = $user->find($groupRequest->user_id);
//        $data['notifiable_id'] = $groupAdmin->id;
//        $data['notifiable_type'] = "App\Models\User";
//        $data['sent_as_id'] = $groupRequest->user_id;
//        $data['sent_as_type'] = "App\Models\User";
//        $data['content'] =$requester->name . " has requested to join your group: ". $group->title;
//        $data['causer_id'] = $requester->id;
//        $notifications->create($data);
//
//        $user2 = $user->find($groupAdmin->id);
//        Notification::send($user2,new SendPushNotification("a new group request!",$requester->name . " has requested to join your group: ". $group->title,$user2->fcm_token));
//    }

//    else if($notifiable_type == 'user' && $sent_as_type == 'acceptRequest' ){
//        $group = $group->find($sent_as_id);
//        $groupAdmin = $user->find($group->user_id);
//        $requester = $user->find($notifiable_id);
//        $data['notifiable_id'] = $requester->id;
//        $data['notifiable_type'] = "App\Models\User";
//        $data['sent_as_id'] = $group->id;
//        $data['sent_as_type'] = "App\Models\Group";
//        $data['content'] =$groupAdmin->name . " has accepted your request to join his group: ". $group->title;
//        $data['causer_id'] = $groupAdmin->id;
//        $notifications->create($data);
//
//        $user2 = $user->find($requester->id);
//        Notification::send($user2,new SendPushNotification("a new group!",$groupAdmin->name . " has accepted your request to join his group: ". $group->title. $group->title,$user2->fcm_token));
//    }
//
//    else if($notifiable_type == 'user' && $sent_as_type == 'sendInvite' ){
//        //get group invite information
//        $groupRequestReceivers = $groupRequestReceivers->find($sent_as_id);
//        //get invited user information
//        $invitedUser = $user->find($notifiable_id);
//        //get group information
//        $group = $group->find($groupRequestReceivers->group_id);
//        //get requester information
//        $requester = $user->find($groupRequestReceivers->requester_id);
//        $data['notifiable_id'] = $invitedUser->id;
//        $data['notifiable_type'] = "App\Models\User";
//        $data['sent_as_id'] = $group->id;
//        $data['sent_as_type'] = "App\Models\Group";
//        $data['content'] =$requester->name . " has invited you to join ". $group->title." group";
//        $data['causer_id'] = $requester->id;
//        $notifications->create($data);
//
//        $user2 = $user->find($invitedUser->id);
//        Notification::send($user2,new SendPushNotification("a new group invite!",$requester->name . " has invited you to join ". $group->title." group",$user2->fcm_token));
//    }

//    else if($notifiable_type == 'user' && $sent_as_type == 'acceptInvite' ){
//        $group = $group->find($sent_as_id);
//        $groupAdmin = $user->find($group->user_id);
//        $invitedUser = $user->find($notifiable_id);
//        $data['notifiable_id'] = $groupAdmin->id;
//        $data['notifiable_type'] = "App\Models\User";
//        $data['sent_as_id'] = $invitedUser->id;
//        $data['sent_as_type'] = "App\Models\User";
//        $data['content'] =$invitedUser->name . " has joined to your group: ". $group->title;
//        $data['causer_id'] = $invitedUser->id;
//        $notifications->create($data);
//
//        $user2 = $user->find($groupAdmin->id);
//        Notification::send($user2,new SendPushNotification("a new group member!",$invitedUser->name . " has joined to your group: ". $group->title,$user2->fcm_token));
//    }

//    else if($sent_as_type == 'complaint'){
//        $user1 = $user->find($notifiable_id);
//        $complaint_reply = $complaint_reply->find($sent_as_id);
//        $complaint = $complaint->find($complaint_reply->complaint_id);
//        $user2 = $user->find($complaint->user_id);
//        $data['notifiable_id'] = $user1->id;
//        $data['notifiable_type'] = "App\Models\User";
//        $data['sent_as_id'] = $complaint->complaintable_type=="App\Models\Comment"?$post->find($comment->find($complaint->complaintable_id)->post_id)->id:$complaint->complaintable_id;
//        $data['sent_as_type'] =  $complaint->complaintable_type=="App\Models\Comment"?"App\Models\Post": $complaint->complaintable_type;
//        $data['content'] ="System has replied your complaint on ".$user2->name." post: ". $complaint_reply->text;
//        $data['causer_id'] =0;
//        $notifications->create($data);
//
//         Notification::send($user1,new SendPushNotification("complaint replay!","System has replied your complaint on : ". $complaint_reply->text,$user1->fcm_token));
//
//    }
//    else if($sent_as_type == 'warning'){
//        $user = $user->find($notifiable_id);
//        $warning = $warning->find($sent_as_id);
//        $data['notifiable_id'] = $user->id;
//        $data['notifiable_type'] = "App\Models\User";
//        $data['sent_as_id'] =  $user->id;
//        $data['sent_as_type'] =  "App\Models\User";
//        $data['content'] ="You have received a warning from the system for your behavior, text of the report: ". $warning->text;
//        $data['causer_id'] =0;
//        $notifications->create($data);
//
//        Notification::send($user,new SendPushNotification("WARNING!","You have received a warning from the system for your behavior, text of the report: ". $warning->text,$user->fcm_token));
//    }
//}




//public static function CreateAdminNotification($notifiable_type,$notifiable_id,$sent_as_type,$sent_as_id){
//    $notifications = new NotificationRepository();
//    $comment = new CommentRepository();
//    $user = new UserRepository();
//    $post = new PostRepository();
//    $data = array();
//    $group = new GroupRepository();
//    $complaint = new ComplaintsRepository();
//
//    if($sent_as_type == 'user'){
//        $complaint = $complaint->find($sent_as_id);
//        $complaint_sender = $user->find($complaint->user_id);
//        $complaint_receiver = $user->find($complaint->complaintable_id);
//        $data['notifiable_id'] = $notifiable_id;
//        $data['notifiable_type'] = "App\Models\Admin";
//        $data['sent_as_id'] = $complaint_receiver->id;
//        $data['sent_as_type'] = "App\Models\User";
//        $data['content'] =$complaint_sender->name . " has sent a report on user: ". $complaint_receiver->name;
//        $data['causer_id'] = $complaint_sender->id;
//        $notifications->create($data);
//    }
//    else if($sent_as_type == 'post'){
//        $complaint = $complaint->find($sent_as_id);
//        $complaint_sender = $user->find($complaint->user_id);
//        $complaint_receiver = $post->find($complaint->complaintable_id);
//        $data['notifiable_id'] = $notifiable_id;
//        $data['notifiable_type'] = "App\Models\Admin";
//        $data['sent_as_id'] = $complaint_receiver->id;
//        $data['sent_as_type'] = "App\Models\Post";
//        $data['content'] =$complaint_sender->name . " has sent a report on  a post, Post ID: ". $complaint_receiver->id;
//        $data['causer_id'] = $complaint_sender->id;
//        $notifications->create($data);
//    }
//
//    else if($sent_as_type == 'comment'){
//        $complaint = $complaint->find($sent_as_id);
//        $complaint_sender = $user->find($complaint->user_id);
//        $complaint_receiver = $comment->find($complaint->complaintable_id);
//        $post = $post->find($complaint_receiver->post_id);
//        $data['notifiable_id'] = $notifiable_id;
//        $data['notifiable_type'] = "App\Models\Admin";
//        $data['sent_as_id'] = $post->id;
//        $data['sent_as_type'] = "App\Models\Post";
//        $data['content'] =$complaint_sender->name . " has sent a report on a comment: " .$complaint_receiver->id." that on the post: ". $post->id;
//        $data['causer_id'] = $complaint_sender->id;
//        $notifications->create($data);
//    }
//    else if($sent_as_type == 'group'){
//        $complaint = $complaint->find($sent_as_id);
//        $complaint_sender = $user->find($complaint->user_id);
//        $complaint_receiver = $group->find($complaint->complaintable_id);
//        $data['notifiable_id'] = $notifiable_id;
//        $data['notifiable_type'] = "App\Models\Admin";
//        $data['sent_as_id'] = $complaint_receiver->id;
//        $data['sent_as_type'] = "App\Models\Group";
//        $data['content'] =$complaint_sender->name . " has sent a report on group: " .$complaint_receiver->title;
//        $data['causer_id'] = $complaint_sender->id;
//        $notifications->create($data);
//    }
//
//
//
//
//
//
//}
//}
