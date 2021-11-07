import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:limasembilan_todo_app/controller/add_project_page_controller.dart';
import 'package:limasembilan_todo_app/controller/user_controller.dart';
import 'package:limasembilan_todo_app/models/user_model.dart';

class AddProjectPage extends StatelessWidget {
  const AddProjectPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    AddProjectPageController addProjectC = Get.put(AddProjectPageController());
    UserController userC = Get.find<UserController>();
    return Scaffold(
      body: SingleChildScrollView(child: Obx(() {
        return Container(
          color: Colors.cyan,
          width: MediaQuery.of(context).size.width,
          constraints:
              BoxConstraints(minHeight: MediaQuery.of(context).size.height),
          padding:
              const EdgeInsets.only(left: 30, right: 30, top: 60, bottom: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Add Project'),
              const SizedBox(height: 30),
              Container(
                alignment: Alignment.center,
                child: Stack(
                  children: [
                    Image.file(
                      File(addProjectC.imageFile.value.path),
                      width: 150,
                      key: ValueKey(addProjectC.imageFile.value.path),
                      height: 150,
                      fit: BoxFit.cover,
                      errorBuilder: (BuildContext context, Object exception,
                          StackTrace? stackTrace) {
                        return const Text('Your error widget...');
                      },
                    ),
                    InkWell(
                      onTap: () async {
                        final ImagePicker picker = ImagePicker();
                        XFile? imageFile =
                            await picker.pickImage(source: ImageSource.gallery);
                        if (imageFile != null) {
                          addProjectC.imageFile.value = imageFile;
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: const Icon(Icons.add, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
              const TextField(
                decoration: InputDecoration(
                  hintText: 'title',
                ),
              ),
              const SizedBox(height: 30),
              const Text('Add Contributor'),
              ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: userC.users.length,
                  itemBuilder: (context, idx) {
                    UserModel user = userC.users[idx];
                    return Container(
                      margin: const EdgeInsets.only(left: 5),
                      color: Colors.red,
                      child: Text(user.username!),
                    );
                  })
            ],
          ),
        );
      })),
    );
  }
}
