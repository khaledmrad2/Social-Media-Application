import 'package:pied_piper/models/image_model.dart';
import 'package:pied_piper/shared/network/local/cache_helper.dart';

class reactionmodel {
  String type;
  int user_id;
  String user_name;
  String user_picture;

  reactionmodel.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    user_id = json['user_id'];
    user_name = json['user_name'];
    user_picture = json['user_picture'];
  }
}
