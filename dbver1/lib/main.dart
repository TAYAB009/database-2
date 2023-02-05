import 'package:dbver1/model.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DBversion-1',
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
  late DatabaseHandler handler;

  @override
  void initState() {
    Future<int> addUsers() async {
      User user1 = User(name: 'TAYAB', location: 'Pakistan');
      User user2 = User(name: 'Lexa', location: 'USA');
      User user3 = User(name: 'Alex', location: 'Finland');

      List<User> myUsers = [
        user1,
        user2,
        user3,
      ];
      return await handler.insertUser(myUsers);
    }

    super.initState();

    handler = DatabaseHandler();
    handler.initializeDB().whenComplete(() async {
      await addUsers();
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('DatabaseVersion-1'),
      ),
      body: FutureBuilder(
        future: handler.retrieveUsers(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: (snapshot.data!.length),
              itemBuilder: (context, index) {
                return Card(
                    child: ListTile(
                  key: ValueKey<int>(snapshot.data![index].id!),
                  title: Text(snapshot.data![index].name),
                  subtitle: Text(snapshot.data![index].location),
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
