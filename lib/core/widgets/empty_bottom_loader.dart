import 'package:flutter/material.dart';

class EmptyBottomLoader extends StatelessWidget {
  const EmptyBottomLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox();
    /* return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: const [
          Text(
            'پایان لیست',
            style: TextStyle(fontSize: 16),
          ),
        ],
      ),
    );*/
  }
}
