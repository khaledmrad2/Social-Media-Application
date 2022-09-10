
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../shared/components/constants.dart';
import '../../../shared/network/remote/dio_helper.dart';
import 'notification_states.dart';

class NotificationCubit extends Cubit<NotificationStates> {
  NotificationCubit() : super(NotificationInitialState());
  static NotificationCubit get(context) => BlocProvider.of(context);

  List<bool> isSeenOne = [];
  void BuildIsSeen({@required int length,List<dynamic>list}) {
    for (int i = 0; i < length; i++) {
      if(list[i]["isSeen"]==0)
        isSeenOne.add(false);
      else isSeenOne.add(true);
    }
  }

  void isSeenNow({
    @required int index,
  }) {
    isSeenOne[index] = true;
    emit(NotificationSeenState());
  }

  List<dynamic> Notification = [];
  void getNotification() {
    emit(NotificationLoadingState());
    DioHelper.getData(
            url: MainURL + GetNotificationURL,
            query: {},
            headers2: TokenHeaders)
        .then((value) {

      Notification = value.data['notifications'];

      emit(NotificationSuccessState());
    }).catchError((onError) {
      print(onError.toString());
      emit(NotificationErrorState(onError));
    });
  }
}
