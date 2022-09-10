abstract class GroupStates{}
class GroupInitialState extends GroupStates {}
class GroupLoadingState extends GroupStates {}
class GroupSuccessState extends GroupStates {

}
class GroupErrorState extends GroupStates {
  final String error;
  GroupErrorState(this.error);
}
class ChangeButtomState extends GroupStates{}
class DeleteCoverState extends GroupStates{}
class isNotCoverState extends GroupStates{}
class isPrivateState extends GroupStates{}
class ChangeToPrivateState extends GroupStates{}
class SetPrivacyState extends GroupStates{}

class ChangeTogglePrivate extends GroupStates{}
class AddCoverloadImagefromcamera extends GroupStates{}
class AddCoverWritingwithCamera extends GroupStates{}
class AddCoverWritingwithCameraphoto extends GroupStates{}

class AddCoverloadImage extends GroupStates{}
class AddCoverWritingwithPhoto extends GroupStates{}
class GroupWriting extends GroupStates{}
class UpdatedSuccefully extends GroupStates{}