import 'package:flutter/material.dart';
import 'package:get/get.dart';

enum SnackType { success, warning, error }

class SnackbarHelper {
  // Main function to show snackbar
  static void show({
    required String title,
    required String message,
    required SnackType type,
  }) {
    // Determine color based on type
    Color backgroundColor;
    switch (type) {
      case SnackType.success:
        backgroundColor = Colors.green.withValues(alpha: 0.7);
        break;
      case SnackType.warning:
        backgroundColor = Colors.orange.withValues(alpha: 0.7);
        break;
      case SnackType.error:
        backgroundColor = Colors.red.withValues(alpha: 0.7);
        break;
    }

    // Show GetX snackbar
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: backgroundColor,
      colorText: Colors.white,
      duration: Duration(seconds: 2),
      margin: EdgeInsets.all(10),
      borderRadius: 8,
      icon: Icon(_getIcon(type), color: Colors.white),
    );
  }

  // Optional: pick icon for each type
  static IconData _getIcon(SnackType type) {
    switch (type) {
      case SnackType.success:
        return Icons.check_circle_outline;
      case SnackType.warning:
        return Icons.warning_amber_outlined;
      case SnackType.error:
        return Icons.error_outline;
    }
  }
}
