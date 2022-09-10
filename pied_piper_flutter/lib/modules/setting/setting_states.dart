abstract class settingStates {}

class settingInitialState extends settingStates {}

class settingLoadingState extends settingStates {}

class settingSuccessState extends settingStates {}

class settingErrorState extends settingStates {
  final String error;

  settingErrorState(this.error);
}
