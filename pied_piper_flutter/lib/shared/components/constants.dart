import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:pied_piper/shared/network/local/cache_helper.dart';

import '../../models/post_model.dart';
import '../../models/story_model.dart';

String LogoImage = 'assets/images/pied-piper.png';
String NewImage = 'assets/images/1.svg';
bool pressstart = false;

///Token
String token = '';
//192.168.1.111
///URL for The Linking (emulator or phisycal Mob)
String MainURL = 'http://192.168.1.111:8000/api/';
//192.168.43.196r
///Login Api
String LoginURL = "login/user";

///signUP Api
String SignupURL = "signup/flutter";

///Verify Api
String VerifyURL = "check/send";

///Resend Code for Verify Api
String ResendURL = "resend/flutter";

///To Update Password Api (Send Code And New Password )
String ResetPasswordURL = "check/reset";

///To Send Code To The email and  Make Reset Password
String SendEmailtoResetPasswordURL = "code/reset";

///To Create Normal post
String CreateNormalPostURL = "post/create/normal";

///To Create Job post
String CreateJobPostURL = "post/create/job";

///To Get All posts
String GetAllpostURL = "post/friendsPosts";

///To ADD Or Remove Reaction
String ReactionURL = "reaction/toggle/post/";

///To SavePost
String SavePostURL = "post/savePost/";

///To Delete Post From SavedPost
String DeleteSavePostURL = "post/DeleteSavedPost/";

///Delete Post
String DeletePostURL = "post/delete/";

///Delete Shared Post
String DeletePostSharedURL = "post/deleteSharedPost/";

String ErrorMessage = "Something Error,Please Then Try again !";

///This We Send  To backend in the header
Map<String, String> SendHeaders = {"Accept": "application/json"};

Map<String, String> TokenHeaders = {
  "Authorization": "Bearer ${CacheHelper.GetData(key: 'token')}",
};

List<postmodel> posts = [];
List<storymodel> stories = [];

///add friend url
String GetReactionsURL = "allPostReactions/";
String GetComment = "comment/getAll/";
String AddFriend = 'friend/add/';
String UpdateGroupCoverURL = "group/updateCover/";
String MemebersURL = "group/users/";
String SendInviteURL = "group/sendIR/";
String ReceivedRequests = "friend/receivedRequests";
String AcceptJoinRequestsURL = "group/acceptRequest/";
String AcceptFriend = "friend/accept/";
String GetGroup = "group/get/";
String CancelFriend = 'friend/cancel/';
String GetSvaedPostsURL = "post/mySavedPosts";
String RefuseFriend = 'friend/refuse/';
String GetProfile = "profile/";
String UpdatePersonalURL = "updateJobTitles";
String RemoveFriend = 'friend/remove/';
String AcceptRequest = 'friend/accept/';
String AllGroupsURL = 'group/all';
String GroupInviteURL = "group/getFriendsToInvite/";
String InvitationRequestURL = "group/groupRequests/";
String SuggestFriendUrl = 'friend/suggested';
String GetNotificationURL = 'getAllNotification';
String ReactionCommentURL = "reaction/toggle/comment/";

///header for get request

String ChangeGroupPrivacyURL = "group/updatePrivacy/";
String AcceptInvitationURL = "group/acceptInvite/";
String MyInvitationsURL = "group/getSentToMeInvitations";
String MyGroupsURL = "group/myGroups";
String GetGroupURL = "group/get/";
String DeleteGroupURL = "group/delete/";
String DeleteCommentURL = "comment/delete/";
String LeaveGroupURL = "group/leaveGroup/";
String DeleteCoverGroupURL = "group/deleteCover/";
String CancelRequestInviteURL = "group/cancelRequest/";
String JoinRequestURL = "group/sendIR/";

/// serach history url
String SearchHistoryUrl = "search/all";

///search url
String SearchUrl = 'users';

String getMutualfriendsURL = "friend/getMutual/";

String sharepostURL = "post/sharePost/";

String Log_outURL = "logout";

String UpdateProfilePicURL = "updatePicture";
String UpdateProfileCovURL = "updateCover";
String CreatePicturePostURL = 'post/create/profilePicture';
String CreateCoverPostURL = 'post/create/coverPicture';

String DeleteAccountURL = "deleteAccount";

String ReportPostURL = "complaint/create/post/";

String GetAllStoriesURL = "story/getAllStories";

String CraeteStoryURL = "story/create";

String DeleteStoryURL="story/delete/";
showLoaderDialog(context) {
  AlertDialog alert = AlertDialog(
    content: new Row(
      children: [
        CircularProgressIndicator(),
        Container(margin: EdgeInsets.only(left: 7), child: Text("Loading...")),
      ],
    ),
  );
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
