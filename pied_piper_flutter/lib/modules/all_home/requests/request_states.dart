
abstract class RequestStates{}
class RequestInitialState extends RequestStates {}
class RequestLoadingState extends RequestInitialState {}
class RequestSuccessState extends RequestInitialState {

}
class RequestErrorState extends RequestStates {
  final String error;

  RequestErrorState(this.error);
}
class ChangeToConditionState extends RequestStates{}