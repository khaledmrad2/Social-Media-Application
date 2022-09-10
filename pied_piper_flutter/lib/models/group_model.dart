class groupmodel {
  bool status;
  GroupData user;
  String message;
  groupmodel.fromJson(Map<String, dynamic> json) {
    status = json['success'];
    message = json['message'];
    user = json['group'] != null ? GroupData.fromJson(json['group']) : null;
  }
}

class GroupData {
  bool isadmin;
  String admin_name;
  int admin_id;
  int id;
  String title;
  String privacy;
  String cover;
  bool isMember;
  bool isRequested;
  bool isInvited;
  int memberCount;
  List<dynamic> groupPosts;
  GroupData.fromJson(Map<String, dynamic> json) {
    groupPosts = json['posts'];
    memberCount = json['membersCount'];
    id = json['id'];
    title = json['title'];
    isadmin = json['isAdmin'];
    admin_name = json['admin_name'];
    cover = json['cover'];
    admin_id = json['admin_id'];
    privacy = json['privacy'];
    isMember = json['isMember'];
    isRequested = json['isRequested'];
    isInvited = json['isInvited'];
  }
}
