import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:limasembilan_todo_app/models/task_model.dart';
import 'package:limasembilan_todo_app/services/firebase_instances.dart';

class TaskServices {
  CollectionReference projectInstance = FirebaseInstance().projects;
  Future<String?> addTask(String projectId, TaskModel task) async {
    try {
      final resp = await projectInstance
          .doc(projectId)
          .collection('tasks')
          .add(task.toMap());
      return resp.id;
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<bool> updateTask(
    String projectId,
    String taskId,
    Map<String, dynamic> updatedData,
  ) async {
    try {
      await projectInstance
          .doc(projectId)
          .collection('tasks')
          .doc(taskId)
          .update(updatedData);
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  deleteTask(String projectId, String taskId) async {
    try {
      await projectInstance
          .doc(projectId)
          .collection('tasks')
          .doc(taskId)
          .delete();
      return true;
    } catch (e) {
      return false;
    }
  }
}
