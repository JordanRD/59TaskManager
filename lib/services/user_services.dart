import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:limasembilan_todo_app/models/task_model.dart';
import 'package:limasembilan_todo_app/models/user_model.dart';
import 'package:limasembilan_todo_app/services/firebase_instances.dart';

class UserServices {
  CollectionReference userInstance = FirebaseInstance().users;
  Future<String?> addUser(UserModel user) async {
    try {
      final resp = await userInstance.add(user.toMap());
      return resp.id;
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<bool> updateUser(
    String userId,
    Map<String, dynamic> updatedData,
  ) async {
    try {
      await userInstance.doc(userId).update(updatedData);
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  deleteUser(String userId) async {
    try {
      await userInstance.doc(userId).delete();
      return true;
    } catch (e) {
      return false;
    }
  }
}
