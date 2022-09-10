
abstract class AddCommentStates{}
class AddCommentInitialState extends AddCommentStates {}
class AddCommentLoadingState extends AddCommentStates {}
class AddCommentSuccessState extends AddCommentStates {

}
class AddCommentErrorState extends AddCommentStates {
  final String error;

  AddCommentErrorState(this.error);
}
class AddCommentloadImage extends AddCommentStates{}
class AddCommentloadImagefromcamera extends AddCommentStates{}
class AddCommentWritingwithPhotoCamera extends AddCommentStates{}
class AddCommentWriting extends AddCommentStates{}
class AddCommentWritingwithPhoto extends AddCommentStates{}
class ChangeWriteComment extends AddCommentStates{}
class ChangeNoComment extends AddCommentStates{}