import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:limasembilan_todo_app/models/user_model.dart';
import 'package:limasembilan_todo_app/routes/app_route.dart';
import 'package:limasembilan_todo_app/services/device_storage.dart';
import 'package:limasembilan_todo_app/services/firebase_instances.dart';

class AuthController extends GetxController {
  CollectionReference userInstance = FirebaseInstance().users;
  Rx<UserModel> loggedUser = UserModel().obs;
  RxBool loading = true.obs;

  _autoLogin(String userId) {
    userInstance
        .doc(userId)
        .snapshots()
        .listen((DocumentSnapshot querySnapshot) {
      if (querySnapshot.exists) {
        loggedUser.value = UserModel.fromDocumentSnapshot(querySnapshot);
        loading.value = false;
      } else {
        loggedUser.value = UserModel();
        loading.value = false;
        Get.toNamed(RouteNames.login);
      }
    });
  }

  Future<UserModel?> getUserByUsername(String username) async {
    try {
      var response =
          await userInstance.where('username', isEqualTo: username).get();
      var userData = response.docs.first;
      return UserModel.fromDocumentSnapshot(userData);
    } catch (e) {
      return null;
    }
  }

  @override
  void onReady() {
    var userId = DeviceStorage().box.read('user_id');
    if (userId != null) {
      _autoLogin(userId);
    }
    DeviceStorage().box.listenKey('user_id', (userId) {
      if (userId != null) {
        _autoLogin(userId);
      } else {
        loggedUser.value = UserModel();
        loading.value = false;
        Get.toNamed(RouteNames.login);
      }
    });
    super.onReady();
  }
}
