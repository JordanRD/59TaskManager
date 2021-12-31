import 'package:flutter/material.dart';
import 'package:get/get.dart';

showAlert(String title, String message, Color color) {
  Get.snackbar(
    title,
    message,
    backgroundColor: Colors.white,
    snackPosition: SnackPosition.BOTTOM,
    margin: const EdgeInsets.all(15),
    colorText: color,
  );
}
