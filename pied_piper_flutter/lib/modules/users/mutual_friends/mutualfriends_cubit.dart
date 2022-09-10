import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../shared/components/constants.dart';
import '../../../shared/network/remote/dio_helper.dart';
import 'mutualfriends_states.dart';

class MutualFriendsCubit extends Cubit<MutualFriendsStates> {
  MutualFriendsCubit() : super(MutualFriendsInitialState());

  static MutualFriendsCubit get(context) => BlocProvider.of(context);
  List<dynamic> MutualFriendsResult = [];
  void getMutualFriends(
    @required int id,
  ) {
    emit(MutualFriendsLoadingState());
    DioHelper.getData(
            url: MainURL + getMutualfriendsURL + "${id}",
            query: {},
            headers2: TokenHeaders)
        .then((value) {
      MutualFriendsResult = value.data['mutual_friends'];
      emit(MutualFriendsSuccessState());
    }).catchError((onError) {
      print(onError.toString());
      emit(MutualFriendsErrorState(onError));
    });
  }
}
