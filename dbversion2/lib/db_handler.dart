import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBhandler {
  Future<Database> initializeDB() async {
    String dbName = 'user.db';
    String path = await getDatabasesPath();
    final String dbPath = join(path, dbName);
    Future<Database> openDB = openDatabase(
      dbPath,
      version: 1,
      onCreate: (db, version) async {
        await db.execute(
            'CREATE TABLE user(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT NOT NULL)');
      },
    );
    return await openDB;
  }

  Future<int> insertUser(List<User> users) async {
    int result = 0;
    Database database = await initializeDB();
    for (var user in users) {
      result = await database.insert('user', user.toMap());
    }
    return result;
  }

  Future<List<User>> getUser() async {
    Database db = await initializeDB();
    List<Map<String, dynamic>> dbResult =
        await db.query('user', orderBy: 'id DESC');
    return dbResult.map((e) => User.fromJson(e)).toList();
  }
}

class User {
  final int? id;
  final String name;
  User({this.id, required this.name});
  User.fromJson(Map<String, dynamic> src)
      : id = src['id'],
        name = src['name'];

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
    };
  }
}
