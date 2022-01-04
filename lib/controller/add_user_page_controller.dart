import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:limasembilan_todo_app/controller/user_controller.dart';
import 'package:limasembilan_todo_app/models/user_model.dart';
import 'package:limasembilan_todo_app/services/user_services.dart';
import 'package:limasembilan_todo_app/shared/alerts.dart';
import 'package:limasembilan_todo_app/shared/app_theme.dart';
import 'package:limasembilan_todo_app/shared/constants.dart';

class AddUserPageController extends GetxController {
  final nameController = TextEditingController();
  final roleInList = [Role.support, Role.project, Role.admin];
  final selectedRole = Role.project.obs;
  final userC = Get.find<UserController>();
  void addUser() async {
    final username = nameController.text.trim();
    final role = selectedRole.value;
    if (username.isEmpty) {
      showAlert('Alert', 'Username is empty', AppColor.textDanger);
      return;
    }
    if (role.isEmpty) {
      showAlert('Alert', 'Select Role', AppColor.textDanger);
      return;
    }
    if (userC.users.any((user) => user.username == username)) {
      showAlert('Alert', 'Username already exist', AppColor.textDanger);
      return;
    }
    final userServices = UserServices();
    final uniqKey = (1000 + Random().nextInt(8000)).toString();

    final resp = await userServices.addUser(UserModel(
      userId: '',
      uniqKey: uniqKey,
      username: username,
      role: role,
    ));
    if (resp == null) {
      showAlert('Failed', 'Add User Failed', AppColor.textDanger);
    } else {
      Get.back(closeOverlays: true);
      showAlert('Success', 'User Added', AppColor.text);
    }
  }
}
