import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ABOUT THE APP',style:  TextStyle(color: Color.fromARGB(255, 59, 81, 33), fontWeight: FontWeight.bold)),
      ),
      body: const Center(
        child: Text(
          'Pagina FAQ',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}