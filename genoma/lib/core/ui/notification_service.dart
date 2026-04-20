import 'package:flutter/material.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final GlobalKey<ScaffoldMessengerState> messengerKey = GlobalKey<ScaffoldMessengerState>();

  void _show(String message, {bool error = false, Duration duration = const Duration(seconds: 3)}) {
    final snack = SnackBar(
      content: Text(message),
      backgroundColor: error ? Colors.redAccent : null,
      duration: duration,
    );
    messengerKey.currentState?.showSnackBar(snack);
  }

  void showSuccess(String message) => _show(message, error: false);
  void showInfo(String message) => _show(message, error: false);
  void showError(String message) => _show(message, error: true);
}
