import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pied_piper/modules/login/cubit/login_screen.dart';
import 'package:pied_piper/modules/setting/setting_states.dart';
import 'package:pied_piper/shared/components/components.dart';
import 'package:pied_piper/shared/network/local/cache_helper.dart';
import 'package:http/http.dart' as http;

import '../../shared/components/constants.dart';

class settingCubit extends Cubit<settingStates> {
  settingCubit() : super(settingInitialState());
  static settingCubit get(context) => BlocProvider.of(context);
  void logout(context) {
    String url = MainURL + Log_outURL;
    emit(settingLoadingState());
    http.post(Uri.parse(url), headers: TokenHeaders).then((value) {
      Map Mapvalue = json.decode(value.body);
      if (Mapvalue['success']) {
        CacheHelper.Clear();
        Navigator.pop(context);
        Navigator.pop(context);
        navigateTo(context, LoginScreen());
      } else {
        showDialog(
          context: context,
          builder: (context) => MyDialogSingleButton(
              context: context, ok: false, sendedmessage: ErrorMessage),
        );
      }
    }).catchError(
      (error) {
        emit(settingErrorState(error.toString()));
        print("GetPost Error is : ${error.toString()}");
      },
    );
  }

  ///Icon Of password
  IconData suffix = Icons.visibility_outlined;
  bool ispassword = true;
  void changePasswordVisibility() {
    ///Flip The Current State of the Icon
    ispassword = !ispassword;
    suffix = ispassword ? Icons.visibility_outlined : Icons.visibility_off;
    emit(settingLoadingState());
  }

  void deleteAccount(context, String password) {
    String url = MainURL + DeleteAccountURL;
    http.post(Uri.parse(url), headers: TokenHeaders, body: {
      "password": password,
      "password_confirmation": password,
    }).then((response) {
      Map Mapvalue = json.decode(response.body);
      print(Mapvalue);
    if(Mapvalue['success'])
      {
        Navigator.pop(context);
        showDialog(
          context: context,
          builder: (context) => MyDialogSingleButton(
            context: context,
            Mapvalue: Mapvalue,

            /// Ok Or Cancel Button
            /// and ok Mean that i will Move To new screen
            ok: true,

            ///New Screen That i will move to when press on ok
            nextscreen: LoginScreen(
            ),
          ),
        );
      }
    else
      {
        showDialog(
          context: context,
          builder: (context) => MyDialogSingleButton(
            context: context,
            Mapvalue: Mapvalue,

            /// Ok Or Cancel Button
            /// and ok Mean that i will Move To new screen
            ok: false,

            ///New Screen That i will move to when press on ok

          ),
        );
      }
    });
  }
}
