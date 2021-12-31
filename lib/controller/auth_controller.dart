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
    print('masuk6');
    userInstance
        .doc(userId)
        .snapshots()
        .listen((DocumentSnapshot querySnapshot) {
      print('masuk7');
      if (querySnapshot.exists) {
        print('masuk8');
        loggedUser.value = UserModel.fromDocumentSnapshot(querySnapshot);
        loading.value = false;
        Get.offAllNamed(RouteNames.home);
      } else {
        print('hhhhh');
        loggedUser.value = UserModel();
        loading.value = false;
        Get.offAllNamed(RouteNames.login);
      }
    });
  }

  Future<UserModel?> getUserByUsername(String username) async {
    try {
      print('masuk login');
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
    print('masuk $userId');
    if (userId != null) {
      print('masuk1');
      _autoLogin(userId);
    } else {
      print('masuk4');
      loggedUser.value = UserModel();
      loading.value = false;
      Get.offAllNamed(RouteNames.login);
    }
    print('masuk2322');
    DeviceStorage().box.listenKey('user_id', (userId) {
      print('masuk2');
      if (userId != null) {
        print('masuk3');
        _autoLogin(userId);
      } else {
        print('masuk4');
        loggedUser.value = UserModel();
        loading.value = false;
        Get.offAllNamed(RouteNames.login);
      }
    });
    super.onReady();
  }
}
