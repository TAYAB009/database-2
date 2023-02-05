import 'package:dbversion2/db_handler.dart';
import 'package:dbversion2/notes_list_view.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Database-2',
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
  TextEditingController nameController = TextEditingController();

  DBhandler dBhandler = DBhandler();
  late User testUser;
  late User testUser2;
  late List<User> user;
  //adding users
  void addUser() async {
    await dBhandler.initializeDB();
    final result = await dBhandler.insertUser(user);
    List<User> getusers = await dBhandler.getUser();
    if (result == 0) {
      print('User not added!');
    } else {
      print(result);
      print(getusers[2]);
    }
  }

// fetching users

  void fetchUsers() async {
    List<User> users = await dBhandler.getUser();
    for (var user in users) {
      print(user.id);
    }
    // for (var user in users) {
    //   print('id: ${user.id} name: ${user.name}');
    // }
  }

  @override
  void initState() {
    testUser = User(name: 'ALEX');
    //testUser2 = User(name: 'Khan');
    user = [testUser];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Insert Data'),
        actions: [
          Row(
            children: [
              TextButton(
                onPressed: () {
                  setState(() {
                    addUser();
                  });
                },
                child: const Icon(
                  Icons.add,
                  color: Colors.black,
                ),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) {
                        return NotesListView();
                      },
                    ));
                  });
                },
                child: const Icon(
                  Icons.person_search,
                  color: Colors.black,
                ),
              ),
            ],
          )
        ],
      ),
      // body: FutureBuilder(
      //   future: dBhandler.getUser(),
      //   builder: (context, snapshot) {
      //     if (snapshot.hasData) {
      //       return ListView.builder(
      //         itemCount: snapshot.data!.length,
      //         itemBuilder: (context, index) {
      //           return ListTile(
      //             title: Text(snapshot.data![index].id.toString()),
      //             subtitle: Text(snapshot.data![index].name),
      //           );
      //         },
      //       );
      //     } else {
      //       return const Center(
      //         child: CircularProgressIndicator(),
      //       );
      //     }
      //   },
      // ),
    );
  }
}
