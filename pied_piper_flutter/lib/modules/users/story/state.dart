abstract class StoryStates{}
class StoryInitialState extends StoryStates {}
class StoryLoadingState extends StoryStates {}
class StorySuccessState extends StoryStates {

}
class StoryErrorState extends StoryStates {
  final String error;
  StoryErrorState(this.error);
}
class ChangeToNext extends StoryStates{}