
abstract class FriendsStates{}
class FriendsInitialState extends FriendsStates {}
class FriendsLoadingState extends FriendsStates {}
class FriendsSuccessState extends FriendsStates {

}
class FriendsErrorState extends FriendsStates {
  final String error;

  FriendsErrorState(this.error);
}