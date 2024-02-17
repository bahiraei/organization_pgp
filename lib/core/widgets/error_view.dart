import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import 'custom_button.dart';

class ErrorView extends StatelessWidget {
  final String? message;
  final TextStyle style;
  final Function onRetry;
  final bool canRetry;

  const ErrorView({
    super.key,
    required this.message,
    required this.onRetry,
    this.canRetry = true,
    this.style = const TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.w700,
    ),
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.error_outline,
            size: 64,
            color: Colors.black45,
          ),
          const Gap(24),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                child: Text(
                  message ?? 'خطایی رخ داده است',
                  style: style,
                ),
              ),
            ],
          ),
          const Gap(44),
          if (canRetry)
            SizedBox(
              width: null,
              child: CustomButton(
                width: 120,
                height: 44,
                backgroundColor: Colors.red,
                showShadow: false,
                borderRadius: 20,
                onPressed: () {
                  onRetry();
                },
                child: const Text(
                  'تلاش مجدد',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
