import '../models/list_model.dart';
import 'package:sqflite/sqflite.dart';


class TaskData {
  static final TaskData instance = TaskData._init();
  static Database? _database;
  TaskData._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('taskData.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = '$dbPath/$filePath';
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE taskData (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        description TEXT NOT NULL,
        date DATETIME,
        isCompleted BOOLEAN NOT NULL
      )
    ''');
  }

  Future<int> insertTaskData(ListTask listTask) async {
    final db = await instance.database;
    return await db.insert('taskData', listTask.toMap());
  }

  Future<ListTask> readTaskData(int id) async {
    final db = await instance.database;
    final maps = await db.query(
      'taskData',
      columns: ['id', 'name', 'description', 'date', 'isCompleted'],
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return ListTask.fromMap(maps.first);
    } else {
      throw Exception('Can not found ID $id');
    }
  }

  Future<List<ListTask>> readAllTaskData() async {
    final db = await instance.database;
    final result = await db.query('taskData');
    return result.map((json) => ListTask.fromMap(json)).toList();
  }

  Future<int> deleteTask(int id) async {
    final db = await instance.database;
    return await db.delete(
      'taskData',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> updateTask(ListTask listTask) async {
    final db = await instance.database;
    return db.update(
      'taskData',
      listTask.toMap(),
      where: 'id = ?',
      whereArgs: [listTask.id],
    );
  }
}
