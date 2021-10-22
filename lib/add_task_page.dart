import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:limasembilan_todo_app/app_theme.dart';
import 'package:limasembilan_todo_app/controller/task_controller.dart';

class AddTaskPage extends GetView<TaskController> {
  const AddTaskPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    Rx<DateTime> _dueDate = DateTime.now().obs;
    RxList<bool> _selectedDateButton = [true, false, false].obs;
    RxBool _showSpinner = false.obs;
    TextEditingController _titleController = TextEditingController();
    TextEditingController _descriptionController = TextEditingController();
    Future<void Function()?> _onSubmitTask() async {
      String title = _titleController.text;
      String description = _descriptionController.text;
      int dueDate = _dueDate.value.millisecondsSinceEpoch;
      _showSpinner.value = true;
      if (title.trim().isEmpty) {
        _showSpinner.value = false;
        return Get.defaultDialog(
          title: '',
          titleStyle: const TextStyle(fontSize: 0),
          content: const Text(
            'Masukan judul',
          ),
        );
      }
      controller
          .addTask(title: title, dueDate: dueDate, description: description)
          .then((isSuccess) {
        if (isSuccess) {
          Get.back();
        }
      });
    }

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Obx(() => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 60),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Tambah Task',
                        style: TextStyle(
                          fontSize: TextSize.heading2,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      Expanded(child: Container()),
                      IconButton(
                        iconSize: TextSize.heading3,
                        padding: const EdgeInsets.all(1),
                        onPressed: () {
                          Get.back();
                        },
                        icon: const Icon(
                          Icons.close,
                          color: AppColor.textSecondary,
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 30),
                  const Text(
                    'Judul',
                    style: TextStyle(
                      fontSize: TextSize.body3,
                      color: AppColor.textSecondary,
                    ),
                  ),
                  TextField(
                    controller: _titleController,
                    textInputAction: TextInputAction.next,
                    maxLength: 40,
                    decoration: const InputDecoration(
                      hintText: 'Meeting, Belanja...',
                    ),
                  ),
                  const SizedBox(height: 30),
                  const Text(
                    'Deskripsi',
                    style: TextStyle(
                      fontSize: TextSize.body3,
                      color: AppColor.textSecondary,
                    ),
                  ),
                  TextField(
                    maxLines: 15,
                    controller: _descriptionController,
                    maxLength: 1000,
                    decoration: const InputDecoration(
                      hintText: 'Pastikan semua berjalan dengan baik...',
                    ),
                  ),
                  const SizedBox(height: 30),
                  Row(
                    children: [
                      const Text(
                        'Tenggat Waktu',
                        style: TextStyle(
                          fontSize: TextSize.body3,
                          color: AppColor.textSecondary,
                        ),
                      ),
                      Expanded(child: Container()),
                      Text(
                        DateFormat.yMMMMd('id_ID').format(_dueDate.value),
                        style: const TextStyle(
                          fontSize: TextSize.body3,
                          color: AppColor.textSecondary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  SizedBox(
                    height: 50,
                    child: ToggleButtons(
                      // constraints:
                      //     const BoxConstraints(maxHeight: 50, minHeight: 50),
                      isSelected: _selectedDateButton,
                      onPressed: (int idx) async {
                        DateTime now = DateTime.now();
                        if (idx == 0) {
                          _dueDate.value = now;
                          _selectedDateButton.value = [true, false, false];
                        }
                        if (idx == 1) {
                          _dueDate.value = now.add(const Duration(days: 1));
                          _selectedDateButton.value = [false, true, false];
                        }
                        if (idx == 2) {
                          DateTime? selectedDate = await showDatePicker(
                            context: context,
                            initialDate: _dueDate.value,
                            firstDate: now,
                            lastDate: now.add(const Duration(days: 365 * 2)),
                          );

                          if (selectedDate != null) {
                            _dueDate.value = selectedDate;
                            _selectedDateButton.value = [false, false, true];
                          }
                        }
                      },
                      borderRadius: BorderRadius.circular(15),
                      borderColor: AppColor.textSecondary,
                      selectedColor: Theme.of(context).primaryColor,
                      selectedBorderColor: Theme.of(context).primaryColor,
                      fillColor: Colors.white,
                      color: AppColor.textSecondary,
                      children: const [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 15.0),
                          child: Text('Hari Ini'),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 15.0),
                          child: Text('Besok'),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 15.0),
                          child: Text('Custom'),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: _showSpinner.value ? null : _onSubmitTask,
                        highlightColor: Colors.transparent,
                        child: Ink(
                          height: 50,
                          child: const Text(
                            'Buat Task',
                            style: TextStyle(color: Colors.white),
                          ),
                          padding: const EdgeInsets.all(15),
                          // alignment: Alignment.center,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: Theme.of(context).primaryColor,
                            boxShadow: [AppStyle.defaultShadow],
                          ),
                        ),
                      ),
                      _showSpinner.value
                          ? Container(
                              height: 30,
                              width: 30,
                              alignment: Alignment.center,
                              child: const CircularProgressIndicator(
                                color: AppColor.textSecondary,
                                strokeWidth: 2.5,
                              ),
                            )
                          : Container(),
                    ],
                  ),
                  const SizedBox(height: 30),
                ],
              )),
        ),
      ),
    );
  }
}
