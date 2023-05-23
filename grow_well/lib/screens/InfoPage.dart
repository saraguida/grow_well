import 'package:flutter/cupertino.dart';

class InfoPageWidget extends StatelessWidget {
  const InfoPageWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'Pagina Info',
        style: TextStyle(fontSize: 24),
      ),
    );
  }
}