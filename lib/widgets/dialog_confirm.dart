import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class DialogConfirm {
  static show(String title,
      {required void Function() onConfirm, required BuildContext context}) {
    HapticFeedback.heavyImpact();
    Get.defaultDialog(
      title: '',
      titleStyle: const TextStyle(fontSize: 0),
      content: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      textConfirm: 'Ya',
      buttonColor: Theme.of(context).primaryColor,
      onConfirm: onConfirm,
      textCancel: 'Tidak',
      cancelTextColor: Theme.of(context).primaryColor,
    );
  }
}
