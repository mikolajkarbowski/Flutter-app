import 'package:flutter/material.dart';

class SnackBarUtils {
  static void showSnackBar(BuildContext context, String message,
      {Duration duration = const Duration(seconds: 3),}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: duration,
      ),
    );
  }

  static void showSuccessSnackBar(BuildContext context, String message,
      {Duration duration = const Duration(seconds: 3),}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.green),
            const SizedBox(width: 10),
            Expanded(child: Text(message)),
          ],
        ),
        duration: duration,
      ),
    );
  }

  static void showErrorSnackBar(BuildContext context, String message,
      {Duration duration = const Duration(seconds: 3),}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error, color: Colors.red),
            const SizedBox(width: 10),
            Expanded(child: Text(message)),
          ],
        ),
        duration: duration,
      ),
    );
  }
}
