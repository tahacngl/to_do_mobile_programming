
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:to_do_mobile_programming/Task/model/todo.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;
  var tblTodo = "todo";
  var colId = "id";
  var colTitle = "title";
  var colDescription = "description";
  var colPriority = "priority";
  var colDate = "date";

  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;

    // _database nullsa initialize et
    _database = await initializeDatabase();
    return _database!;
  }

  Future<Database> initializeDatabase() async {
    final String dbpath = join(await getDatabasesPath(), "user_database.db");
    var user_databaseDb =
        await openDatabase(dbpath, version: 1, onCreate: createDb);
    return user_databaseDb;
  }

  void createDb(Database db, int version) async {
    await db.execute(
        'CREATE TABLE users(id INTEGER PRIMARY KEY, name TEXT, email TEXT, password TEXT)');
    await db.execute(
        "CREATE TABLE $tblTodo($colId integer primary key, $colTitle TEXT," +
            "$colDate TEXT, $colDescription TEXT,$colPriority INTEGER " +
            ")");
  }

  /* Future<Database> initializeDatabase() async {
    final path = join(await getDatabasesPath(), 'user_database.db');
    return await openDatabase(
      path,
      version: 1,
      onOpen: (db) async{},
      onCreate: (db, version) async{
        await  db.execute(
          'CREATE TABLE users(id INTEGER PRIMARY KEY, name TEXT, email TEXT, password TEXT)',


        );
        await db.execute('CREATE TABLE users(id INTEGER PRIMARY KEY, type TEXT, email TEXT, password TEXT)');


      },

    );
  }*/

  Future<void> insertUser(String name, String email, String password) async {
    final Database db = await database;

    await db.insert(
      'users',
      {'name': name, 'email': email, 'password': password},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<bool> checkUserCredentials(
      String enteredEmail, String enteredPassword) async {
    final Database db = await database;
    final List<Map<String, dynamic>> result = await db.query(
      'users',
      where: 'email = ? AND password = ?',
      whereArgs: [enteredEmail, enteredPassword],
    );
    return result.isNotEmpty;
  }

  Future<bool> checkEmailTaken(String email) async {
    final Database db = await database;
    final List<Map<String, dynamic>> result = await db.query(
      'users',
      where: 'email = ?',
      whereArgs: [email],
    );
    return result.isNotEmpty;
  }

  Future<int> insertTodo(Todo todo) async {
    final Database db = await database;
    var result = await db.insert(tblTodo, todo.toMap());
    return result;
  }


  Future<List<Todo>> getTodos () async {
    final Database db = await database;
    var result = await db.rawQuery("SELECT * FROM $tblTodo ORDER BY $colPriority ");
    return List.generate(result.length, (index){
      return Todo.fromObject(result[index]);
    });
  }


  Future<int?> getCount() async {
    final Database db = await database;
    var result = Sqflite.firstIntValue(
        await db.rawQuery("SELECT COUNT(*) FROM $tblTodo"));

    return result;
  }

  Future<int> updateTodo(Todo todo) async {
    final Database db = await database;
    var result = await db.update(tblTodo, todo.toMap(),
        where: "$colId = ?", whereArgs:[todo.id] );
    return result;
  }

  Future<int> deleteTodo(int id) async {
    final Database db = await database;
    var result = await db.delete(tblTodo, where: "$colId = ?", whereArgs: [id]);
    return result;
  }
}

