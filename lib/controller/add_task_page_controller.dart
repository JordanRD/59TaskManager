import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:limasembilan_todo_app/controller/project_detail_page_controller.dart';
import 'package:limasembilan_todo_app/models/sub_task_model.dart';
import 'package:limasembilan_todo_app/models/task_model.dart';
import 'package:limasembilan_todo_app/services/task_services.dart';
import 'package:limasembilan_todo_app/shared/alerts.dart';
import 'package:limasembilan_todo_app/shared/app_theme.dart';
import 'package:uuid/uuid.dart';

class AddTaskController extends GetxController {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final subTaskController = TextEditingController();
  Rx<DateTime> dueDate = DateTime.now().obs;
  final selectedDate = [true, false, false].obs;
  final subTasks = <SubTaskModel>[].obs;
  final isLoading = false.obs;

  void onClickAddSubTask() {
    var uuid = const Uuid();
    String subTaskTitle = subTaskController.text.trim();
    if (subTaskTitle.isNotEmpty) {
      subTasks.addIf(
        subTasks.every((elm) => elm.title != subTaskTitle),
        SubTaskModel(uuid.v1(), subTaskTitle, false, ''),
      );
      subTaskController.text = '';
      update();
    }
  }

  @override
  void onClose() {
    titleController.dispose();
    descriptionController.dispose();
    subTaskController.dispose();
    super.onClose();
  }

  void removeSubTask(String subTaskId) {
    subTasks.removeWhere((element) => element.subTaskId == subTaskId);
    update();
  }

  void createTask() async {
    if (titleController.text.isEmpty) {
      showAlert('Alert', 'task name can not be empty', AppColor.textDanger);
      return;
    }

    final newTask = TaskModel(
        '',
        titleController.text.trim(),
        descriptionController.text.trim(),
        dueDate.value.millisecondsSinceEpoch,
        subTasks,
        DateTime.now().millisecondsSinceEpoch,
        false);
    final projectController = Get.find<ProjectDetailController>();
    final taskService = TaskServices();
    String? resp = await taskService.addTask(
        projectController.currentProject.value.projectId!, newTask);
    // print('ininini --->>>$resp');
    if (resp != null) {
      Get.back(closeOverlays: true);
      showAlert('Sucess', 'task created', AppColor.text);
    } else {
      showAlert('Fail', 'create task failed!\nplease try again later.',
          AppColor.textDanger);
    }
  }
}
