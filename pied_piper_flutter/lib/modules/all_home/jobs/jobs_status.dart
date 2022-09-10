abstract class JobsStates {}

class JobsInitialState extends JobsStates {}

class JobsLoadingState extends JobsStates {}

class JobsSuccessState extends JobsStates {}

class JobsErrorState extends JobsStates {
  final String error;

  JobsErrorState(this.error);
}
