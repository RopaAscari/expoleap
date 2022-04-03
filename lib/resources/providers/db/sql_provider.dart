import 'package:sqflite/sqflite.dart';
import 'package:expoleap/widgets/late_handler.dart';

class SQLProvider {
  SQLProvider._();
  static final SQLProvider instance = SQLProvider._();

  Late<Database> _database = new Late();

  Future<Database> get database async {
    if (_database.isInitialized) return _database.val;
    //// if _database is null we instantiate it
    _database.val = await initializeDatabase();
    return _database.val;
  }

  initializeDatabase() async {
    var databasesPath = await getDatabasesPath();
    String path = '$databasesPath/expoleap.db';
    // open the database
    return await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database db, int version) async {
      // Batch batch = db.batch();
      await db.execute('CREATE TABLE PinnedEvents (id INTEGER)');
      await db.execute(
          'CREATE TABLE Notifications (id TEXT, eventId TEXT, message TEXT, timeStamp INTEGER)');
    });
  }
}
