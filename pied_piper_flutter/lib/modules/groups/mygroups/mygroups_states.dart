abstract class MyGroupsStates{}
class MyGroupsInitialState extends MyGroupsStates {}
class MyGroupsLoadingState extends MyGroupsStates {}
class MyGroupsSuccessState extends MyGroupsStates {

}
class MyGroupsErrorState extends MyGroupsStates {
  final String error;
  MyGroupsErrorState(this.error);
}