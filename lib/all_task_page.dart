import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:limasembilan_todo_app/app_theme.dart';
import 'package:limasembilan_todo_app/controller/route_data_controller.dart';
import 'package:limasembilan_todo_app/controller/task_controller.dart';
import 'package:limasembilan_todo_app/helpers.dart';
import 'package:limasembilan_todo_app/models/task_model.dart';
import 'package:limasembilan_todo_app/task_card.dart';

class AllTaskPage extends GetView<TaskController> {
  const AllTaskPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    RouteDataController routeC = Get.find<RouteDataController>();
    DocumentReference _currentProject = controller.getCurrentProject();
    return Scaffold(
      body: SingleChildScrollView(
        child: StreamBuilder<QuerySnapshot>(
            stream: _currentProject
                .collection('tasks')
                .orderBy('due_date', descending: false)
                .snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.connectionState != ConnectionState.active) {
                // debugPrint('ininih masuk kesini ${snapshot.connectionState}');
                return SizedBox(
                  height: MediaQuery.of(context).size.height - 90,
                  child: Center(
                    child: CircularProgressIndicator(
                        color: Theme.of(context).primaryColor),
                  ),
                );
              }
              // debugPrint(
              // 'ininih tapi masuk juga ${snapshot.connectionState.toString()}');
              var allTask = snapshot.data!.docs.map((data) {
                return TaskModel.fromDocumentSnapshot(data);
              }).toList();

              Detail detailType = routeC.currentAllTaskParam.value;
              DateTime today = DateTime.now();
              if (detailType == Detail.active) {
                allTask = allTask.where((task) => !task.isCompleted).toList();
              } else if (detailType == Detail.today) {
                allTask = allTask
                    .where((task) =>
                        dateTimeToyyyyMMdd(DateTime.fromMillisecondsSinceEpoch(
                            task.dueDate)) ==
                        dateTimeToyyyyMMdd(today))
                    .toList();
              } else if (detailType == Detail.late) {
                allTask = allTask
                    .where((task) =>
                        !task.isCompleted &&
                        dateTimeToyyyyMMdd(DateTime.fromMillisecondsSinceEpoch(
                                    task.dueDate))
                                .compareTo(dateTimeToyyyyMMdd(today)) ==
                            -1)
                    .toList();
              } else if (detailType == Detail.justAdd) {
                allTask
                    .sort((a, b) => (b.createDate ?? 0) - (a.createDate ?? 0));
              }

              if (allTask.isEmpty) {
                return SizedBox(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text('Tidak ada task',
                          style: TextStyle(color: AppColor.textSecondary)),
                      InkWell(
                        onTap: () => Get.back(),
                        child: Text('Kembali?',
                            style: TextStyle(
                                color: Theme.of(context).primaryColor)),
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ],
                  ),
                );
              }

              if (routeC.currentAllTaskParam.value != Detail.justAdd) {
                allTask.sort((a, b) {
                  return a.isCompleted ? 1 : -1;
                });
              }

              return SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 60),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: Row(
                        children: [
                          InkWell(
                            onTap: () => Get.back(),
                            child: const Icon(Icons.chevron_left, size: 30),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          const SizedBox(width: 15),
                          Text(
                              routeC.currentAllTaskParam.value == Detail.all
                                  ? 'Semua Task'
                                  : routeC.currentAllTaskParam.value ==
                                          Detail.today
                                      ? 'Hari Ini'
                                      : routeC.currentAllTaskParam.value ==
                                              Detail.late
                                          ? 'Lewat Jadwal'
                                          : routeC.currentAllTaskParam.value ==
                                                  Detail.active
                                              ? 'Aktif'
                                              : routeC.currentAllTaskParam
                                                          .value ==
                                                      Detail.justAdd
                                                  ? 'Baru Ditambahkan'
                                                  : 'Task',
                              style: const TextStyle(
                                  fontSize: TextSize.heading3,
                                  fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                    GridView.builder(
                        itemCount: allTask.length,
                        padding: const EdgeInsets.only(
                            left: 30, right: 30, bottom: 30, top: 30),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount:
                              MediaQuery.of(context).size.width > 700 ? 2 : 1,
                          mainAxisSpacing: 30,
                          crossAxisSpacing: 30,
                          childAspectRatio:
                              MediaQuery.of(context).size.width > 500
                                  ? 3 / 2
                                  : 2 / 1,
                        ),
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        physics: const ScrollPhysics(),
                        itemBuilder: (BuildContext context, int idx) {
                          debugPrint('ininih render');
                          return TaskCard(
                              context: context, task: allTask[idx], tag: 'tag');
                        }),
                  ],
                ),
              );
            }),
      ),
    );
  }
}
