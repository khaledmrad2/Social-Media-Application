import 'package:pied_piper/shared/network/local/cache_helper.dart';

class loginmodel {
  bool status;
  UserData data;
  String message;

  loginmodel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['user'] != null ? UserData.fromJson(json['user']) : null;
  }
}

class UserData {
  int id;
  String name;
  String email;
  String picture;
  String cover;
  int available_to_hire;
  String location;
  String job_title;
  String token;
  UserData.fromJson(Map<String, dynamic> json) {
    id = json['id'];

    name = json['name'];

    email = json['email'];

    picture = json['picture'];

    cover = json['cover'];

    available_to_hire = json['available_to_hire'];

    location = json['location'];

    job_title = json['job_title'];

    token = json['token'];
    CacheHelper.saveDataint(key: 'id', value: json['id']);
    CacheHelper.saveData(key: 'name', value: json['name']);
    CacheHelper.saveData(key: 'email', value: json['email']);
    CacheHelper.saveData(key: 'picture', value: json['picture']);
    CacheHelper.saveData(key: 'cover', value: json['cover']);
    CacheHelper.saveDataint(
        key: 'available_to_hire', value: json['available_to_hire']);
    CacheHelper.saveData(key: 'location', value: json['location']);
    CacheHelper.saveData(key: 'job_title', value: json['job_title']);
    CacheHelper.saveData(key: 'token', value: json['token']);
  }
}
