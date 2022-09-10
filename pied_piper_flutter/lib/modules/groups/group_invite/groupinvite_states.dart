abstract class GroupInviteStates{}
class GroupInviteInitialState extends GroupInviteStates {}
class GroupInviteLoadingState extends GroupInviteStates {}
class GroupInviteSuccessState extends GroupInviteStates {

}
class GroupInviteErrorState extends GroupInviteStates {
  final String error;
  GroupInviteErrorState(this.error);
}
class changetoinvite extends GroupInviteStates{}