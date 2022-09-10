import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pied_piper/models/login_model.dart';
import 'package:pied_piper/modules/register/cubit/states.dart';
import 'package:pied_piper/shared/components/constants.dart';
import 'package:pied_piper/shared/network/remote/dio_helper.dart';
import 'package:pied_piper/shared/network/remote/end_points.dart';
import 'package:http/http.dart' as http;
import '../../../shared/components/components.dart';
import '../../login/cubit/states.dart';
import '../../verify/cubit/verify_screen.dart';

class RegisterCubit extends Cubit<RegisterStates> {
  ///  Because We Make inheritance
  RegisterCubit() : super(RegisterInitialState());

  ///To Get Current Bloc Object
  static RegisterCubit get(context) => BlocProvider.of(context);

  ///here we don't use model for register
  ///response was only Success and  Message (NO Data) to save
  void userRegister({
    @required String name,
    @required String email,
    @required String password,

    ///Hint:I Don't Send Password_Confirmation Beacuse I already Validate
    ///That they are equal in the screen

    ///Context that refers on RegisterScreen
    @required BuildContext context,
  }) {
    String url = MainURL + SignupURL;
    emit(RegisterLoadingState());

    http.post(
      Uri.parse(url),
      headers: SendHeaders,
      body: {
        "name": name,
        "email": email,
        "password": password,
        "password_confirmation": password,
      },
    ).then(
      (response) {
        ///Decode The Response
        Map Mapvalue = json.decode(response.body);

        ///Email  or UserName or Both are already Used
        if (response.statusCode == 422) {
          emit(RegisterWrongState());
          ScaffoldMessenger.of(context).showSnackBar(
            MySnakbar(text: Mapvalue["message"]),
          );
        }

        ///Success to Register
        else if (response.statusCode == 201) {
          emit(RegisterSuccessState());
          showDialog(
            context: context,
            builder: (context) => MyDialogSingleButton(
              context: context,
              Mapvalue: Mapvalue,

              /// Ok Or Cancel Button
              /// and ok Mean that i will Move To new screen
              ok: true,

              ///New Screen That i will move to when press on ok
              nextscreen: VerifyScreen(
                email: email,
              ),
            ),
          );
        }
      },
    ).catchError(
      (error) {
        emit(RegisterErrorState(error));
        print("loginDataEnter: ${error.toString()}");
      },
    );
  }

  ///i use  1 for  password and 2 for confirm
  IconData suffix1 = Icons.visibility_outlined;
  IconData suffix2 = Icons.visibility_outlined;
  bool ispassword1 = true;
  bool ispassword2 = true;
  void changePasswordVisibility1() {
    ///Flip The Current State of the Icon
    ispassword1 = !ispassword1;
    suffix1 = ispassword1 ? Icons.visibility_outlined : Icons.visibility_off;
    emit(RegisterChangePasswordVisibilityState());
  }

  void changePasswordVisibility2() {
    ///Flip The Current State of the Icon
    ispassword2 = !ispassword2;
    suffix2 = ispassword2 ? Icons.visibility_outlined : Icons.visibility_off;
    emit(RegisterChangePasswordVisibilityState());
  }

  bool isLoading = false;

  ///this for Register button to avoid infinity loading state of the button
  void changeisLoading() {
    if (isLoading)
      emit(RegisterInitialState());
    isLoading = !isLoading;
  }
}
