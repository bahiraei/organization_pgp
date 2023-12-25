import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final VoidCallback onPressed;
  final Widget? child;
  final double? width;
  final double? height;
  final bool isLoading;
  final bool isDisable;
  final bool showLoading;
  final bool showShadow;
  final Color? backgroundColor;
  final double? borderRadius;
  final double elevation;

  const CustomButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.height = 48,
    this.width = double.infinity,
    this.isLoading = false,
    this.isDisable = false,
    this.showShadow = true,
    this.showLoading = true,
    this.backgroundColor = const Color(0xff377199),
    this.borderRadius = 12,
    this.elevation = 10,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(borderRadius ?? 12),
      elevation: elevation,
      shadowColor: showShadow ? backgroundColor : null,
      color: backgroundColor,
      child: InkWell(
        borderRadius: BorderRadius.circular(borderRadius ?? 12),
        onTap: isLoading || isDisable ? null : onPressed,
        child: Container(
          height: height,
          width: width,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(borderRadius ?? 12),
          ),
          child: isLoading && showLoading
              ? const Center(
                  child: SizedBox(
                    height: 24,
                    width: 24,
                    child: CircularProgressIndicator.adaptive(
                      backgroundColor: Colors.white,
                    ),
                  ),
                )
              : Center(child: child),
        ),
      ),
    );
  }
}
