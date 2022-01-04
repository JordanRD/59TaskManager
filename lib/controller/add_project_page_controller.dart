import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:limasembilan_todo_app/controller/auth_controller.dart';
import 'package:limasembilan_todo_app/controller/project_controller.dart';
// import 'package:limasembilan_todo_app/services/device_storage.dart';
import 'package:limasembilan_todo_app/shared/alerts.dart';
import 'package:limasembilan_todo_app/shared/app_theme.dart';

class AddProjectPageController extends GetxController {
  final selectedContributors = <String>[].obs;
  final nameController = TextEditingController();
  @override
  void onReady() {
    AuthController authC = Get.find<AuthController>();
    selectedContributors.add(authC.loggedUser.value.userId!);
    ever(selectedContributors, (_) {
      update();
    });
    update();
    super.onReady();
  }

  addProject() async {
    String name = nameController.text;
    if (name.isEmpty) {
      showAlert('Alert', 'Title can\'t be empty', AppColor.textDanger);
    } else if (selectedContributors.isEmpty) {
      showAlert(
        'Alert',
        'A project should have at least 1 contributor',
        AppColor.textDanger,
      );
    } else {
      final projectController = Get.find<ProjectController>();
      String? projectId =
          await projectController.addProject(name, selectedContributors);
      if (projectId == null) {
        showAlert(
          'Error',
          'Create project failed',
          AppColor.textDanger,
        );
      } else {
        Get.back();
        showAlert('Success', 'New Project Added', AppColor.text);
      }
    }
    // DeviceStorage().box.remove('user_id');
  }
}
