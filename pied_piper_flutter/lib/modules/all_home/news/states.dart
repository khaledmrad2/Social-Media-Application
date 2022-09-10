abstract class GetpostStates {}

class GetpostInitialState extends GetpostStates {}

class GetpostLoadingState extends GetpostStates {}

class GetpostSelectReactionState extends GetpostStates {}

class GetpostSuccessState extends GetpostStates {}

class GetpostErrorState extends GetpostStates {
  final String error;
  GetpostErrorState(this.error);
}
