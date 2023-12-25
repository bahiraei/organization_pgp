import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';

class Helper {
  static void log(
    String message, {
    bool isForce = false,
  }) {
    debugPrint(message);
    /*if (kIsWeb) {
      return;
    } else if (!isForce || !kDebugMode) {
      return;
    } else {
      debugPrint(message);
    }*/
  }

  static showSnackBar(String message, BuildContext context) {
    /*ScaffoldMessenger.of(context).removeCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
        ),
      ),
    );*/

    toastification.show(
      context: context,
      type: ToastificationType.info,
      style: ToastificationStyle.minimal,
      title: 'پیام!',
      description: message,
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
      title: title,
      description: description,
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
