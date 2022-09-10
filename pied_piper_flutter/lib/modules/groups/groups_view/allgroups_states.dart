abstract class AllGroupsStates{}
class AllGroupsInitialState extends AllGroupsStates {}
class AllGroupsLoadingState extends AllGroupsStates {}
class AllGroupsSuccessState extends AllGroupsStates {

}
class AllGroupsErrorState extends AllGroupsStates {
  final String error;
  AllGroupsErrorState(this.error);
}