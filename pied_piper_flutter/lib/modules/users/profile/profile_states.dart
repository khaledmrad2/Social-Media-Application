abstract class ProfileStates{}
class ProfileInitialState extends ProfileStates {}
class ProfileLoadingState extends ProfileStates {}
class ProfileSuccessState extends ProfileStates {

}
class ProfileErrorState extends ProfileStates {
  final String error;
  ProfileErrorState(this.error);
}
class ChangeButtomState extends ProfileStates{}