import 'package:flutter/material.dart';

class NewDataPage extends StatelessWidget {
  const NewDataPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Insert the new data'),
      ),
      body: const Center(
        child: Text(
          'Pagina di inserimento dati',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}