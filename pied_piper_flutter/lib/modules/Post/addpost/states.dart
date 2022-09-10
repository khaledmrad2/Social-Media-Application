abstract class AddpostStates {}

class AddpostInitialState extends AddpostStates {}

class AddpostLoadingState extends AddpostStates {}

class AddpostSuccessState extends AddpostStates {}

class AddpostErrorState extends AddpostStates {
  final String error;
  AddpostErrorState(this.error);
}

class AddpostisVerifyState extends AddpostStates {}

class AddpostisWrongState extends AddpostStates {}

class AddpostloadImage extends AddpostStates {}

class AddpostloadVideo extends AddpostStates {}


class AddpostloadImagefromcamera extends AddpostStates {}

class AddpostWriting extends AddpostStates {}

class AddpostWritingwithPhoto extends AddpostStates {}

class AddpostWritingwithPhotoCamera extends AddpostStates {}

class AddpostWritingwithVoice extends AddpostStates {}

class AddpostWritingwithVideo extends AddpostStates {}

class AddpostloadVoice extends AddpostStates {}
