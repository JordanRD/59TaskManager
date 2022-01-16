import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:limasembilan_todo_app/models/user_model.dart';
import 'package:limasembilan_todo_app/services/firebase_instances.dart';

class UserController extends GetxController {
  CollectionReference userInstance = FirebaseInstance().users;
  RxList<UserModel> users = <UserModel>[].obs;
  StreamSubscription<QuerySnapshot<Object?>>? subs;
  @override
  void onReady() {
    getAllUser();
    super.onReady();
  }

  @override
  void onClose() {
    subs?.cancel();
    super.onClose();
  }

  getAllUser() {
    subs?.cancel();
    userInstance.snapshots().listen((QuerySnapshot<Object?> qShot) {
      users.value =
          qShot.docs.map((e) => UserModel.fromDocumentSnapshot(e)).toList();
      update();
    });
  }
}
