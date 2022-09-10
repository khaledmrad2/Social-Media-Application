import 'package:pied_piper/models/post_model.dart';

class profilemodel {
  bool status;
  ProfileData user;
  String message;
  profilemodel.fromJson(Map<String, dynamic> json) {
    status = json['success'];
    message = json['message'];
    user =
    json['profile'] != null ? ProfileData.fromJson(json['profile']) : null;
  }
}

class ProfileData {
  int id;
  String name;
  String email;
  String picture;
  String cover;
  int available_to_hire;
  String location;
  String job_title;
  bool visitor;
  bool isFriend;
  bool isSentToHim;
  bool isSendToMe;
  List<dynamic> listFriends;
  List<dynamic>userpost;
  int mutualFriendsCount;
  ProfileData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    picture = json['picture'];
    cover = json['cover'];
    available_to_hire = json['available_to_hire'];
    location = json['location'];
    job_title = json['job_title'];
    visitor = json['visitor'];
    isFriend = json['isFriend'];
    isSentToHim = json['isSentToHim'];
    isSendToMe = json['isSendToMe'];
    listFriends = json['friends'];
    userpost = json['posts'];
    mutualFriendsCount = json['mutual_friends_count'];
  }
}
