import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:limasembilan_todo_app/controller/project_controller.dart';
import 'package:limasembilan_todo_app/models/project_model.dart';
import 'package:limasembilan_todo_app/models/task_model.dart';
import 'package:limasembilan_todo_app/services/firebase_instances.dart';
import 'package:limasembilan_todo_app/services/project_services.dart';
import 'package:limasembilan_todo_app/shared/alerts.dart';
import 'package:limasembilan_todo_app/shared/app_theme.dart';
import 'package:limasembilan_todo_app/widgets/dialog_confirm.dart';

enum ProjectDetailFilter { onProgress, done }

class ProjectDetailController extends GetxController {
  final currentProject = ProjectModel().obs;
  final projectInstance = FirebaseInstance().projects;
  final currentTask = <TaskModel>[].obs;
  final filteredTask = <TaskModel>[].obs;
  final filterBy = ProjectDetailFilter.onProgress.obs;
  final projectC = Get.find<ProjectController>();
  final projectNameController = TextEditingController();

  StreamSubscription<DocumentSnapshot<Object?>>? subs1;
  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? subs2;

  @override
  void onClose() {
    subs2?.cancel();
    subs1?.cancel();
    super.onClose();
  }

  @override
  void onInit() {
    subs1 = projectInstance
        .doc(Get.parameters['projectId'])
        .snapshots()
        .listen((event) {
      if (event.exists) {
        currentProject.value = ProjectModel.fromDocumentSnapshot(event);
      } else {
        currentProject.value = ProjectModel();
        subs1?.cancel();
        Get.back(closeOverlays: true);
      }
    });

    ever(currentProject, (ProjectModel currentProject) {
      subs2?.cancel();
      if (currentProject.projectId != null) {
        subs2 = projectInstance
            .doc(currentProject.projectId)
            .collection('tasks')
            .snapshots()
            .listen((event) {
          if (event.docs.isNotEmpty) {
            currentTask.value = event.docs
                .map((val) => TaskModel.fromDocumentSnapshot(val))
                .toList();
          } else {
            currentTask.value = [];
          }
          update();
        });
      }
    });

    everAll([currentTask, filterBy], (val) {
      // print('hehe');
      // print(filterBy.value);
      filteredTask.value = currentTask.where((task) {
        // print(task.subTask.every((subTask) => subTask.isCompleted));
        switch (filterBy.value) {
          case ProjectDetailFilter.onProgress:
            return !task.isCompleted;
          case ProjectDetailFilter.done:
            return task.isCompleted;
          default:
            return false;
        }
      }).toList()
        ..sort((a, b) => (a.dueDate ?? 0).compareTo(b.dueDate ?? 0));
      update();
    });
    super.onInit();
  }

  removeContributor(String userId) async {
    if (userId.isEmpty) {
      return;
    }
    final resp = await projectC.updateProject(currentProject.value.projectId!, {
      'contributors': [...currentProject.value.contributors!]
        ..removeWhere((element) => element == userId),
    });
    if (!resp) {
      showAlert('Alert', 'Update failed!', AppColor.textDanger);
    }
  }

  void addContributor(String userId) async {
    if (userId.isEmpty) {
      return;
    }
    final resp = await projectC.updateProject(currentProject.value.projectId!, {
      'contributors': [...currentProject.value.contributors!, userId]
    });
    if (!resp) {
      showAlert('Alert', 'Update failed!', AppColor.textDanger);
    }
  }

  deleteProject() {
    DialogConfirm.show('Delete project ${currentProject.value.name}?',
        onConfirm: () async {
      final projectService = ProjectServices();
      final resp = await projectService
          .deleteProject(currentProject.value.projectId ?? '');
      if (resp) {
        Get.back(closeOverlays: true);
      } else {
        showAlert('Alert', 'Delete project failed!', AppColor.textDanger);
      }
    });
  }

  updateProject() async {
    String newProjectName = projectNameController.text.trim();
    if (newProjectName.isEmpty) {
      showAlert('Alert', 'Project name can not be empty!', AppColor.textDanger);
      return;
    }
    if (newProjectName == currentProject.value.name) {
      Get.back(closeOverlays: true);
      return;
    }
    final projectService = ProjectServices();
    final resp = await projectService.updateProject(
        currentProject.value.projectId ?? '', {'name': newProjectName});
    if (resp) {
      Get.back(closeOverlays: true);
      showAlert('Success', 'Update project success!', AppColor.text);
    } else {
      showAlert('Alert', 'Update project failed!', AppColor.textDanger);
    }
  }
}
