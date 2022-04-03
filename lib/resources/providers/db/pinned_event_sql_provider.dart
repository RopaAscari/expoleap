import 'package:expoleap/resources/providers/db/sql_provider.dart';

class PinnedEventSQLProvider {
  PinnedEventSQLProvider._();
  static final PinnedEventSQLProvider instance = PinnedEventSQLProvider._();

  Future<List<Map<String, Object?>>> updatePinnedEvents(String id) async {
    try {
      final db = await SQLProvider.instance.database;
      await db.transaction((txn) async {
        await txn.rawInsert('INSERT INTO PinnedEvents(id) VALUES(?)', [id]);
      });
      return await retrievePinnedEvents();
    } catch (e) {
      print('Datbase error $e');
      return [];
    }
  }

  Future<List<Map<String, Object?>>> retrievePinnedEvents() async {
    try {
      final db = await SQLProvider.instance.database;
      return await db.rawQuery('SELECT * FROM PinnedEvents');
    } catch (e) {
      print('Datbase error $e');
      return [];
    }
  }

  Future<List<Map<String, Object?>>> deletePinnedEvent(String id) async {
    try {
      final db = await SQLProvider.instance.database;
      await db.rawDelete('DELETE FROM PinnedEvents WHERE id = ?', [id]);
      return await retrievePinnedEvents();
    } catch (e) {
      print('Datbase error $e');
      return [];
    }
  }
}
