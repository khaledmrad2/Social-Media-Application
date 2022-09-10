import 'package:dio/dio.dart';
import 'package:flutter/material.dart';


class DioHelper{
  static Dio dio;
  static init(){
    dio =Dio(
      BaseOptions(
        baseUrl:'http://10.0.2.2:8000/api/',
        receiveDataWhenStatusError: true,
      ),
    );
  }
  static Future<Response> getData({
    @required String url,
    @required Map<String,dynamic> query,
    Map<String,dynamic> headers2
  })async
  {

    return await dio.get(url,queryParameters: query,options: Options(
        headers: headers2
    ));
  }
  static Future<Response> PostData({
    @required String url,
    @required Map<String,dynamic> data
  })async
  {
    return await dio.post(url,queryParameters: data);
  }
}