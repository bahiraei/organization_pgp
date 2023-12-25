import 'package:flutter/material.dart';

class CustomTabBar extends StatelessWidget {
  final IconData? icon;
  final String title;
  final bool isShowLine;
  final VoidCallback onTap;
  final Widget? child;

  const CustomTabBar({
    super.key,
    this.icon,
    required this.title,
    required this.isShowLine,
    required this.onTap,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Column(
          children: [
            SizedBox(
              height: 25,
              width: 25,
              child: child ??
                  Icon(
                    icon,
                    color: isShowLine ? Colors.black87 : Colors.black54,
                  ),
            ),
            const SizedBox(height: 5),
            Text(
              title,
              style: TextStyle(
                fontSize: 12,
                color: isShowLine ? Colors.black87 : Colors.black54,
              ),
            ),
            const SizedBox(height: 15),
            isShowLine
                ? Container(
                    height: 1,
                    color: Colors.black87,
                  )
                : const SizedBox(),
          ],
        ),
      ),
    );
  }
}
