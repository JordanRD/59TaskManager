import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:limasembilan_todo_app/controller/user_controller.dart';
import 'package:limasembilan_todo_app/models/project_model.dart';
import 'package:limasembilan_todo_app/models/user_model.dart';
import 'package:limasembilan_todo_app/routes/app_route.dart';
import 'package:limasembilan_todo_app/services/firebase_instances.dart';
import 'package:limasembilan_todo_app/services/user_services.dart';
import 'package:limasembilan_todo_app/shared/alerts.dart';
import 'package:limasembilan_todo_app/shared/app_theme.dart';
import 'package:limasembilan_todo_app/shared/constants.dart';
import 'package:limasembilan_todo_app/widgets/dialog_confirm.dart';

class UserDetailPageController extends GetxController {
  final currentUser = UserModel().obs;
  final userInstance = FirebaseInstance().users;
  final projectInstance = FirebaseInstance().projects;
  final contributedProjects = <ProjectModel>[].obs;
  final selectedRole = Role.project.obs;
  final usernameController = TextEditingController();
  StreamSubscription<DocumentSnapshot<Object?>>? subs1;
  StreamSubscription<QuerySnapshot<Object?>>? subs2;
  @override
  void onReady() {
    final userId = Get.parameters['userId'];
    subs1?.cancel();
    if (userId?.isNotEmpty ?? false) {
      subs1 = userInstance.doc(userId).snapshots().listen((event) {
        if (event.exists) {
          currentUser.value = UserModel.fromDocumentSnapshot(event);
        } else {
          subs1?.cancel();
          currentUser.value = UserModel();
          Get.back();
          showAlert('Alert', 'User not found!', AppColor.text);
        }
        update();
      });
    } else {
      Get.back();
    }
    ever(currentUser, (UserModel user) {
      subs2?.cancel();
      if (user.userId?.isNotEmpty ?? false) {
        subs2 = projectInstance
            .where('contributors', arrayContains: user.userId)
            .snapshots()
            .listen((event) {
          contributedProjects.value = event.docs
              .map((e) => ProjectModel.fromDocumentSnapshot(e))
              .toList();
          update();
        });
      } else {
        contributedProjects.value = [];
      }
    });
    super.onReady();
  }

  @override
  void onClose() {
    subs1?.cancel();
    subs2?.cancel();
    super.onClose();
  }

  deleteUser() {
    Get.back();
    DialogConfirm.show(
      'Delete ${currentUser.value.username} ?',
      onConfirm: () {
        final userService = UserServices();
        userService.deleteUser(currentUser.value.userId ?? '');
        Get.back();
      },
    );
  }

  updateUser() async {
    String newUsername = usernameController.text.trim();
    String newRole = selectedRole.value;
    Map<String, dynamic> updatingData = {};
    if (newUsername.isEmpty) {
      showAlert('Alert', 'Username can not be empty!', AppColor.textDanger);
      return;
    }
    if (newUsername != currentUser.value.username) {
      final userC = Get.find<UserController>();
      if (userC.users.any((user) => user.username == newUsername)) {
        showAlert('Alert', 'Username already exist!', AppColor.textDanger);
        return;
      }
      updatingData['username'] = newUsername;
    }
    if (newRole.isNotEmpty && newRole != currentUser.value.role) {
      updatingData['role'] = newRole;
    }
    final userService = UserServices();
    if (currentUser.value.userId != null) {
      final res =
          await userService.updateUser(currentUser.value.userId!, updatingData);
      if (res) {
        Get.back();
        showAlert('Success', 'User Updated!', AppColor.text);
      } else {
        showAlert('Fail', 'Update Failed!', AppColor.textDanger);
      }
    }
  }
}
