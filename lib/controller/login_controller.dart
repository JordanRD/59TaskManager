import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:limasembilan_todo_app/controller/auth_controller.dart';
import 'package:limasembilan_todo_app/models/user_model.dart';
import 'package:limasembilan_todo_app/services/device_storage.dart';

class LoginController extends GetxController {
  TextEditingController usernameInput = TextEditingController();
  TextEditingController uniqKeyInput = TextEditingController();
  RxString errMsg = ''.obs;
  RxBool loading = false.obs;
  RxBool usernameErr = false.obs;
  RxBool uniqKeyErr = false.obs;
  AuthController authC = Get.find<AuthController>();

  void onTapLogin() async {
    loading.value = true;
    usernameErr.value = false;
    uniqKeyErr.value = false;
    errMsg.value = '';
    var username = usernameInput.text;
    var uniqKey = uniqKeyInput.text;
    if (username.isEmpty) {
      usernameErr.value = true;
      errMsg.value = 'masukan username';
      loading.value = false;
    } else if (uniqKey.isEmpty) {
      uniqKeyErr.value = true;
      errMsg.value = 'masukan kode';
      loading.value = false;
    } else {
      UserModel? user = await authC.getUserByUsername(usernameInput.text);
      if (user == null) {
        usernameErr.value = true;
        errMsg.value = 'username tidak ditemukan';
        loading.value = false;
        return;
      }
      if (user.uniqKey != uniqKey) {
        uniqKeyErr.value = true;
        errMsg.value = 'kode salah';
        loading.value = false;
        return;
      }
      print('onTapLogin');
      DeviceStorage().box.write('user_id', user.userId);
      loading.value = false;
    }
  }
}
