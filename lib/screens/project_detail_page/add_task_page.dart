import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddTaskPage extends StatelessWidget {
  const AddTaskPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder(
        builder: (controller) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(30),
            child: Column(
              children: [
                Text('blablabla'),
              ],
            ),
          );
        }
      ),
    );
  }
}
