
abstract class NotificationStates{}
class NotificationInitialState extends NotificationStates {}
class NotificationLoadingState extends NotificationStates {}
class NotificationSuccessState extends NotificationStates {

}
class NotificationErrorState extends NotificationStates {
  final String error;

  NotificationErrorState(this.error);
}
class NotificationSeenState extends NotificationStates{}