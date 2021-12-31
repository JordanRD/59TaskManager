import 'package:get/get.dart';
import 'package:limasembilan_todo_app/models/project_model.dart';
import 'package:limasembilan_todo_app/models/task_model.dart';
import 'package:limasembilan_todo_app/services/firebase_instances.dart';

enum ProjectDetailFilter { onProgress, done }

class ProjectDetailController extends GetxController {
  final currentProject = ProjectModel().obs;
  final projectInstance = FirebaseInstance().projects;
  final currentTask = <TaskModel>[].obs;
  final filteredTask = <TaskModel>[].obs;
  final filterBy = ProjectDetailFilter.onProgress.obs;
  @override
  void onInit() {
    projectInstance
        .doc(Get.parameters['projectId'])
        .snapshots()
        .listen((event) {
      if (event.exists) {
        currentProject.value = ProjectModel.fromDocumentSnapshot(event);
      } else {
        currentProject.value = ProjectModel();
      }
    });

    ever(currentProject, (ProjectModel currentProject) {
      if (currentProject.projectId != null) {
        projectInstance
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
      print('hehe');
      print(filterBy.value);
      filteredTask.value = currentTask.where((task) {
        print(task.subTask.every((subTask) => subTask.isCompleted));
        switch (filterBy.value) {
          case ProjectDetailFilter.onProgress:
            return task.subTask.isEmpty ||
                task.subTask.any((subTask) => !subTask.isCompleted);
          case ProjectDetailFilter.done:
            return task.subTask.isNotEmpty &&
                task.subTask.every((subTask) => subTask.isCompleted);
          default:
            return false;
        }
      }).toList()
        ..sort((a, b) => (a.dueDate ?? 0).compareTo(b.dueDate ?? 0));
      update();
    });
    super.onInit();
  }
}
