import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppButton extends StatelessWidget {
  final String text;
  final double? width;
  final Color? color;
  final Color? textColor;
  final bool isLoading;
  final VoidCallback onClick;
  final bool isDisable;
  final double? height;

  const AppButton({
    super.key,
    required this.text,
    this.width,
    this.color,
    this.textColor,
    this.isLoading = false,
    required this.onClick,
    this.isDisable = false,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return MaterialButton(
      padding: EdgeInsets.zero,
      onPressed: isLoading || isDisable ? () {} : onClick,
      color: isLoading || isDisable
          ? Theme.of(context).disabledColor
          : color ?? Theme.of(context).primaryColor,
      minWidth: width ?? size.width,
      height: height ?? 50,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(height == null ? 20 : 15),
      ),
      child: isLoading
          ? const CupertinoActivityIndicator()
          : Text(
              text,
              style: TextStyle(
                color: textColor ?? Colors.white,
                fontSize: 16,
              ),
            ),
    );
  }
}
