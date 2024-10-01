import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DialogHelper {
  // Show error dialog
  static void showErrorDialog({
    String title = 'Error',
    String? description = 'Something went wrong',
    String buttonText = 'Okay',
  }) {
    Get.dialog(
      Dialog(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                style: Get.textTheme.headlineMedium,
              ),
              Text(
                description ?? '',
                style: Get.textTheme.titleLarge,
              ),
              ElevatedButton(
                onPressed: () {
                  if (Get.isDialogOpen!) Get.back();
                },
                child: Text(buttonText),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Show loading
  static void showLoading([String? message, Color? spinnerColor]) {
    Get.dialog(
      Dialog(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(
                color: spinnerColor ?? Get.theme.primaryColor,
              ),
              const SizedBox(height: 8),
              Text(message ?? 'Loading...'),
            ],
          ),
        ),
      ),
    );
  }

  // Hide loading
  static void hideLoading() {
    if (Get.isDialogOpen!) Get.back();
  }

  // Show snackbar
  static void showSnackBar(String message, {String title = 'Info'}) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.black.withOpacity(0.5),
      colorText: Colors.white,
      icon: const Icon(Icons.info, color: Colors.white),
    );
  }
}
