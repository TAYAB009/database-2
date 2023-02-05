import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'dbVersion0',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late DatabaseHelper databaseHelper;
  @override
  void initState() {
    Future<int> addUser() async {
      User user1 = User(name: 'TAYAB');
      User user2 = User(name: 'KHAN');
      List<User> userList = [
        user1,
        user2,
      ];

      return databaseHelper.insertUser(userList);
    }

    super.initState();

    databaseHelper = DatabaseHelper();
    databaseHelper.initializeDB().whenComplete(() async {
      await addUser();
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('dbVersion0'),
      ),
      body: FutureBuilder(
        future: databaseHelper.retrieveUsers(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return Center(
                    child: Card(
                  child: Text(snapshot.data![index].name),
                ));
              },
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
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

class DatabaseHelper {
  Future<Database> initializeDB() async {
    String dbname = 'users.db';
    String path = await getDatabasesPath();
    String dbpath = join(path, dbname);
    Future<Database> openDb =
        openDatabase(dbpath, version: 1, onCreate: (db, version) async {
      await db.execute(
          'CREATE TABLE users(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT NOT NULL)');
    });
    return await openDb;
  }

  Future<int> insertUser(List<User> users) async {
    int result = 0;
    Database db = await initializeDB();
    for (var user in users) {
      result = await db.insert('users', user.toMap());
    }

    return result;
  }

  Future<List<User>> retrieveUsers() async {
    Database db = await initializeDB();
    final List<Map<String, dynamic>> queryResult = await db.query('users');
    return queryResult.map((e) => User.fromJson(e)).toList();
  }
}
