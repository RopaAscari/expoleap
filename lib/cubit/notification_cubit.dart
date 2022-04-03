import 'package:bloc/bloc.dart';
import 'package:expoleap/models/notification.dart';
import 'package:expoleap/state/notification/notification_state.dart';
import 'package:expoleap/resources/repositories/notification_repository.dart';

class NotificationCubit extends Cubit<NotificationState> {
  NotificationCubit() : super(Idle());

  final NotificationRepository notificationRepository =
      new NotificationRepository();

  Future<void> fetchNotifications({required String eventId}) async {
    try {
      emit(NotificationState.loading());
      final dynamic notifications =
          await notificationRepository.getNotifications(eventId);

      emit(NotificationState.data(data: notifications));
    } catch (err) {
      NotificationState.error(error: err.toString());
    }
  }

  void deleteNotification(
      {required String notificationId, required String eventId}) async {
    try {
      final List<NotificationModel> notifications = await notificationRepository
          .deleteNotification(notificationId, eventId);
      emit(NotificationState.data(data: notifications));
    } catch (err) {
      NotificationState.error(error: err.toString());
    }
  }
}
