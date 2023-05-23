
import 'package:flutter/material.dart';
import 'package:grow_well/screens/HomePage.dart';

void main() {
  runApp(Builder(
    builder: (context) {
      return MyApp();
    }
  ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GrowWell',
      theme: ThemeData(
        primarySwatch: Colors.lightGreen,
      ),
      home:HomePage(),
    );
  }
}