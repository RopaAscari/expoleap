import 'package:expoleap/models/notification.dart';
import 'package:expoleap/resources/providers/db/notification_sql_provider.dart';

class NotificationRepository {
  Future<List<NotificationModel>> getNotifications(String eventId) async {
    final response =
        await NotificationSQLProvider.instance.fetchNotifications(eventId);
    return response.map((e) => NotificationModel.fromMap(e)).toList();
  }

  Future<List<NotificationModel>> deleteNotification(
      String notificationId, String eventId) async {
    final response = await NotificationSQLProvider.instance
        .deleteNotifications(notificationId, eventId);
    return response.map((e) => NotificationModel.fromMap(e)).toList();
  }
}
