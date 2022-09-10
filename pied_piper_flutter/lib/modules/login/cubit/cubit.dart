import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pied_piper/models/login_model.dart';
import 'package:pied_piper/modules/all_home/home/home_screen.dart';
import 'package:pied_piper/modules/login/cubit/states.dart';
import 'package:pied_piper/shared/network/local/cache_helper.dart';
import 'package:pied_piper/shared/network/remote/end_points.dart';
import 'package:pied_piper/shared/network/remote/dio_helper.dart';
import 'package:http/http.dart' as http;
import '../../../shared/components/components.dart';
import '../../../shared/components/constants.dart';
import '../../Post/addpost/addpost_screen.dart';
import '../../reset_password/cubit/resetpassword_screen.dart';
import '../../verify/cubit/verify_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginCubit extends Cubit<LoginStates> {
  ///Because We Make inheritance
  LoginCubit() : super(LoginInitialState());

  ///To Get Current Bloc Object
  static LoginCubit get(context) => BlocProvider.of(context);
  loginmodel loginModel;
  void userLogin({
    @required String email,
    @required String password,

    ///Context that refers on LoginScreen
    BuildContext context,
  }) {
    ///Update state
    emit(LoginLoadingState());
    String url = MainURL + LoginURL;
    http.post(
      Uri.parse(url),
      headers: SendHeaders,
      body: {
        "email": email,
        "password": password,
      },
    ).then(
      (response) {
        ///decode the response
        Map Mapvalue = json.decode(response.body);

        loginmodel.fromJson(Mapvalue);

        ///fail to login
        if (!Mapvalue["success"]) {
          ///Need To Verify Email
          if (response.statusCode == 422) {
            emit(LoginisVerifyState());
            showDialog(
              context: context,
              builder: (context) => MyDialogDualButton(
                context: context,
                Mapvalue: Mapvalue,

                ///Send The Email to VerifyScreen
                email: email,

                ///Move to Verify Screen
                nextscreen: VerifyScreen(
                  email: email,
                ),
              ),
            );
          }

          ///Wrong Data
          else if (response.statusCode == 403) {
            emit(LoginisWrongState());
            if (Mapvalue["message"] == "unauthenticated")

              ///Here I Update The message From Backend to show the message for user
              Mapvalue["message"] = "Wrong Email or Password";
            showDialog(
              context: context,
              builder: (context) => MyDialogSingleButton(
                context: context,
                Mapvalue: Mapvalue,

                ///Ok Mean that This Button is Cancel
                ///and don't Move to Anther Screen
                ok: false,
              ),
            );
          }
        }

        ///This is Success State
        else {
          ///save the data in loginModel and send it to success state in the loginstates
          ///to access it from  screen //Create Job
          loginModel = loginmodel.fromJson(Mapvalue);
          TokenHeaders = {
            "Authorization": "Bearer ${loginModel.data.token}",
          };
          Navigator.pop(context);
          emit(LoginSuccessState(loginModel));
          navigateTo(context, HomeScreen());
        }
      },
    ).catchError(
      (error) {
        emit(LoginErrorState(error.toString()));
        print("loginDataEnter: ${error.toString()}");
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
    emit(LoginChangePasswordVisibilityState());
  }

  ///this for button to avoid infinity loading state of the button
  bool isLoading = false;
  void changeisLoading() {
    if (isLoading) emit(LoginInitialState());
    isLoading = !isLoading;
  }

  /// Here This function will send APi to backend
  /// that send the email for reset password and we
  /// use this function when press on forget password?
  /// button on the screen that takes the email from the email
  /// field and check if the email is already exist  or Not
  void SendEmailtoResetPassword({
    @required email,
    @required BuildContext context,
  }) async {
    String url = MainURL + SendEmailtoResetPasswordURL;
    http.post(
      Uri.parse(url),
      headers: SendHeaders,
      body: {
        "email": email,
      },
    ).then(
      (response) {
        Map Mapvalue = json.decode(response.body);
        

        ///OK,Email exists
        if (Mapvalue["success"]) {
          navigateTo(context, ResetPasswordScreen(email: email));

          ///show a Snackbar message
          ScaffoldMessenger.of(context).showSnackBar(
            MySnakbar(text: 'Code Sended Successfully!'),
          );
        }

        /// Email Not Found and show SnackBar message
        else
          ScaffoldMessenger.of(context).showSnackBar(
            MySnakbar(text: 'Email Not Found!'),
          );
      },
    ).catchError(
      (error) {
        print("loginDataEnter: ${error.toString()}");
      },
    );
  }
}
