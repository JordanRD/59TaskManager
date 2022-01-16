import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:limasembilan_todo_app/controller/auth_controller.dart';
import 'package:limasembilan_todo_app/controller/project_detail_page_controller.dart';
import 'package:limasembilan_todo_app/models/sub_task_model.dart';
import 'package:limasembilan_todo_app/models/task_model.dart';
import 'package:limasembilan_todo_app/services/firebase_instances.dart';
import 'package:limasembilan_todo_app/services/task_services.dart';
import 'package:limasembilan_todo_app/shared/alerts.dart';
import 'package:limasembilan_todo_app/shared/app_theme.dart';
import 'package:uuid/uuid.dart';

const uuid = Uuid();

class TaskDetailController extends GetxController {
  final projectInstance = FirebaseInstance().projects;
  final selectedTask = TaskModel().obs;
  final projectC = Get.find<ProjectDetailController>();
  final userC = Get.find<AuthController>();
  final loading = false.obs;
  final subTaskController = TextEditingController();
  final newDesc = TextEditingController();
  final newDueDate = DateTime.now().millisecondsSinceEpoch.obs;
  final newTitle = TextEditingController();
  final isDeleteSubTask = false.obs;
  StreamSubscription<DocumentSnapshot<Map<String, dynamic>>>? subs;

  void toggleCompleteSubTask(SubTaskModel subTask) async {
    // subTask.isCompleted = !subTask.isCompleted;
    if (loading.value) return;
    loading.value = true;
    final taskService = TaskServices();
    Map<String, dynamic> updatedData = {
      'sub_task': selectedTask.value.subTask.map((data) {
        if (data.subTaskId == subTask.subTaskId) {
          final newSubTask = SubTaskModel(
            subTask.subTaskId,
            subTask.title,
            !subTask.isCompleted,
            subTask.isCompleted
                ? ''
                : userC.loggedUser.value.username ?? 'Unknown',
          );
          return newSubTask.toMap();
        }
        return data.toMap();
      }).toList()
    };
    final isSuccess = await taskService.updateTask(
      projectC.currentProject.value.projectId!,
      selectedTask.value.taskId,
      updatedData,
    );
    if (!isSuccess) {
      showAlert('Failed', 'Update task failed!', AppColor.textDanger);
    }
    loading.value = false;
    update();
  }

  @override
  void onClose() {
    subs?.cancel();
    super.onClose();
  }

  @override
  void onReady() {
    if (projectC.currentProject.value.projectId != null &&
        Get.parameters['taskId'] != null) {
      subs?.cancel();
      subs = projectInstance
          .doc(projectC.currentProject.value.projectId)
          .collection('tasks')
          .doc(Get.parameters['taskId'])
          .snapshots()
          .listen((event) {
        if (event.exists) {
          selectedTask.value = TaskModel.fromDocumentSnapshot(event);
        } else {
          if (selectedTask.value.taskId.isNotEmpty) {
            selectedTask.value = TaskModel();
            // Get.until((_) {
            //   return !(Get.isDialogOpen ?? false);
            // });
            Get.back(closeOverlays: true);
            showAlert('Alert', 'Someone has deleted this task!', AppColor.text);
          }
        }
        update();
      });
    } else {
      subs?.cancel();
    }
    super.onReady();
  }

  void onCompleteTaskButtonClick() async {
    // subTask.isCompleted = !subTask.isCompleted;
    if (loading.value) return;
    loading.value = true;
    final taskService = TaskServices();
    bool isCompleted = !selectedTask.value.isCompleted;
    Map<String, dynamic> updatedData = {
      'is_completed': isCompleted,
      'completed_by': isCompleted ? userC.loggedUser.value.username : '',
      'completed_date':
          isCompleted ? DateTime.now().millisecondsSinceEpoch : null,
    };
    final isSuccess = await taskService.updateTask(
      projectC.currentProject.value.projectId!,
      selectedTask.value.taskId,
      updatedData,
    );
    if (!isSuccess) {
      showAlert('Failed', 'Update task failed!', AppColor.textDanger);
    }
    loading.value = false;
    update();
  }

  void onClickDeleteTask() async {
    if (loading.value) return;
    loading.value = true;
    final taskService = TaskServices();
    final isSuccess = await taskService.deleteTask(
      projectC.currentProject.value.projectId!,
      selectedTask.value.taskId,
    );
    if (!isSuccess) {
      showAlert('Failed', 'Delete task failed!', AppColor.textDanger);
    }
    loading.value = false;
    update();
  }

  void onClickAddSubTask() async {
    final title = subTaskController.text.trim();
    if (title.isEmpty) {
      Get.back();
      return;
    }
    if (loading.value) return;
    loading.value = true;
    final taskService = TaskServices();
    Map<String, dynamic> updatedData = {
      'sub_task': [
        ...selectedTask.value.subTask.map((data) {
          return data.toMap();
        }).toList(),
        SubTaskModel(uuid.v1(), title, false, '').toMap()
      ]
    };
    final isSuccess = await taskService.updateTask(
      projectC.currentProject.value.projectId!,
      selectedTask.value.taskId,
      updatedData,
    );
    if (!isSuccess) {
      showAlert('Failed', 'Add task failed!', AppColor.textDanger);
    } else {
      subTaskController.text = '';
      Get.back();
    }
    loading.value = false;
    update();
  }

  void updateTask() async {
    final title = newTitle.text.trim();
    final description = newDesc.text.trim();
    final dueDate = newDueDate.value;
    Map<String, dynamic> updatingData = {};
    if (title.isEmpty) {
      showAlert('Alert', 'title can not be empty!', AppColor.textDanger);
      return;
    }
    if (dueDate.isNegative) {
      showAlert('Alert', 'invalid date!', AppColor.textDanger);
      return;
    }
    if (title != selectedTask.value.title) {
      updatingData['title'] = title;
    }
    if (description != selectedTask.value.description) {
      updatingData['description'] = description;
    }
    if (dueDate != selectedTask.value.dueDate) {
      updatingData['due_date'] = dueDate;
    }
    if (updatingData.isNotEmpty) {
      final taskService = TaskServices();
      bool isSuccess = await taskService.updateTask(
        projectC.currentProject.value.projectId!,
        selectedTask.value.taskId,
        updatingData,
      );
      if (isSuccess) {
        Get.back();
      } else {
        showAlert('Failed', 'Update task failed!', AppColor.textDanger);
      }
    } else {
      Get.back();
    }
  }

  void deleteSubTask(SubTaskModel subTask) async {
    // subTask.isCompleted = !subTask.isCompleted;
    if (loading.value) return;
    loading.value = true;
    final taskService = TaskServices();
    final filteredSubTask = <Map<dynamic, dynamic>>[];
    for (var sub in selectedTask.value.subTask) {
      if (sub.subTaskId != subTask.subTaskId) {
        filteredSubTask.add(sub.toMap());
      }
    }
    Map<String, dynamic> updatedData = {'sub_task': filteredSubTask};
    final isSuccess = await taskService.updateTask(
      projectC.currentProject.value.projectId!,
      selectedTask.value.taskId,
      updatedData,
    );
    if (!isSuccess) {
      showAlert('Failed', 'Delete todo failed!', AppColor.textDanger);
    } else if (filteredSubTask.isEmpty) {
      isDeleteSubTask.value = false;
    }

    loading.value = false;
    update();
  }
}
