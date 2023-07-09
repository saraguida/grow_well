import 'package:flutter/material.dart';
import 'package:grow_well/database/database.dart';
import 'package:grow_well/repositories/databaseRepository.dart';
import 'package:grow_well/screens/LoginPage.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final AppDatabase database =
      await $FloorAppDatabase.databaseBuilder('app_database.db').build();
  final databaseRepository = DatabaseRepository(database: database);

  runApp(ChangeNotifierProvider<DatabaseRepository>(
    create: (context) => databaseRepository,
    child: MyApp(),
  ));
} //main

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GrowWell',
      theme: ThemeData(
        primarySwatch: Colors.lightGreen,
      ),
      home: LoginPage(),
    );
  }
}
