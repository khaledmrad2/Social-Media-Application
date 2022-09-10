import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CacheHelper {
  static SharedPreferences sharedPreferences;
  static init() async {
    sharedPreferences = await SharedPreferences.getInstance();
  }

  static Future<bool> saveData({
    @required String key,
    @required dynamic value,
  }) async {
    return await sharedPreferences.setString(key, value);
  }

  static Future<bool> saveDataint({
    @required String key,
    @required int value,
  }) async {
    if (value is int) return await sharedPreferences.setInt(key, value);
  }

  static String GetData({
    @required String key,
  }) {
    return sharedPreferences.getString(key);
  }

  static int GetDataint({
    @required String key,
  }) {
    return sharedPreferences.getInt(key);
  }

  static Future<bool> removeData({
    @required String key,
  }) async {
    return await sharedPreferences.remove(key);
  }

  static Future<bool> Clear() async {
    return await sharedPreferences.clear();
  }
}
