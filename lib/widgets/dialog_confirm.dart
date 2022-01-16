import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:limasembilan_todo_app/shared/app_theme.dart';

class DialogConfirm {
  static show(String title,
      {required void Function() onConfirm}) {
    HapticFeedback.heavyImpact();
    Get.defaultDialog(
      title: '',
      titleStyle: const TextStyle(fontSize: 0),
      content: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      textConfirm: 'Ya',
      buttonColor: AppColor.primaryColor,
      onConfirm: onConfirm,
      textCancel: 'Tidak',
      cancelTextColor: AppColor.primaryColor,
    );
  }
}
