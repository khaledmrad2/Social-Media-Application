
abstract class MembersStates{}
class MembersInitialState extends MembersStates {}
class MembersLoadingState extends MembersStates {}
class MembersSuccessState extends MembersStates {

}
class MembersErrorState extends MembersStates {
  final String error;

  MembersErrorState(this.error);
}