<?php

use App\Http\Controllers\Admin\ACommentsController;
use App\Http\Controllers\Admin\AComplaintController;
use App\Http\Controllers\Admin\AdminController;
use App\Http\Controllers\Admin\AGroupController;
use App\Http\Controllers\Admin\ANotification;
use App\Http\Controllers\Admin\APostsController;
use App\Http\Controllers\Admin\AStoryController;
use App\Http\Controllers\Admin\AUserController;
use App\Http\Controllers\Admin\Complaint_ReplyController;
use App\Http\Controllers\Admin\WarningController;
use App\Http\Controllers\Auth\CodeCheckerController;
use App\Http\Controllers\Auth\LoginController;
use App\Http\Controllers\Auth\LogoutController;
use App\Http\Controllers\Auth\RegisterController;
use App\Http\Controllers\Auth\SendCodeController;
use App\Http\Controllers\Auth\VerificationController;
use App\Http\Controllers\Chats\ChatController;
use App\Http\Controllers\Chats\MessageController;
use App\Http\Controllers\Complaints\ComplaintsController;
use App\Http\Controllers\Friends\FriendsController;
use App\Http\Controllers\Groups\GroupsController;
use App\Http\Controllers\Notification\NotificationsController;
use App\Http\Controllers\Post\CommentsController;
use App\Http\Controllers\Post\PostController;
use App\Http\Controllers\Post\ReactionsController;
use App\Http\Controllers\Post\SavedPostsController;
use App\Http\Controllers\Post\SharedPostsController;
use App\Http\Controllers\search\SearchUsersController;
use App\Http\Controllers\Story\StoriesController;
use App\Http\Controllers\user\FCMTokenController;
use App\Http\Controllers\user\UserProfileController;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;

Route::post('/signup/{from}', [RegisterController::class, 'register']);
Route::post('/login/{role}', [LoginController::class, 'login']);
Route::post('/code/{type}', [SendCodeController::class, 'sendCode']);
Route::post('/check/{type}', [CodeCheckerController::class, 'check']);
Route::post('/verify/{user}', [VerificationController::class, 'verify'])->name('verification.verify');
Route::post('/resend/{from}', [VerificationController::class, 'resend']);

// admin route group
Route::group(['middleware' => ['auth.guard:admin', 'protected']], function() {
    ////////////////////////////////// users ////////////////////////////
    Route::get('/allUsers',[AUserController::class,'getAllUsers']);
    Route::get('/getFriendsRequest/{UserId}',[AUserController::class,'getFriendsRequest']);
    Route::get('/getUserFriends/{UserId}',[AUserController::class,'getUserFriends']);
    Route::delete('/deleteUser/{UserId}',[AUserController::class,'deleteUser']);

    /////////////////////////////// posts ///////////////////////////////
    Route::get('/allPosts',[APostsController::class,'getAllPosts']);
    Route::get('/allUserPosts/{UserId}',[APostsController::class,'allUserPosts']);
    Route::delete('/DeleteUserPost/{PostId}',[APostsController::class,'deleteUserPost']);
    Route::get('/postComments/{id}',[APostsController::class, 'getPostComments']);
    Route::get('/postReactions/{id}',[APostsController::class, 'getPostReactions']);

    ///////////////////////////////// comments ///////////////////////////
    Route::get('/allComments',[ACommentsController::class, 'getAllComments']);
    Route::delete('/deleteComment/{id}',[ACommentsController::class,'delete']);

    ////////////////////////////// stories //////////////////////////////
    Route::get('/allStories',[AStoryController::class,'getAllStories']);
    Route::get('/allUserStories/{UserId}',[AStoryController::class,'allUserStories']);
    Route::delete('/DeleteUserStory/{PostId}',[AStoryController::class,'deleteUserStory']);

    ////////////////////////////// groups ////////////////////////////////
    Route::get('/allGroups',[AGroupController::class,'getAllGroups']);
    Route::get('/getGroupMembers/{GroupId}',[AGroupController::class,'getGroupMembers']);
    Route::get('/getGroupPosts/{GroupId}',[AGroupController::class,'getGroupPosts']);
    Route::delete('/deleteGroupPost/{PostId}',[AGroupController::class,'deleteGroupPost']);
    Route::delete('/deleteGroup/{GroupId}',[AGroupController::class,'deleteGroup']);

    ////////////////////////////// Notifications ////////////////////////////////
    Route::get('/adminNotifications',[ANotification::class,'getAdminNotifications']);

    ////////////////////////////// complaints ////////////////////////////////
    Route::post('/complaintReply/{complaintId}',[Complaint_ReplyController::class,'create']);
    Route::get('/allComplaint',[AComplaintController::class,'allComplaints']);
    Route::get('/allComplaintReplay/{complaintId}',[Complaint_ReplyController::class,'complaintReplay']);

    ////////////////////////////// warnings ////////////////////////////////
    Route::post('warning/create/{user_id}',[WarningController::class,'create']);
    Route::get('warning/getAll',[WarningController::class,'allWarnings']);

    ////////////////////////////// admins ////////////////////////////////
    Route::get('/admin/getAll',[AdminController::class,'allAdmins']);
    Route::get('/countOfAll',[AdminController::class,'countOfAll']);
    Route::post('/logout', [LogoutController::class, 'logout']);

});

/// user route group
Route::group(['middleware' => ['auth.guard:user', 'protected']], function() {
    ///////////////////////////////////// friends ////////////////////////////////////////
    Route::post('/friend/add/{id}', [FriendsController::class, 'addFriend']);
    Route::post('/friend/accept/{id}', [FriendsController::class, 'acceptFriendRequest']);
    Route::post('/friend/cancel/{id}', [FriendsController::class, 'cancelFriendRequest']);
    Route::post('/friend/refuse/{id}', [FriendsController::class, 'refuseFriendRequest']);
    Route::post('/friend/remove/{id}', [FriendsController::class, 'removeFriend']);
    Route::get('/friend/getMy', [FriendsController::class, 'getMyFriends']);
    Route::get('/friend/getMutual/{id}', [FriendsController::class, 'getMutualFriends']);
    Route::get('/friend/getSentRequests', [FriendsController::class, 'getSentRequests']);
    Route::get('/friend/receivedRequests', [FriendsController::class, 'getReceivedRequests']);
    Route::get('/friend/suggested', [FriendsController::class, 'suggestedFriends']);
    Route::get('/friend/friends/{id}', [FriendsController::class, 'getUserFriends']);

    ///////////////////////////////////// search /////////////////////////////////////
    Route::get('/users', [SearchUsersController::class, 'search']);
    Route::get('/search/all', [SearchUsersController::class, 'getSearchHistory']);
    Route::post('/search/add/{id}', [SearchUsersController::class, 'addToHistory']);
    Route::post('/search/delete/{id}', [SearchUsersController::class, 'deleteFromHistory']);

    //////////////////////////////////// profile ////////////////////////////////////
    Route::get('/profile/{id}', [UserProfileController::class, 'getMyProfile']);
    Route::post('/updatePicture', [UserProfileController::class, 'updatePicture']);
    Route::post('/updateCover', [UserProfileController::class, 'updateCover']);
    Route::post('/updateJobTitles', [UserProfileController::class, 'updateJobTitles']);
    Route::get('/userPictures', [UserProfileController::class, 'allUserPictures']);
    Route::delete('/deletePicture', [UserProfileController::class, 'deletePicture']);
    Route::delete('/deleteCover', [UserProfileController::class, 'deleteCover']);
    Route::get('/allPostsImages/{id}', [UserProfileController::class, 'allPostPictures']);
    Route::post('/logout', [LogoutController::class, 'logout']);
    Route::post('/deleteAccount', [UserProfileController::class, 'deleteAccount']);

    //////////////////////////////////// post ////////////////////////////////////
    Route::post('/post/create/{type}', [PostController::class , 'create']);
    Route::post('/post/update/{post_id}', [PostController::class , 'update']);
    Route::delete('/post/delete/{post_id}', [PostController::class , 'delete']);
    Route::get('/post/myPosts', [PostController::class , 'myPosts']);
    Route::get('/post/friendsPosts', [PostController::class , 'friendsPosts']);
    Route::post('/post/sharePost/{post_id}', [SharedPostsController::class , 'create']);
    Route::delete('/post/deleteSharedPost/{SharedPost_id}', [SharedPostsController::class , 'delete']);
    Route::post('/post/savePost/{Post_id}', [SavedPostsController::class , 'create']);
    Route::get('/post/mySavedPosts', [SavedPostsController::class , 'getMySavedPost']);
    Route::delete('/post/DeleteSavedPost/{SavedPost_id}', [SavedPostsController::class , 'delete']);
    Route::get('/post/getPost/{id}',[PostController::class,'getPost']);

    //////////////////////////////////// comments ////////////////////////////////////
    Route::post('/comment/create/{post_id}',[CommentsController::class , 'create']);
    Route::post('/comment/update/{comment_id}',[CommentsController::class , 'update']);
    Route::delete('/comment/delete/{comment_id}',[CommentsController::class , 'delete']);
    Route::get('comment/getAll/{post_id}',[CommentsController::class , 'allPostComments']);

    //////////////////////////////////// Reactions ////////////////////////////////////
    Route::post('/reaction/toggle/{type}/{id}',[ReactionsController::class , 'toggle']);
    Route::get('/allPostReactions/{id}',[ReactionsController::class,'allPostReactions']);

    //////////////////////////////////// stories ////////////////////////////////////
    Route::post('/story/create',[StoriesController::class , 'create']);
    Route::get('/story/getAllStories',[StoriesController::class , 'getStories']);
    Route::delete('/story/delete/{story_id}',[StoriesController::class , 'delete']);
    Route::get('/story/storiesArchive',[StoriesController::class , 'storiesArchive']);

    //////////////////////////////// notifications ////////////////////////////////////
    Route::get('/getAllNotification',[NotificationsController::class , 'getAllNotification']);
    Route::post('/notification/isSeen/{notification_id}',[NotificationsController::class,'isSeen']);
    Route::get('/notification/unreadCount',[NotificationsController::class,'unreadCount']);

    /////////////////////////////////// groups //////////////////////////////////////
    Route::get('/group/all',[GroupsController::class , 'allGroups']);
    Route::get('/group/get/{id}',[GroupsController::class , 'getGroup']);
    Route::get('/group/myGroups',[GroupsController::class , 'myGroups']);
    Route::get('/group/sentInvitations',[GroupsController::class , 'sentInvitations']);
    Route::get('/group/sentRequests',[GroupsController::class , 'sentRequests']);
    Route::get('/group/getSentToMeInvitations',[GroupsController::class , 'getInvitedToGroups']);
    Route::get('/group/getInvolvedInGroups',[GroupsController::class , 'getGroupsInvolvedIn']);
    Route::get('/group/groupRequests/{id}',[GroupsController::class , 'groupRequests']);
    Route::get('/group/getFriendsToInvite/{id}',[GroupsController::class , 'getFriendsToInvite']);
    Route::get('/group/users/{id}',[GroupsController::class , 'groupUsers']);
    Route::post('/group/sendIR/{user_id}/{group_id}',[GroupsController::class , 'sendIR']);
    Route::post('/group/acceptInvite/{group_id}',[GroupsController::class , 'acceptInvite']);
    Route::post('/group/acceptRequest/{user_id}/{group_id}',[GroupsController::class , 'acceptRequest']);
    Route::post('/group/create',[GroupsController::class , 'create']);
    Route::delete('/group/cancelRequest/{id}',[GroupsController::class , 'cancelRequest']);
    Route::delete('/group/removeRequest/{user_id}/{group_id}',[GroupsController::class , 'removeRequest']);
    Route::delete('/group/delete/{id}',[GroupsController::class , 'delete']);
    Route::delete('/group/leaveGroup/{id}',[GroupsController::class , 'leaveGroup']);
    Route::post('/group/updatePrivacy/{id}',[GroupsController::class , 'updatePrivacy']);
    Route::get('/group/posts/{id}',[GroupsController::class , 'getGroupPosts']);
    Route::get('/group/mixedPosts',[GroupsController::class , 'getMixedGroupPosts']);
    Route::post('/group/updateCover/{id}',[GroupsController::class , 'updateCover']);
    Route::delete('/group/deleteCover/{id}',[GroupsController::class , 'deleteCover']);

    /////////////////////////////////////////// complaints //////////////////////////////
    Route::post('/complaint/create/{type}/{id}',[ComplaintsController::class , 'create']);

    /////////////////////////////////////////// FCM Token //////////////////////////////
    Route::post('/FcmToken',[FCMTokenController::class , 'sendToken']);

    /////////////////////////////////////////// chat //////////////////////////////
    Route::post('/chat/sendMessage/{user_id}',[MessageController::class , 'create']);
    Route::get('/chat/getMessages/{chat_id}',[MessageController::class , 'getMessages']);
    Route::get('/chat/unreadMessages/{chat_id}',[MessageController::class , 'unreadMessages']);
    Route::delete('/chat/deleteMessage/{message_id}',[MessageController::class,'deleteMessage']);
    Route::get('/chat/allChats',[ChatController::class,'allChats']);
});



