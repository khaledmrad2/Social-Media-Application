abstract class UpdateStates{}
class UpdateInitialState extends UpdateStates {}
class UpdateLoadingState extends UpdateStates {}
class UpdateSuccessState extends UpdateStates {

}
class UpdateErrorState extends UpdateStates {
  final String error;

  UpdateErrorState(this.error);
}
class deleteorginalimage extends UpdateStates{}
class UpdateCommentloadImage extends UpdateStates{}
class UpdateCommentloadImagefromcamera extends UpdateStates{}
class UpdateCommentWritingwithPhotoCamera extends UpdateStates{}
class UpdateCommentWriting extends UpdateStates{}
class UpdateCommentWritingwithPhoto extends UpdateStates{}
class ChangeWriteComment extends UpdateStates{}
class ChangeNoComment extends UpdateStates{}