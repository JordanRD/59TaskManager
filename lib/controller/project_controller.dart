import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:limasembilan_todo_app/controller/auth_controller.dart';
import 'package:limasembilan_todo_app/models/project_model.dart';
import 'package:limasembilan_todo_app/models/user_model.dart';
import 'package:limasembilan_todo_app/services/firebase_instances.dart';
import 'package:limasembilan_todo_app/shared/constants.dart';

class ProjectController extends GetxController {
  CollectionReference projectInstance = FirebaseInstance().projects;
  RxList<ProjectModel> projects = <ProjectModel>[].obs;
  AuthController authC = Get.find<AuthController>();
  StreamSubscription<QuerySnapshot<Object?>>? subs;
  Future<bool> updateProject(
      String projectId, Map<String, dynamic> updatingData) async {
    try {
      await projectInstance.doc(projectId).update(updatingData);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<String?> addProject(String name, List<String> contributors) async {
    try {
      var response = await projectInstance
          .add({'name': name, 'contributors': contributors,'create_by':authC.loggedUser.value.userId});
      return response.id;
    } catch (e) {
      return null;
    }
  }

  _getUsersProject(UserModel user) {
    print(user);
    subs?.cancel();
    if (user.role == Role.admin) {
      subs = projectInstance.snapshots().listen((QuerySnapshot querySnapshot) {
        print('project change detected');
        // print(querySnapshot.docs.length);
        List<ProjectModel> arr = [];
        print('ininiinin ${user.role}');
        if (user.role == Role.admin) {
          for (var e in querySnapshot.docs) {
            print('loop');
            arr.add(ProjectModel.fromDocumentSnapshot(e));
            print('loop1');
          }
        }
        projects.value = arr;
      });
    } else {
      subs = projectInstance
          .where('contributors', arrayContains: user.userId)
          .snapshots()
          .listen((QuerySnapshot querySnapshot) {
        projects.value = querySnapshot.docs
            .map((e) => ProjectModel.fromDocumentSnapshot(e))
            .toList();
      });
    }
  }

  @override
  void onReady() {
    print('deimdkddr');
    // subs?.cancel();
    _getUsersProject(authC.loggedUser.value);
    ever(authC.loggedUser, (UserModel user) {
      print('user changeee');
      // subs?.cancel();
      _getUsersProject(authC.loggedUser.value);
    });
    super.onReady();
  }
}
