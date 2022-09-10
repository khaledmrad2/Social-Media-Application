import 'package:pied_piper/models/login_model.dart';

abstract class RegisterStates {}

class RegisterInitialState extends RegisterStates {}

class RegisterLoadingState extends RegisterStates {}

class RegisterSuccessState extends RegisterStates {

}

class RegisterErrorState extends RegisterStates {
  final String error;

  RegisterErrorState(this.error);
}

class RegisterWrongState extends RegisterStates {}

class RegisterChangePasswordVisibilityState extends RegisterStates {}
