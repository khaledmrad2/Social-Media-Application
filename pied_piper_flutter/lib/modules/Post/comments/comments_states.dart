
abstract class CommentStates{}
class CommentInitialState extends CommentStates {}
class CommentLoadingState extends CommentStates {}
class CommentSuccessState extends CommentStates {

}
class CommentErrorState extends CommentStates {
  final String error;

  CommentErrorState(this.error);
}
class CommentReactionRow extends CommentStates{}
class ChooseReaction extends CommentStates{}