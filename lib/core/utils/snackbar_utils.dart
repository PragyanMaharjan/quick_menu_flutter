import 'package:flutter/material.dart';

class SnackBarUtils {
  /// Generic snackbar
  static void show(
      BuildContext context,
      String message, {
        Color backgroundColor = Colors.black87,
        Duration duration = const Duration(seconds: 2),
      }) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: backgroundColor,
        duration: duration,
        content: Text(
          message,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  /// Success snackbar
  static void success(BuildContext context, String message) {
    show(
      context,
      message,
      backgroundColor: Colors.green.shade600,
    );
  }

  /// Error snackbar
  static void error(BuildContext context, String message) {
    show(
      context,
      message,
      backgroundColor: Colors.redAccent,
    );
  }
}
