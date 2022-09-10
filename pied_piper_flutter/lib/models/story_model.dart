
class storymodel{
  int id;
  bool is_visitor;
  String text;
  String image;
  int user_id;
  String user_name;
  String user_pic;

  storymodel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    is_visitor = json['is_visitor'];
    text = json['text'];
    image = json['image_url'];
    user_id = json['user']['id'];
    user_name = json['user']['name'];
    user_pic = json['user']['picture'];
  }
}
