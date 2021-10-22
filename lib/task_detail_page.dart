import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:limasembilan_todo_app/app_theme.dart';
import 'package:limasembilan_todo_app/controller/task_controller.dart';
import 'package:limasembilan_todo_app/helpers.dart';
import 'package:limasembilan_todo_app/models/task_model.dart';
import 'package:limasembilan_todo_app/routes/app_route.dart';

class TaskDetailPage extends StatelessWidget {
  const TaskDetailPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    TaskController taskC = Get.find<TaskController>();
    Rx<TaskModel> _selectedTask = (Get.arguments as TaskModel).obs;
    RxBool _loading = false.obs;
    // debugPrint('ininih' + _selectedTask.value.taskId.toString());
    return Scaffold(
      body: Obx(() {
        DateTime _dateNow = DateTime.now();
        DateTime dueDate =
            DateTime.fromMillisecondsSinceEpoch(_selectedTask.value.dueDate);
        var status = _selectedTask.value.isCompleted
            ? StatusDate.completed
            : dateTimeToyyyyMMdd(dueDate) == dateTimeToyyyyMMdd(_dateNow)
                ? StatusDate.today
                : dateTimeToyyyyMMdd(dueDate)
                            .compareTo(dateTimeToyyyyMMdd(_dateNow)) ==
                        -1
                    ? StatusDate.late
                    : StatusDate.unknown;
        return SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            constraints:
                BoxConstraints(minHeight: MediaQuery.of(context).size.height),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 60),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(_selectedTask.value.title,
                          style: TextStyle(
                            // color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.bold,
                            fontSize: TextSize.heading2,
                            decoration: _selectedTask.value.isCompleted
                                ? TextDecoration.lineThrough
                                : TextDecoration.none,
                          )),
                    ),
                    const SizedBox(width: 15),
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
                Container(
                  // alignment: Alignment.center,
                  alignment: Alignment.topLeft,
                  constraints:
                      const BoxConstraints(minHeight: 400, maxWidth: 400),
                  child: Text(_selectedTask.value.description,
                      style: TextStyle(
                        fontSize: TextSize.body2,
                        decoration: _selectedTask.value.isCompleted
                            ? TextDecoration.lineThrough
                            : TextDecoration.none,
                      )),
                ),
                const SizedBox(height: 60),
                Row(
                  children: [
                    Icon(Icons.calendar_today_outlined,
                        color: status == StatusDate.late
                            ? AppColor.textDanger
                            : status == StatusDate.today
                                ? Theme.of(context).primaryColor
                                : status == StatusDate.completed
                                    ? AppColor.textSecondary
                                    : Colors.black),
                    const SizedBox(width: 10),
                    Text(
                      DateFormat.yMMMMd('id_ID').format(dueDate),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 4,
                      style: const TextStyle(
                        fontSize: TextSize.body3,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Visibility(
                        visible: !_loading.value,
                        child: Row(
                          children: [
                            InkWell(
                              borderRadius: BorderRadius.circular(15),
                              onTap: () async {
                                _loading.value = true;
                                try {
                                  bool isSuccess = await taskC.updateTask(
                                      _selectedTask.value.taskId,
                                      isCompleted:
                                          !_selectedTask.value.isCompleted);
                                  if (isSuccess) {
                                    TaskModel updatedTask =
                                        await taskC.getTaskByID(
                                            _selectedTask.value.taskId);
                                    Get.offAndToNamed(RouteNames.taskDetail,
                                        arguments: updatedTask);
                                  } else {
                                    throw Error;
                                  }
                                  _loading.value = false;
                                } catch (e) {
                                  Get.defaultDialog(
                                    title: '',
                                    titleStyle: const TextStyle(fontSize: 0),
                                    content: const Text(
                                      'Update Gagal',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    textCancel: 'OK',
                                    cancelTextColor:
                                        Theme.of(context).primaryColor,
                                  );
                                  _loading.value = false;
                                }
                              },
                              highlightColor: Colors.transparent,
                              child: Ink(
                                child: Icon(
                                  _selectedTask.value.isCompleted
                                      ? Icons.undo_rounded
                                      : Icons.done,
                                  color: _selectedTask.value.isCompleted
                                      ? Theme.of(context).primaryColor
                                      : Colors.white,
                                ),
                                padding: const EdgeInsets.all(15),
                                // alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  color: _selectedTask.value.isCompleted
                                      ? Colors.white
                                      : Theme.of(context).primaryColor,
                                  boxShadow: [AppStyle.defaultShadow],
                                ),
                              ),
                            ),
                            const SizedBox(width: 15),
                            InkWell(
                              borderRadius: BorderRadius.circular(15),
                              onTap: () {
                                Get.defaultDialog(
                                  title: '',
                                  titleStyle: const TextStyle(fontSize: 0),
                                  content: Text(
                                    'Hapus ${_selectedTask.value.title}?',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                  textConfirm: 'Ya',
                                  buttonColor: Theme.of(context).primaryColor,
                                  onConfirm: () async {
                                    try {
                                      _loading.value = true;
                                      bool isSuccess = await taskC.deleteTask(
                                          _selectedTask.value.taskId);
                                      if (isSuccess) {
                                        Get.offAllNamed(RouteNames.home);
                                      } else {
                                        throw Error;
                                      }
                                      _loading.value = false;
                                    } catch (e) {
                                      Get.back();
                                      Get.defaultDialog(
                                        title: '',
                                        titleStyle:
                                            const TextStyle(fontSize: 0),
                                        content: const Text(
                                          'Update Gagal',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        textCancel: 'OK',
                                        cancelTextColor:
                                            Theme.of(context).primaryColor,
                                      );
                                      _loading.value = false;
                                    }
                                  },
                                  textCancel: 'Tidak',
                                  cancelTextColor:
                                      Theme.of(context).primaryColor,
                                );
                              },
                              highlightColor: Colors.transparent,
                              child: Ink(
                                child: Icon(
                                  Icons.delete_outline,
                                  color: AppColor.textDanger,
                                ),
                                padding: const EdgeInsets.all(15),
                                // alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  color: Colors.white,
                                  boxShadow: [AppStyle.defaultShadow],
                                ),
                              ),
                            ),
                          ],
                        )),
                    Visibility(
                      visible: _loading.value,
                      child: Padding(
                        padding: const EdgeInsets.all(15),
                        child: SizedBox(
                          height: 25,
                          width: 25,
                          child: CircularProgressIndicator(
                            color: Theme.of(context).primaryColor,
                            strokeWidth: 2,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 15),
                    Expanded(child: Container()),
                    _selectedTask.value.isCompleted
                        ? _buildStatusBadge(context,
                            title: 'Selesai',
                            bgColor: Colors.white,
                            color: AppColor.textSecondary)
                        : status == StatusDate.late
                            ? _buildStatusBadge(context,
                                title: 'Terlambat',
                                color: Colors.white,
                                bgColor: AppColor.textDanger)
                            : _buildStatusBadge(
                                context,
                                title: 'Aktif',
                                color: Colors.white,
                                bgColor: Theme.of(context).primaryColor,
                              ),
                  ],
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        );
      }),
    );
  }

  Container _buildStatusBadge(BuildContext context,
      {required Color bgColor, required Color color, required String title}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 7.5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: bgColor,
        boxShadow: [AppStyle.defaultShadow],
      ),
      child: Text(
        title,
        style: TextStyle(
          color: color,
          fontSize: TextSize.body3,
        ),
      ),
    );
  }
}
