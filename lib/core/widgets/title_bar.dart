import 'package:flutter/material.dart';

class TitleBar extends StatelessWidget {
  final Size size;
  final String title;
  final VoidCallback onTap;
  final Widget? child;

  const TitleBar({
    super.key,
    required this.size,
    required this.title,
    required this.onTap,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: SizedBox(
        width: size.width,
        height: 75,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: onTap,
              child: Container(
                alignment: Alignment.centerLeft,
                width: 35,
                height: 35,
                decoration: BoxDecoration(
                  border: Border.all(
                    width: 1.5,
                    color: Colors.white,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.arrow_back_ios,
                  color: Colors.white,
                ),
              ),
            ),
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
              ),
            ),
            child ?? const SizedBox(),
          ],
        ),
      ),
    );
  }
}
