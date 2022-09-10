
abstract class PersonalInformationStates{}
class PersonalInformationInitialState extends PersonalInformationStates {}
class PersonalInformationLoadingState extends PersonalInformationInitialState {}
class PersonalInformationSuccessState extends PersonalInformationInitialState {

}
class PersonalInformationErrorState extends PersonalInformationStates {
  final String error;

  PersonalInformationErrorState(this.error);
}
class ChangeToggleHire extends PersonalInformationStates{}