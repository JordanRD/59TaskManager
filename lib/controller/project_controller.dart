import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/state_manager.dart';

class ProjectController extends GetxController {
  CollectionReference projects =
      FirebaseFirestore.instance.collection('projects');

  Stream<QuerySnapshot<Object?>> getAllProject() {
    return projects.snapshots();
  }

  Future<String?> addProject(String name) async {
    try {
      var result = await projects.add({'name': name});
      return result.id;
    } catch (e) {
      return null;
    }
  }

  Future<bool> deleteProject(String id) async {
    try {
      await projects.doc(id).delete();
      return true;
    } catch (e) {
      return false;
    }
  }
}
