import 'package:dbversion2/db_handler.dart';
import 'package:flutter/material.dart';

class NotesListView extends StatefulWidget {
  const NotesListView({super.key});

  @override
  State<NotesListView> createState() => _NotesListViewState();
}

class _NotesListViewState extends State<NotesListView> {
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
      print(user.name);
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
                    fetchUsers();
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
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(snapshot.data![index].id.toString()),
                  subtitle: Text(snapshot.data![index].name),
                );
              },
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
