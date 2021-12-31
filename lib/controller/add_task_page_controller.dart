import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class AddTaskController extends GetxController {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  Rx<DateTime> dueDate = DateTime.now().obs;
  
}
