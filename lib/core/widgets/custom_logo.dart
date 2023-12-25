import 'package:flutter/material.dart';

class CustomLogo extends StatelessWidget {
  const CustomLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return const Text(
      'PGP',
      style: TextStyle(
        fontSize: 18,
        color: Colors.blue,
      ),
    );
  }
}
