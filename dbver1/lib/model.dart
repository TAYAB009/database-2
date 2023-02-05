import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHandler {
  Future<Database> initializeDB() async {
    String path = await getDatabasesPath();
    String dbName = 'usersfirst.db';
    Future<Database> openDB = openDatabase(
      join(path, dbName),
      onCreate: (db, version) async {
        return await db.execute(
            "CREATE TABLE usersfirst(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT NOT NULL, location TEXT NOT NULL)");
      },
      version: 1,
    );
    return openDB;
  }

  Future<int> insertUser(List<User> users) async {
    int result = 0;
    final Database db = await initializeDB();
    for (var user in users) {
      result = await db.insert('usersfirst', user.toMap());
    }
    return result;
  }

  Future<List<User>> retrieveUsers() async {
    final Database db = await initializeDB();
    final List<Map<String, Object?>> queryResult = await db.query('usersfirst');
    return queryResult.map((e) => User.fromJson(e)).toList();
  }
}

class User {
  final int? id;
  final String name;
  final String location;
  User({this.id, required this.name, required this.location});

  //we will send data to instace-variables through this named constructor
  //It also convert map data into object representation
  User.fromJson(Map<String, dynamic> res)
      : id = res["id"],
        name = res["name"],
        location = res["location"];

//we will return Map<String, dynamic> from this method
//It convert data back from object to map of string dynamic
  Map<String, Object?> toMap() {
    return {
      'id': id,
      'name': name,
      'location': location,
    };
  }
}

// main() {
//   User.fromJson({'id': 2, 'name': 'tayab', 'location': 'pakistan'});
// }
