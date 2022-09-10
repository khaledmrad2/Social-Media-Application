abstract class MutualFriendsStates{}
class MutualFriendsInitialState extends MutualFriendsStates {}
class MutualFriendsLoadingState extends MutualFriendsStates {}
class MutualFriendsSuccessState extends MutualFriendsStates {

}
class MutualFriendsErrorState extends MutualFriendsStates {
  final String error;
  MutualFriendsErrorState(this.error);
}