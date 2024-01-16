import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';

class Helper {
  static void log(
    String message, {
    bool isForce = false,
  }) {
    /*debugPrint(message);*/
    if (kIsWeb) {
      return;
    } else if (!isForce || !kDebugMode) {
      return;
    } else {
      debugPrint(message);
    }
  }

  static showSnackBar(String message, BuildContext context) {
    toastification.show(
      context: context,
      type: ToastificationType.info,
      style: ToastificationStyle.minimal,
      title: const Text('پیام!'),
      description: Text(message),
      alignment: Alignment.topRight,
      autoCloseDuration: const Duration(seconds: 4),
      animationBuilder: (
        context,
        animation,
        alignment,
        child,
      ) {
        return ScaleTransition(
          scale: animation,
          child: child,
        );
      },
      borderRadius: BorderRadius.circular(12.0),
      boxShadow: lowModeShadow,
      showProgressBar: true,
      dragToClose: true,
    );
  }

  static showToast({
    required String title,
    required String description,
    required BuildContext context,
    ToastificationType? type,
  }) {
    toastification.show(
      context: context,
      type: type ?? ToastificationType.info,
      style: ToastificationStyle.minimal,
      title: Text(title),
      description: Text(description),
      alignment: Alignment.topRight,
      autoCloseDuration: const Duration(seconds: 4),
      animationBuilder: (
        context,
        animation,
        alignment,
        child,
      ) {
        return ScaleTransition(
          scale: animation,
          child: child,
        );
      },
      borderRadius: BorderRadius.circular(12.0),
      boxShadow: lowModeShadow,
      showProgressBar: true,
      dragToClose: true,
    );
  }
}
