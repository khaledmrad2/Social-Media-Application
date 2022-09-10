
abstract class ChangePicStates{}
class ChangePicInitialState extends ChangePicStates {}
class ChangePicLoadingState extends ChangePicStates {}
class ChangePicSuccessState extends ChangePicStates {

}
class ChangePicErrorState extends ChangePicStates {
  final String error;

  ChangePicErrorState(this.error);
}
class ChangePicloadImage extends ChangePicStates{}
class ChangePicloadImagefromcamera extends ChangePicStates{}
class ChangePicWritingwithPhotoCamera extends ChangePicStates{}
class ChangePicWriting extends ChangePicStates{}
class ChangePicWritingwithPhoto extends ChangePicStates{}
class ChangeWriteComment extends ChangePicStates{}
class ChangeNoComment extends ChangePicStates{}