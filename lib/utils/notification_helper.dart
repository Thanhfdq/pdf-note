import 'package:flutter/material.dart';

class NotificationHelper {
  static showNotification(BuildContext context, String text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(text)),
    );
  }
}
