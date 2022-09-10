import 'package:pied_piper/models/image_model.dart';
import 'package:pied_piper/models/reaction_model.dart';
import 'package:pied_piper/shared/network/local/cache_helper.dart';

class commentmodel {
  int comment_id;
  String created_at;
  String image;
  bool isReaction;
  String myReactionType;
  int post_id;
  List<reactionmodel> reactions = [];
  int reactionCount;
  String text;
  String updated_at;
  int user_id;
  String user_name;
  String user_picture;
  commentmodel.fromJson(Map<String, dynamic> json) {
    comment_id = json['comment_id'];
    created_at = json['created_at'];
    image = json['image'];
    isReaction = json['isReaction'];
    myReactionType = json['myReactionType'];
    post_id = json['post_id'];
    for (var r = 0; r < json['reactions'].length; r++) {
      reactionmodel reaction = reactionmodel.fromJson(json['reactions'][r]);
      reactions.add(reaction);
    }
    reactionCount = json['reactionCount'];
    text = json['text'];
    updated_at = json['updated_at'];
    user_id = json['user_id'];
    user_name = json['user_name'];
    user_picture = json['user_picture'];
  }
}
