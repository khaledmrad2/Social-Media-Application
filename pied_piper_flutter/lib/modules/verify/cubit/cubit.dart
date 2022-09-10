import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pied_piper/models/login_model.dart';
import 'package:pied_piper/modules/login/cubit/login_screen.dart';
import 'package:pied_piper/modules/register/cubit/states.dart';
import 'package:pied_piper/modules/verify/cubit/states.dart';
import 'package:pied_piper/shared/components/constants.dart';
import 'package:pied_piper/shared/network/remote/dio_helper.dart';
import 'package:pied_piper/shared/network/remote/end_points.dart';
import 'package:http/http.dart' as http;
import '../../../shared/components/components.dart';

class VerifyCubit extends Cubit<VerifyStates> {
  ///Because We Make inheritance
  VerifyCubit() : super(VerifyInitialState());

  ///To Get Current Bloc Object
  static VerifyCubit get(context) => BlocProvider.of(context);

  ///here we don't use model for verify
  ///response was only Success and  Message (NO Data) to save
  void userVerify({
    @required String code,

    ///Context that refers on VerifyScreen
    BuildContext context,
  }) {
    emit(VerifyLoadingState());
    String url = MainURL + VerifyURL;
    http.post(
      Uri.parse(url),
      headers: SendHeaders,
      body: {
        'code': code,
      },
    ).then(
      (response) {
        Map Mapvalue = json.decode(response.body);

        ///Wrong  Code
        if (!Mapvalue["success"]) {
          emit(VerifyWrongState());
          showDialog(
            context: context,
            builder: (context) => MyDialogSingleButton(
              context: context,
              Mapvalue: Mapvalue,

              ///Cancel Button and this Don't Do anything on press
              ok: false,
            ),
          );
        }

        ///success
        else {
          emit(VerifySuccessState());
          showDialog(
            context: context,
            builder: (context) => MyDialogSingleButton(
              context: context,
              Mapvalue: Mapvalue,

              ///button is ok and move to next screen
              ok: true,
              nextscreen: LoginScreen(),
            ),
          );
        }
      },
    ).catchError(
      (error) {
        print("loginDataEnter: ${error.toString()}");
      },
    );
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
    String url = MainURL + ResendURL;
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
      emit(VerifyLoadingState());
    else
      emit(VerifyInitialState());
    isLoading = !isLoading;
  }
}
