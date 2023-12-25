import 'package:flutter/material.dart';

import '../consts/consts.dart';

class AppBackground extends StatelessWidget {
  final Size size;
  final Widget child;

  const AppBackground({
    super.key,
    required this.size,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size.width,
      height: size.height,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(AppColor.gradiantDarkColor),
            Color(AppColor.gradiantLightColor),
          ],
          begin: Alignment.topRight,
          end: Alignment.bottomCenter,
        ),
      ),
      child: child,
    );
  }
}
