import 'package:pied_piper/models/login_model.dart';

abstract class LoginStates {}

class LoginInitialState extends LoginStates {}

class LoginLoadingState extends LoginStates {}

class LoginSuccessState extends LoginStates {
  final loginmodel loginModel;
  LoginSuccessState(this.loginModel);
}

class LoginErrorState extends LoginStates {
  final String error;
  LoginErrorState(this.error);
}

class LoginChangePasswordVisibilityState extends LoginStates {}


class LoginisVerifyState extends LoginStates {}


class LoginisWrongState extends LoginStates {}
