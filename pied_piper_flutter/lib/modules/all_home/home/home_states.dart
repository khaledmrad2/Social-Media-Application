abstract class HomeStates{}
class HomeInitialState extends HomeStates {}
class HomeBottomNavState extends HomeStates{}
class HomeGetPostsSuccessState extends HomeStates{}
class HomeLoadingState extends HomeStates{}
class HomeGetPostsErrorState extends HomeStates{
  final String error;
  HomeGetPostsErrorState(this.error);
}