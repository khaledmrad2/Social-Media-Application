abstract class CreateGroupStates {}

class CreateGroupInitialState extends CreateGroupStates {}

class CreateGroupLoadingState extends CreateGroupInitialState {}

class CreateGroupSuccessState extends CreateGroupInitialState {}

class CreateGroupErrorState extends CreateGroupStates {
  final String error;

  CreateGroupErrorState(this.error);
}

class ChangeTogglePrivate extends CreateGroupStates {}

class AddCoverloadImagefromcamera extends CreateGroupStates {}

class AddCoverloadImage extends CreateGroupStates {}

class AddCoverWritingwithPhotoCamera extends CreateGroupStates {}

class CreateGroupWriting extends CreateGroupStates {}
