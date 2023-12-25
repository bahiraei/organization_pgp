import 'package:flutter/material.dart';

class DrawerMenuItem extends StatelessWidget {
  final String? routeName;
  final String title;
  final Widget child;
  final VoidCallback? onTap;

  const DrawerMenuItem({
    super.key,
    this.routeName,
    required this.title,
    required this.child,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.grey[100],
      child: InkWell(
        onTap: routeName == null
            ? onTap
            : () => Navigator.pushNamed(context, routeName!),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          width: double.infinity,
          color: Colors.transparent,
          height: 50,
          child: Row(
            children: [
              SizedBox(
                height: 30,
                width: 30,
                child: child,
              ),
              const SizedBox(width: 10),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
