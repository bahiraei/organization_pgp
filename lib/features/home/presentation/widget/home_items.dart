import 'package:flutter/material.dart';

class HomeItems extends StatelessWidget {
  final Color color;
  final String text;
  final Color? textColor;
  final String? routeName;
  final VoidCallback? onTap;
  final double? fontSize;
  final double? margin;
  final Widget child;
  final int? badgeCount;
  final Object? arguments;

  const HomeItems({
    super.key,
    required this.color,
    required this.text,
    this.textColor,
    this.routeName,
    this.fontSize,
    this.margin,
    required this.child,
    this.onTap,
    this.badgeCount,
    this.arguments,
  });

  @override
  Widget build(BuildContext context) {
    return Badge(
      label: Text(
        '$badgeCount',
      ),
      isLabelVisible: badgeCount != null,
      alignment: Alignment.topRight,
      offset: const Offset(-10, -5),
      child: SizedBox(
        width: 80,
        child: InkWell(
          /*splashColor: Colors.white,*/
          /*hoverColor: Colors.transparent,*/
          borderRadius: BorderRadius.circular(16),
          onTap: onTap ??
              () => Navigator.pushNamed(
                    context,
                    routeName ?? '',
                    arguments: arguments,
                  ),
          child: Column(
            children: [
              Container(
                alignment: Alignment.center,
                margin: EdgeInsets.symmetric(horizontal: margin ?? 20),
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: SizedBox(
                  width: 25,
                  height: 25,
                  child: child,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                text,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: fontSize ?? 12,
                  color: (textColor ?? Colors.black),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
