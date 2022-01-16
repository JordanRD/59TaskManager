import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:limasembilan_todo_app/models/project_model.dart';
import 'package:limasembilan_todo_app/services/firebase_instances.dart';

class ProjectServices {
  CollectionReference projectInstance = FirebaseInstance().projects;
  Future<String?> addProject(ProjectModel project) async {
    try {
      final resp = await projectInstance.add(project.toMap());
      return resp.id;
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<bool> updateProject(
    String projectId,
    Map<String, dynamic> updatedData,
  ) async {
    try {
      await projectInstance.doc(projectId).update(updatedData);
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  deleteProject(String projectId) async {
    try {
      await projectInstance.doc(projectId).delete();
      return true;
    } catch (e) {
      return false;
    }
  }
}
