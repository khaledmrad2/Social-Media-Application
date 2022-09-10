import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pied_piper/modules/login/cubit/login_screen.dart';
import 'package:pied_piper/modules/reset_password/cubit/states.dart';
import '../../../shared/components/components.dart';
import '../../../shared/components/constants.dart';

class ResetPasswordCubit extends Cubit<ResetPasswordStates> {
  ///Because We Make inheritance
  ResetPasswordCubit() : super(ResetPasswordInitialState());

  ///To Get Current Bloc Object
  static ResetPasswordCubit get(context) => BlocProvider.of(context);
  ///here we don't use model for reset password
  ///response was only Success and  Message (NO Data) to save
  void ResetCode({
    @required password,
    @required code,
    @required BuildContext context,
  }) async {
    emit(ResetPasswordLoadingState());
    String url = MainURL + ResetPasswordURL;
    http.post(
      Uri.parse(url),
      headers: SendHeaders,
      body: {
        "password_confirmation": password,
        "password": password,
        "code": code,
      },
    ).then(
      (response) {
        Map Mapvalue = json.decode(response.body);

        ///success
        if (Mapvalue["success"]) {
          ///Go To LoginScreen and See A message
          navigateTo(context, LoginScreen());
          ScaffoldMessenger.of(context).showSnackBar(
            MySnakbar(text: 'Password Changed Successfully!'),
          );
        }

        ///failed
        else {
          ScaffoldMessenger.of(context).showSnackBar(
            MySnakbar(text: 'Invalid Code !'),
          );
        }
      },
    ).catchError(
      (error) {
        print("loginDataEnter: ${error.toString()}");
      },
    );
  }

  ///1 password ,2 Confirm
  IconData suffix1 = Icons.visibility_outlined;
  IconData suffix2 = Icons.visibility_outlined;
  bool ispassword1 = true;
  bool ispassword2 = true;
  void changePasswordVisibility1() {
    ///flip the state of the icon
    ispassword1 = !ispassword1;
    suffix1 = ispassword1 ? Icons.visibility_outlined : Icons.visibility_off;
    emit(ResetPasswordChangePasswordVisibilityState());
  }

  void changePasswordVisibility2() {
    ispassword2 = !ispassword2;
    suffix2 = ispassword2 ? Icons.visibility_outlined : Icons.visibility_off;
    emit(ResetPasswordChangePasswordVisibilityState());
  }

  /// Here This function will send APi to backend
  /// that send the email for reset password and we
  /// use this function when press on resend again
  /// to send code verification to the current email
  /// and the Different Between this and that is already exist
  /// in resetpassword cubit is that the sequel of
  /// the url(ResendURL,SendEmailtoResetPasswordURL)
  void ResendCodeVerfication({
    @required String email,
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
      },
    ).catchError(
      (error) {
        print("loginDataEnter: ${error.toString()}");
      },
    );
  }

  ///this for button to avoid infinity loading state of the button
  bool isLoading = false;
  void changeisLoading() {
    if (isLoading)
      emit(ResetPasswordLoadingState());
    else
      emit(ResetPasswordInitialState());
    isLoading = !isLoading;
  }
}
