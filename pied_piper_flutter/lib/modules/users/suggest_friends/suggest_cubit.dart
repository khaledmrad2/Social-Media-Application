import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pied_piper/modules/users/suggest_friends/suggest_states.dart';
import '../../../shared/components/constants.dart';
import '../../../shared/network/remote/dio_helper.dart';

class SuggestFriendsCubit extends Cubit<SuggestFriendsStates> {
  SuggestFriendsCubit() : super(SuggestFriendsInitialState());

  static SuggestFriendsCubit get(context) => BlocProvider.of(context);
  List<dynamic> SuggestFriendsResult = [];
  void getSuggestFriends() {
    emit(SuggestFriendsLoadingState());
    DioHelper.getData(
      url: MainURL + SuggestFriendUrl,
      query: {},
      headers2: TokenHeaders,
    ).then((value) {
      SuggestFriendsResult = value.data['suggested'];
      print(SuggestFriendsResult);
      emit(SuggestFriendsSuccessState());
    }).catchError((onError) {
      print(onError.toString());
      emit(SuggestFriendsErrorState(onError));
    });
  }
}
