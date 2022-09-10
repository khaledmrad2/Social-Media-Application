
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../shared/components/constants.dart';
import '../../../shared/network/remote/dio_helper.dart';
import 'mygroups_states.dart';

class MyGroupsCubit extends Cubit<MyGroupsStates> {
  MyGroupsCubit() : super(MyGroupsInitialState());

  static MyGroupsCubit get(context) => BlocProvider.of(context);
  List<dynamic> MyGroupsResult = [];
  void GetMyGroups() {
    emit(MyGroupsLoadingState());
    DioHelper.getData(url: MainURL + MyGroupsURL, query: {
    }, headers2: TokenHeaders
    ).then((value) {
      MyGroupsResult = value.data['groups'];
      emit(MyGroupsSuccessState());
    }).catchError((onError) {
      print(onError.toString());
      emit(MyGroupsErrorState(onError));
    });
  }
}