import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../shared/components/constants.dart';
import '../../../shared/network/remote/dio_helper.dart';
import 'allgroups_states.dart';

class AllGroupsCubit extends Cubit<AllGroupsStates> {
  AllGroupsCubit() : super(AllGroupsInitialState());

  static AllGroupsCubit get(context) => BlocProvider.of(context);
  List<dynamic> AllGroupsResult = [];
  void getAllGroups() {
    emit(AllGroupsLoadingState());
    DioHelper.getData(
            url: MainURL + AllGroupsURL, query: {}, headers2: TokenHeaders)
        .then((value) {
      AllGroupsResult = value.data['groups'];
      print(AllGroupsResult);
      emit(AllGroupsSuccessState());
    }).catchError((onError) {
      print(onError.toString());
      emit(AllGroupsErrorState(onError));
    });
  }
}
