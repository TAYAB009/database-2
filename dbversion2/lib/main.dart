import 'package:dbversion2/db_handler.dart';
import 'package:dbversion2/notes_list_view.dart';
import 'package:flutter/material.dart';

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
  late TextEditingController nameController;

  DBhandler dBhandler = DBhandler();
  late User testUser;
  late List<User> user;
  //adding users
  void addUser() async {
    await dBhandler.initializeDB();
    final result = await dBhandler.insertUser(user);
    if (result == 0) {
      print('User not inserted!');
    } else {
      print('User inserted!');
    }
  }

  @override
  void initState() {
    nameController = TextEditingController();
    testUser = User(name: '');
    user = [testUser];
    super.initState();
  }

  void updateUserName(String name) {
    setState(() {
      testUser = User(name: name);
      user = [testUser];
    });
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
                        return const NotesListView();
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
      body: FutureBuilder(
        future: dBhandler.getUser(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Center(
              child: Column(
                children: [
                  TextField(
                    controller: nameController,
                    onChanged: (value) {
                      updateUserName(value);
                    },
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'enter user name',
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        nameController.clear();
                        addUser();
                        Navigator.push(context, MaterialPageRoute(
                          builder: (context) {
                            return const NotesListView();
                          },
                        ));
                      });
                    },
                    child: const Text('Add User'),
                  ),
                ],
              ),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
