import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:limasembilan_todo_app/controller/add_user_page_controller.dart';
import 'package:limasembilan_todo_app/shared/app_theme.dart';

class AddUserPage extends StatelessWidget {
  const AddUserPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    Get.put(AddUserPageController());
    return GetBuilder<AddUserPageController>(
        builder: (AddUserPageController controller) {
      return Scaffold(
        body: SingleChildScrollView(
          child: Container(
            // color: Colors.cyan,
            width: MediaQuery.of(context).size.width,
            constraints:
                BoxConstraints(minHeight: MediaQuery.of(context).size.height),
            padding:
                const EdgeInsets.only(left: 30, right: 30, top: 60, bottom: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'New User',
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontSize: TextSize.heading2,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 30),
                // const SizedBox(height: 15),
                const Text('Username'),
                TextField(
                  controller: controller.nameController,
                  decoration: const InputDecoration(
                    hintText: 'username',
                  ),
                ),
                const SizedBox(height: 30),
                const Text('Select Role'),
                const SizedBox(height: 15),
                SizedBox(
                  height: 30,
                  child: Row(
                    children: [
                      Expanded(
                        child: OverflowBox(
                          maxWidth: MediaQuery.of(context).size.width,
                          child: ListView.builder(
                            padding: const EdgeInsets.symmetric(horizontal: 30),
                            scrollDirection: Axis.horizontal,
                            itemCount: controller.roleInList.length,
                            itemBuilder: (context, idx) {
                              String role = controller.roleInList[idx];
                              bool isSelected =
                                  controller.selectedRole.value == role;
                              Color backgroundColor = isSelected
                                  ? Theme.of(context).primaryColor
                                  : Colors.white;
                              Color fontColor = isSelected
                                  ? Colors.white
                                  : Theme.of(context).primaryColor;

                              return Container(
                                key: ValueKey(role),
                                margin: const EdgeInsets.only(right: 10),
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(15),
                                  onTap: () {
                                    if (!isSelected) {
                                      controller.selectedRole.value = role;
                                      controller.update();
                                    }
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: backgroundColor,
                                      borderRadius: BorderRadius.circular(15),
                                      boxShadow: [AppStyle.defaultShadow],
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 15, vertical: 0),
                                    child: Center(
                                        child: Text(
                                      role,
                                      style: TextStyle(color: fontColor),
                                    )),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                InkWell(
                  onTap: controller.addUser,
                  child: Ink(
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 15,
                      vertical: 15,
                    ),
                    child: const Text(
                      'Create User',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
