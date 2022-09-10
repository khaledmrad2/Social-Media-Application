import 'package:pied_piper/shared/network/local/cache_helper.dart';

class imagemodel {
  String url;
  int id;
  int post_id;
  imagemodel.fromJson(Map<String, dynamic> json) {
    ///URL of image
    url = json['url'];

    ///ID of image
    id = json['id'];

    ///Post_ID of image
    post_id = json['post_id'];
  }
}
