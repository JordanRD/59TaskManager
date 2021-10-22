import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:limasembilan_todo_app/models/task_model.dart';
import 'package:limasembilan_todo_app/storages.dart';

class TaskController extends GetxController {
  CollectionReference projects =
      FirebaseFirestore.instance.collection('projects');
  final ProjectStorage _storage = ProjectStorage();

  DocumentReference getCurrentProject() {
    String? projectId = _storage.getProjectId();
    var project = projects.doc(projectId);
    return project;
  }

  getTaskByID(String id) async {
    String? projectId = _storage.getProjectId();
    var project =
        await projects.doc(projectId).collection('tasks').doc(id).get();
    return TaskModel.fromDocumentSnapshot(project);
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getCurrentTask() {
    String? projectId = ProjectStorage().getProjectId();
    return projects.doc(projectId).collection('tasks').snapshots();
  }

  Future<bool> deleteTask(String id) async {
    try {
      String? projectId = ProjectStorage().getProjectId();
      await projects.doc(projectId).collection('tasks').doc(id).delete();
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> updateTask(String id,
      {String? title,
      String? description,
      int? dueDate,
      bool? isCompleted}) async {
    try {
      Map<String, dynamic> input = {};
      if (title != null) input['title'] = title;
      if (description != null) input['description'] = description;
      if (dueDate != null) input['due_date'] = dueDate;
      if (isCompleted != null) input['is_completed'] = isCompleted;
      String? projectId = ProjectStorage().getProjectId();
      await projects.doc(projectId).collection('tasks').doc(id).update(input);
      return true;
    } catch (e) {
      return false;
    }
  }

  addTask(
      {required String title,
      String? description,
      required int dueDate}) async {
    try {
      String? projectId = ProjectStorage().getProjectId();
      await projects.doc(projectId).collection('tasks').add({
        'title': title,
        'due_date': dueDate,
        'description': description ?? '',
        'is_completed': false,
        'create_date': DateTime.now().millisecondsSinceEpoch,
      });
      return true;
    } catch (e) {
      return false;
    }
  }
}
