import 'package:expoleap/models/notification.dart';
import 'package:expoleap/resources/providers/db/sql_provider.dart';

class NotificationSQLProvider {
  NotificationSQLProvider._();
  static final NotificationSQLProvider instance = NotificationSQLProvider._();

  Future<List<Map<String, Object?>>> fetchNotifications(String id) async {
    try {
      final db = await SQLProvider.instance.database;
      return await db
          .rawQuery('SELECT * FROM Notifications WHERE eventId = ?', [id]);
    } catch (e) {
      print('Datbase error $e');
      return [];
    }
  }

  Future<List<Map<String, Object?>>> deleteNotifications(
      String notificationId, String eventId) async {
    ;
    try {
      final db = await SQLProvider.instance.database;
      await db.rawDelete(
          'DELETE FROM Notifications WHERE id = ?', [notificationId]);
      return fetchNotifications(eventId);
    } catch (e) {
      print('Datbase error $e');
      return [];
    }
  }

  Future<List<Map<String, Object?>>> updateNotifications(
      NotificationModel notificationModel, String eventId) async {
    try {
      final db = await SQLProvider.instance.database;

      await db.transaction((txn) async {
        await txn.rawInsert(
            'INSERT INTO Notifications(id, eventId,  message, timeStamp) VALUES(?,?,?,?)',
            [
              notificationModel.id,
              notificationModel.eventId,
              notificationModel.message,
              notificationModel.timeStamp
            ]);
      });
      return fetchNotifications(eventId);
    } catch (e) {
      print('Datbase error $e');
      return [];
    }
  }
}
