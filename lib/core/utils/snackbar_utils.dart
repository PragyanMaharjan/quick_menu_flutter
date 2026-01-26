import 'package:flutter/material.dart';

class SnackBarUtils {
  static void _show(
    BuildContext context,
    String message, {
    required Color backgroundColor,
    IconData? icon,
    Duration duration = const Duration(seconds: 2),
  }) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        duration: duration,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        backgroundColor: backgroundColor,
        content: Row(
          children: [
            if (icon != null) ...[
              Icon(icon, color: Colors.white),
              const SizedBox(width: 10),
            ],
            Expanded(
              child: Text(
                message,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static void success(BuildContext context, String message) {
    _show(
      context,
      message,
      backgroundColor: Colors.green.shade600,
      icon: Icons.check_circle_outline,
    );
  }

  static void error(BuildContext context, String message) {
    _show(
      context,
      message,
      backgroundColor: Colors.red.shade700,
      icon: Icons.error_outline,
    );
  }

  static void info(BuildContext context, String message) {
    _show(
      context,
      message,
      backgroundColor: Colors.orange.shade700,
      icon: Icons.info_outline,
    );
  }

  static void showSnackBar(BuildContext context, String message) {
    _show(
      context,
      message,
      backgroundColor: Colors.grey.shade800,
      icon: Icons.notifications_active_outlined,
    );
  }
}
