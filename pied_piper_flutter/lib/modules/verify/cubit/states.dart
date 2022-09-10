
abstract class VerifyStates {}

class VerifyInitialState extends VerifyStates {}

class VerifyLoadingState extends VerifyStates {}

class VerifyWrongState extends VerifyStates {}

class VerifySuccessState extends VerifyStates {}

class VerifyErrorState extends VerifyStates {
  final String error;

  VerifyErrorState(this.error);
}
