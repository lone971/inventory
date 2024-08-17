import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:logging/logging.dart';

class DatabaseHelper {
  static const _databaseName = "inventory.db";
  static const _databaseVersion = 1;

  static const table = 'items';

  static const columnId = 'id';
  static const columnName = 'name';
  static const columnPrice = 'price';
  static const columnStock = 'stock'; // Initial stock
  static const columnSold = 'sold'; // Sold items
  static const columnRemaining = 'remaining'; // Remaining stock
  static const columnTimestamp = 'timestamp'; // Timestamp

  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;

  // Set up logging
  static final Logger _logger = Logger('DatabaseHelper');

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    try {
      return await openDatabase(
        join(await getDatabasesPath(), _databaseName),
        onCreate: (db, version) {
          return db.execute('''
            CREATE TABLE $table (
              $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
              $columnName TEXT NOT NULL,
              $columnPrice REAL NOT NULL,
              $columnStock INTEGER NOT NULL,  -- Initial stock
              $columnSold INTEGER NOT NULL DEFAULT 0,  -- Sold items
              $columnRemaining INTEGER NOT NULL,  -- Remaining stock
              $columnTimestamp INTEGER NOT NULL DEFAULT (strftime('%s', 'now'))  -- Unix timestamp
            )
          ''');
        },
        version: _databaseVersion,
      );
    } catch (e) {
      _logger.severe('Error initializing database: $e');
      rethrow;
    }
  }

  Future<int> insert(Map<String, dynamic> row) async {
    Database db = await instance.database;
    try {
      return await db.insert(table, row);
    } catch (e) {
      _logger.severe('Error inserting data: $e');
      rethrow;
    }
  }

  Future<List<Map<String, dynamic>>> queryAll() async {
    Database db = await instance.database;
    try {
      return await db.query(table, orderBy: '$columnTimestamp DESC');
    } catch (e) {
      _logger.severe('Error querying data: $e');
      rethrow;
    }
  }

  Future<int> update(Map<String, dynamic> row) async {
    Database db = await instance.database;
    int id = row[columnId];
    try {
      return await db
          .update(table, row, where: '$columnId = ?', whereArgs: [id]);
    } catch (e) {
      _logger.severe('Error updating data: $e');
      rethrow;
    }
  }

  Future<int> delete(int id) async {
    Database db = await instance.database;
    try {
      return await db.delete(table, where: '$columnId = ?', whereArgs: [id]);
    } catch (e) {
      _logger.severe('Error deleting data: $e');
      rethrow;
    }
  }
}
