abstract class GroupHomeStates {}

class GroupHomeInitialState extends GroupHomeStates {}

class GroupHomeLoadingState extends GroupHomeStates {}

class GroupHomeSuccessState extends GroupHomeStates {}

class GroupHomeErrorState extends GroupHomeStates {
  final String error;

  GroupHomeErrorState(this.error);
}
