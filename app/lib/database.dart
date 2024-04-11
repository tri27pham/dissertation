import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dataModel.dart'; // Ensure this import is correct for your DataModel
import 'allocatedTask.dart'; // Ensure this import is correct for your AllocatedTask

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();
  static Database? _database;

  DatabaseHelper._privateConstructor();

  Future<Database?> get database async {
    if (_database != null) return _database;
    _database = await _initDatabase();
    return _database;
  }

  Future<Database> _initDatabase() async {
    final path = await getDatabasesPath();
    final databasePath = join(path, 'tasks.db');

    return await openDatabase(
      databasePath,
      version: 1,
      onCreate: _createDatabase,
    );
  }

  Future<void> _createDatabase(Database db, int version) async {
    await db.execute('''
      CREATE TABLE tasks(
        taskID INTEGER PRIMARY KEY,
        name TEXT,
        startDateTime TEXT,
        endDateTime TEXT,
        priority INTEGER,
        locationName TEXT,
        category INTEGER
      )
    ''');
  }

  // Add task to database
  Future<void> insertTasks(List<AllocatedTask> tasks) async {
    print("tset");
    final db = await database;
    if (db != null) {
      Batch batch = db.batch();

      for (AllocatedTask task in tasks) {
        batch.insert('tasks', task.toMap());
      }

      await batch.commit(noResult: true);
    } else {
      print("Database is not available for inserting tasks.");
    }
  }

  Future<void> deleteDb() async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'tasks.db');

    await deleteDatabase(path);
  }

  // Retrieve all tasks from database
  Future<List<AllocatedTask>> getTasks() async {
    final db = await database;
    if (db != null) {
      final List<Map<String, dynamic>> maps = await db.query('tasks');
      return List.generate(maps.length, (i) => AllocatedTask.fromMap(maps[i]));
    } else {
      print("Database is not available for retrieving tasks.");
      return [];
    }
  }

  // Delete all tasks from database
  Future<void> deleteAllTasks() async {
    final db = await database;
    if (db != null) {
      await db.delete('tasks');
    } else {
      print("Database is not available for deleting tasks.");
    }
  }

  // Close the database
  Future<void> closeDatabase() async {
    final db = await database;
    if (db != null) {
      await db.close();
      _database =
          null; // Ensure _database is set to null to properly handle re-opening
    }
  }
}
