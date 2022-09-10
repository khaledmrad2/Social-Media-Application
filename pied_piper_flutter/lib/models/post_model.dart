import 'package:pied_piper/models/comment_model.dart';
import 'package:pied_piper/models/image_model.dart';
import 'package:pied_piper/models/reaction_model.dart';
import 'package:pied_piper/shared/network/local/cache_helper.dart';

class postmodel {
  bool is_visitor;
  bool is_saved_post;
  bool is_shared_post;
  int shared_user_id;
  int shared_post_id;
  String shared_user_name;
  String shared_user_picture;
  bool is_the_post_shared;
  int shared_count;
  int admin_id;
  String group_name;
  String group_cover;
  bool is_admin;

  int post_id;
  int user_id;
  String user_name;
  String user_picture;
  String user_cover;
  String user_job_title;
  String user_email;
  String user_location;
  int user_hire;
  int group_id;

  String text;
  String type;
  String background;
  String video;
  String voice_record;
  String created_at;
  List<imagemodel> images = [];
  int commentsCount;
  List<commentmodel> comments = [];
  List<reactionmodel> reactions = [];
  int AllReactionsCount;
  int likeCount;
  int dislikeCount;
  int loveCount;
  int angryCount;
  int sadCount;
  int hahaCount;
  bool isReaction;
  String myReactionType;

  postmodel.fromJson(Map<String, dynamic> json) {
    is_visitor = json['is_visitor'];
    is_saved_post = json['is_saved_post'];
    is_shared_post = json['is_shared_post'];
    shared_user_id = json['shared_user_id'];
    shared_post_id = json['shared_post_id'];
    shared_user_name = json['shared_user_name'];
    shared_user_picture = json['shared_user_picture'];
    is_the_post_shared = json['is_the_post_shared'];
    post_id = json['post_id'];
    user_id = json['user_id'];
    user_name = json['user_name'];
    user_picture = json['user_picture'];
    user_cover = json['user_cover'];
    user_job_title = json['user_job_title'];
    user_email = json['user_email'];
    user_location = json['user_location'];
    user_hire = json['user_hire'];
    group_id = json['group_id'];
    text = json['text'];
    type = json['type'];
    background = json['background'];
    video = json['video'];
    voice_record = json['voice_record'];
    created_at = json['created_at'];
    likeCount = json['likeCount']['count'];
    dislikeCount = json['angryCount']['count'];
    AllReactionsCount = json['AllReactionsCount'];
    loveCount = json['loveCount']['count'];
    angryCount = json['angryCount']['count'];
    sadCount = json['sadCount']['count'];
    hahaCount = json['hahaCount']['count'];
    isReaction = json['isReaction'];
    myReactionType = json['myReactionType'];
    shared_count = json['shared_count'];
    admin_id = json['admin_id'];
    group_name = json['group_name'];
    group_cover = json['group_cover'];
    is_admin = json['is_admin'];

    ///To Fill List of images with imageModel and extract Data from it
    for (var i = 0; i < json['images'].length; i++) {
      imagemodel image = imagemodel.fromJson(json['images'][i]);
      images.add(image);
    }
    commentsCount = json['commentsCount'];

    ///To Fill Comments of images with CommentModel and extract Data from it

    for (var c = 0; c < json['comments'].length; c++) {
      commentmodel comment = commentmodel.fromJson(json['comments'][c]);
      comments.add(comment);
    }

    ///To Fill Reaction of images with ReactionModel and extract Data from it
    for (var r = 0; r < json['reactions'].length; r++) {
      reactionmodel reaction = reactionmodel.fromJson(json['reactions'][r]);
      reactions.add(reaction);
    }
  }
}
