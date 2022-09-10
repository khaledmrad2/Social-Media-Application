
abstract class SvaedPostsStates{}
class SvaedPostsInitialState extends SvaedPostsStates {}
class SvaedPostsLoadingState extends SvaedPostsStates {}
class SvaedPostsSuccessState extends SvaedPostsStates {

}
class SvaedPostsErrorState extends SvaedPostsStates {
  final String error;

  SvaedPostsErrorState(this.error);
}
class SvaedPostsSeenState extends SvaedPostsStates{}