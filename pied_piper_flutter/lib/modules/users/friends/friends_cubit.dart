
import 'package:flutter_bloc/flutter_bloc.dart';

import 'friends_states.dart';

class FriendsCubit extends Cubit<FriendsStates>{
  FriendsCubit() : super(FriendsInitialState());
  static FriendsCubit get(context)=> BlocProvider.of(context);

}