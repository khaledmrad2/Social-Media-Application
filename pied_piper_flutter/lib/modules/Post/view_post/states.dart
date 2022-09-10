abstract class PostStates {}

class PostInitialState extends PostStates {}

class PostSelectReaction extends PostStates{}

class PostChangeState extends PostStates{}

class PostErrorState extends PostStates {
  final String error;
  PostErrorState(this.error);
}
