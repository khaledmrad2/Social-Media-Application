
abstract class MyInvitationsStates{}
class MyInvitationsInitialState extends MyInvitationsStates {}
class MyInvitationsLoadingState extends MyInvitationsInitialState {}
class MyInvitationsSuccessState extends MyInvitationsInitialState {

}
class MyInvitationsErrorState extends MyInvitationsStates {
  final String error;

  MyInvitationsErrorState(this.error);
}
class ChangeAcceptState extends MyInvitationsStates{}