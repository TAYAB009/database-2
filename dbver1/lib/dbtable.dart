


//  Future<Database> initializeDB() async {
//     String path = await getDatabasesPath();
//     Future<Database> mydatabase = openDatabase(
//       join(path, 'userfirst.db'),
//       onCreate: (db, version) async {
//         return await db.execute(
//           "CREATE TABLE usersfirst(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT NOT NULL, location TEXT NOT NULL)",
//         );
//       },
//       version: 1,
//     );
//     return mydatabase;
//   }