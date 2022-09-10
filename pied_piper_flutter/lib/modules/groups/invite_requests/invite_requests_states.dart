abstract class InviteRequestsStates{}
class InviteRequestsInitialState extends InviteRequestsStates {}
class InviteRequestsLoadingState extends InviteRequestsStates {}
class InviteRequestsSuccessState extends InviteRequestsStates {

}
class InviteRequestsErrorState extends InviteRequestsStates {
  final String error;
  InviteRequestsErrorState(this.error);
}
class changetoAccept extends InviteRequestsStates{}