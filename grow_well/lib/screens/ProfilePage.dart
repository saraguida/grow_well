import 'package:flutter/material.dart';

class ProfilePageWidget extends StatelessWidget {
  const ProfilePageWidget({super.key});

  @override
  Widget build(BuildContext context) {
    const Text('Your profile');
    return const Center(
      child: Text(
        'Pagina Profilo',
        style: TextStyle(fontSize: 24),
      ),
    );
  }
}