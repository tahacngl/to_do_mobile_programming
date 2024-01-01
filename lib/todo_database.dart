import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:async';
import 'task/model/todo.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await initializeDatabase();
    return _database!;
  }

  Future<Database> initializeDatabase() async {
    final String dbPath = await getDatabasesPath();
    final String path = join(dbPath, "todo_database.db");

    return await openDatabase(path, version: 2, onCreate: _createDb);
  }

  Future<void> _createDb(Database db, int version) async {
    try {
      await db.execute('''
        CREATE TABLE todo (
          id INTEGER PRIMARY KEY,
          user_id TEXT,
          title TEXT,
          description TEXT,
          priority INTEGER,
          date TEXT,
          time TEXT DEFAULT '00:00',
          complete INTEGER DEFAULT 0
        )
      ''');
    } catch (e) {
      print("Database creation error: $e");
    }
  }

  Future<int> insertTodo(Todo todo) async {
    try {
      final Database db = await database;
      return await db.insert("todo", todo.toMap());
    } catch (e) {
      print("Insert error: $e");
      return -1;
    }
  }

  Future<List<Todo>> getTodos() async {
    try {
      final Database db = await database;
      var result = await db.query("todo");
      return List.generate(result.length, (index) {
        return Todo.fromMap(result[index]);
      });
    } catch (e) {
      print("Get Todos error: $e");
      return [];
    }
  }

  Future<int> deleteTodo(int? id) async {
    try {
      final Database db = await database;
      return await db.delete("todo", where: "id = ?", whereArgs: [id]);
    } catch (e) {
      print("Delete error: $e");
      return -1;
    }
  }

  Future<List<Todo>> getTodosByEmail(String email) async {
    try {
      final Database db = await database;
      var result = await db.query("todo", where: "user_id = ?", whereArgs: [email]);
      return List.generate(result.length, (index) {
        return Todo.fromMap(result[index]);
      });
    } catch (e) {
      print("Get Todos by Email error: $e");
      return [];
    }
  }

  Future<void> updateTodoCompleteStatus(int id, bool complete, String time) async {
    try {
      final Database db = await database;
      await db.update(
        'todo',
        {'complete': complete ? 1 : 0, 'time': time ?? "00:00"},
        where: 'id = ?',
        whereArgs: [id],
      );
    } catch (e) {
      print("Update error: $e");
    }
  }
  Future<void> updateTodo(Todo updatedTodo) async {
    try {
      final Database db = await database;
      await db.update(
        'todo',
        updatedTodo.toMap(),
        where: 'id = ?',
        whereArgs: [updatedTodo.id],
      );
    } catch (e) {
      print("Update error: $e");
    }
  }

}
