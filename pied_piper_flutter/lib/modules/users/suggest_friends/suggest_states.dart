abstract class SuggestFriendsStates{}
class SuggestFriendsInitialState extends SuggestFriendsStates {}
class SuggestFriendsLoadingState extends SuggestFriendsStates {}
class SuggestFriendsSuccessState extends SuggestFriendsStates {

}
class SuggestFriendsErrorState extends SuggestFriendsStates {
  final String error;
  SuggestFriendsErrorState(this.error);
}