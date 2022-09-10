abstract class SearchHistoryStates{}
class SearchHistoryInitialState extends SearchHistoryStates {}
class SearchHistoryLoadingState extends SearchHistoryStates {}
class SearchHistorySuccessState extends SearchHistoryStates {

}
class SearchHistoryErrorState extends SearchHistoryStates {
  final String error;
  SearchHistoryErrorState(this.error);
}