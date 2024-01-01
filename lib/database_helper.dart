import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;
  var tblUser = "users";
  var colId = "id";
  var colName = "name";
  var colEmail = "email";
  var colPassword = "password";

  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await initializeDatabase();
    return _database!;
  }

  Future<Database> initializeDatabase() async {
    final String dbpath = join(await getDatabasesPath(), "user_database.db");
    var user_databaseDb = await openDatabase(dbpath, version: 1, onCreate: (db, version) async {
      await createDb(db, version);
    });
    return user_databaseDb;
  }

  Future<void> createDb(Database db, int version) async {
    await db.execute(
        'CREATE TABLE IF NOT EXISTS $tblUser(id INTEGER PRIMARY KEY, name TEXT, email TEXT, password TEXT)');
  }

  Future<void> insertUser(String name, String email, String password) async {
    final Database db = await database;

    await db.insert(
      tblUser,
      {'name': name, 'email': email, 'password': password},
      conflictAlgorithm: ConflictAlgorithm.abort,
    );
  }

  Future<int> getUserId(String email, String password) async {
    final Database db = await database;
    var result = await db.query(tblUser, where: 'email = ? AND password = ?', whereArgs: [email, password]);
    if (result.isNotEmpty) {
      return result[0]['id'] as int;
    } else {
      return -1;
    }
  }

  Future<bool> checkUserCredentials(String enteredEmail, String enteredPassword) async {
    final Database db = await database;
    final List<Map<String, dynamic>> result = await db.query(
      tblUser,
      where: 'email = ? AND password = ?',
      whereArgs: [enteredEmail, enteredPassword],
    );
    return result.isNotEmpty;
  }

  Future<bool> checkEmailTaken(String email) async {
    final Database db = await database;
    final List<Map<String, dynamic>> result = await db.query(
      tblUser,
      where: 'email = ?',
      whereArgs: [email],
    );
    return result.isNotEmpty;
  }
}
