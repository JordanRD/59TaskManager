import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:limasembilan_todo_app/controller/login_controller.dart';
import 'package:limasembilan_todo_app/shared/app_theme.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    LoginController loginC = Get.put(LoginController());
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height - 100,
          padding:
              const EdgeInsets.only(left: 30, right: 30, top: 60, bottom: 30),
          child: Center(
              child: Obx(() => Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Login',
                        style: TextStyle(
                          fontSize: TextSize.heading1,
                        ),
                      ),
                      const SizedBox(height: 30),
                      _buildTextField(
                        context,
                        icon: const Icon(Icons.person_outline),
                        hintText: 'username',
                        controller: loginC.usernameInput,
                        isError: loginC.usernameErr.value,
                      ),
                      const SizedBox(height: 15),
                      _buildTextField(
                        context,
                        icon: const Icon(Icons.lock_outline),
                        hintText: '4 digit kode',
                        controller: loginC.uniqKeyInput,
                        keyboardType: TextInputType.number,
                        isError: loginC.uniqKeyErr.value,
                        maxLength: 4,
                      ),
                      const SizedBox(height: 15),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            loginC.errMsg.value,
                            style: TextStyle(color: AppColor.textDanger),
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),
                      loginC.loading.value
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CircularProgressIndicator(
                                  color: Theme.of(context).primaryColor,
                                ),
                              ],
                            )
                          : _buildLoginButton(context,
                              onTap: loginC.onTapLogin),
                    ],
                  ))),
        ),
      ),
    );
  }

  InkWell _buildLoginButton(BuildContext context, {void Function()? onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(15),
      child: Ink(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          borderRadius: BorderRadius.circular(15),
        ),
        child: const Center(
          child: Text(
            'Login',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  TextField _buildTextField(BuildContext context,
      {required Icon icon,
      required String hintText,
      required TextEditingController controller,
      TextInputType? keyboardType,
      required bool isError,
      int? maxLength}) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType ?? TextInputType.text,
      textInputAction: TextInputAction.next,
      maxLength: maxLength,
      decoration: InputDecoration(
        counterStyle: const TextStyle(
          height: double.minPositive,
        ),
        counterText: "",
        prefixIcon: icon,
        contentPadding: const EdgeInsets.all(15),
        hintText: hintText,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(
            color: isError ? AppColor.textDanger : Colors.grey,
            width: 2,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(
            color:
                isError ? AppColor.textDanger : Theme.of(context).primaryColor,
            width: 2,
          ),
        ),
      ),
    );
  }
}
