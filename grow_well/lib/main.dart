import 'package:flutter/material.dart';
import 'package:grow_well/models/dataDB.dart';
import 'package:grow_well/screens/HomePage.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(Builder(builder: (context) {
    return MyApp();
  }));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<DataDB>(
      create: (context) => DataDB(),
      child: MaterialApp(
        title: 'GrowWell',
        theme: ThemeData(
          primarySwatch: Colors.lightGreen,
        ),
        home: HomePage(),
      ),
    );
  }
}
