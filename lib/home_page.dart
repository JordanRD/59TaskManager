// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:limasembilan_todo_app/app_theme.dart';
import 'package:limasembilan_todo_app/controller/route_data_controller.dart';
import 'package:limasembilan_todo_app/controller/task_controller.dart';
import 'package:limasembilan_todo_app/helpers.dart';
import 'package:limasembilan_todo_app/models/task_model.dart';
import 'package:limasembilan_todo_app/routes/app_route.dart';
import 'package:limasembilan_todo_app/task_card.dart';

class HomePage extends GetView<TaskController> {
  HomePage({Key? key}) : super(key: key);
  final DateTime _dateNow = DateTime.now();
  @override
  Widget build(BuildContext context) {
    DocumentReference _currentProject = controller.getCurrentProject();
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      floatingActionButton: SizedBox(
        height: 75,
        width: 75,
        child: FloatingActionButton(
          onPressed: () {
            Get.toNamed(RouteNames.addTask);
          },
          child: const Icon(Icons.add, color: Colors.white),
          backgroundColor: Theme.of(context).primaryColor,
        ),
      ),
      body: StreamBuilder<DocumentSnapshot?>(
          stream: _currentProject.snapshots(),
          builder: (BuildContext context,
              AsyncSnapshot<DocumentSnapshot?> projectSnapShot) {
            if (projectSnapShot.connectionState != ConnectionState.active ||
                !projectSnapShot.hasData) {
              return SizedBox(
                height: MediaQuery.of(context).size.height - 90,
                child: Center(
                  child: CircularProgressIndicator(
                      color: Theme.of(context).primaryColor),
                ),
              );
            }
            debugPrint('masuk ' + projectSnapShot.connectionState.toString());
            debugPrint('masuk1' + projectSnapShot.hasData.toString());
            var currentProject =
                (projectSnapShot.data as DocumentSnapshot<Map?>?)?.data();
            if (currentProject == null) {
              return Container(
                height: screenHeight,
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text('Project tidak ditemukan',
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: TextSize.body1,
                        )),
                    InkWell(
                      onTap: () => {Get.offAllNamed(RouteNames.project)},
                      child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 15),
                          child: const Text('Kembali',
                              style: TextStyle(
                                color: AppColor.textSecondary,
                                fontSize: TextSize.body3,
                                fontWeight: FontWeight.bold,
                              ))),
                    ),
                  ],
                ),
              );
            }
            debugPrint('masuk2');
            String projectName = currentProject.containsKey('name')
                ? currentProject['name']
                : '';
            debugPrint('masuk3');
            return StreamBuilder<QuerySnapshot>(
                stream: _currentProject
                    .collection('tasks')
                    .orderBy('due_date', descending: false)
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.connectionState != ConnectionState.active) {
                    return Container();
                  }
                  debugPrint('ini ${snapshot.connectionState.toString()}');
                  var allTask = snapshot.data!.docs.map((data) {
                    return TaskModel.fromDocumentSnapshot(data);
                  }).toList();
                  // debugPrint(_dateNow);
                  var totalStatus =
                      allTask.fold([0, 0], (List previousValue, element) {
                    if (element.isCompleted) {
                      previousValue[0] += 1;
                    } else {
                      previousValue[1] += 1;
                    }
                    return previousValue;
                  });

                  // debugPrint(todayTask.toString());

                  return SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 60),
                        _buildProjectTitle(context, projectName),
                        const SizedBox(height: 30),
                        if (allTask.isNotEmpty)
                          _buildSummary(
                              totalCompleted: totalStatus[0],
                              totalInCompleted: totalStatus[1]),
                        const SizedBox(height: 30),
                        ..._renderAllTaskBlock(context, tasks: allTask)
                      ],
                    ),
                  );
                });
          }),
    );
  }

  Widget _buildTaskBlock(
      {required BuildContext context,
      required List<TaskModel> tasks,
      required Detail arguments,
      required String title,
      Color? color}) {
    return Column(
      children: [
        _buildSubHeading(
            title: title,
            color: color,
            onTap: () {
              Get.find<RouteDataController>().updateParam(arguments);
              Get.toNamed(RouteNames.allTaskPage);
            },
            context: context),
        const SizedBox(height: 30),
        _buildHorizontalGridView(
          MediaQuery.of(context).size.width,
          itemCount: tasks.length,
          itemBuilder: (BuildContext context, int idx) {
            debugPrint(idx.toString());
            return TaskCard(
                tag: 'home_to_detail', context: context, task: tasks[idx]);
          },
        ),
      ],
    );
  }

  SizedBox _buildHorizontalGridView(double screenWidth,
      {required Widget Function(BuildContext, int) itemBuilder,
      required int itemCount}) {
    return SizedBox(
      height: 240,
      child: GridView.builder(
        itemCount: itemCount,
        padding: const EdgeInsets.only(left: 30, right: 30, bottom: 30),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 1,
          mainAxisSpacing: 30,
          childAspectRatio: (240 - 30) /
              (screenWidth > 400 ? (screenWidth - 90) / 2 : (screenWidth - 60)),
        ),
        scrollDirection: Axis.horizontal,
        itemBuilder: itemBuilder,
      ),
    );
  }

  Container _buildSubHeading(
      {required String title,
      required void Function() onTap,
      Color? color,
      required BuildContext context}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 30),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: TextSize.heading4,
              color: color ?? Theme.of(context).primaryColor,
            ),
          ),
          InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(5),
            splashColor: Colors.grey[100],
            child: const Text(
              'Lihat Semua',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: TextSize.body3,
                color: AppColor.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProjectTitle(BuildContext context, String name) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 30),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            name,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: TextSize.heading2,
              color: Theme.of(context).primaryColor,
            ),
          ),
          InkWell(
            onTap: () {
              Get.toNamed(
                RouteNames.project,
              );
            },
            highlightColor: Colors.transparent,
            splashColor: Colors.transparent,
            child: const Icon(
              Icons.import_export,
              size: 30,
            ),
          )
        ],
      ),
    );
  }

  _buildSummary({int? totalCompleted, int? totalInCompleted}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 30),
      child: InkWell(
        highlightColor: Colors.white.withOpacity(0.8),
        borderRadius: BorderRadius.circular(15),
        onTap: () {
          Get.find<RouteDataController>().updateParam(Detail.all);
          Get.toNamed(RouteNames.allTaskPage);
        },
        child: Ink(
          padding: const EdgeInsets.all(30),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [AppStyle.defaultShadow],
          ),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Aktif',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: TextSize.body2,
                  ),
                ),
                Text(
                  totalInCompleted?.toString() ?? '0',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: TextSize.body2,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Selesai',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: TextSize.body2,
                    color: AppColor.textSecondary,
                  ),
                ),
                Text(
                  totalCompleted?.toString() ?? '0',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: TextSize.body2,
                    color: AppColor.textSecondary,
                  ),
                ),
              ],
            ),
          ]),
        ),
      ),
    );
  }

  List<Widget> _renderAllTaskBlock(BuildContext context,
      {required List<TaskModel> tasks}) {
    var todayTask = tasks.where((task) {
      String nowFormat = dateTimeToyyyyMMdd(_dateNow);
      String taskFormat =
          dateTimeToyyyyMMdd(DateTime.fromMillisecondsSinceEpoch(task.dueDate));
      debugPrint("ini $nowFormat $taskFormat ${nowFormat == taskFormat}");
      return nowFormat == taskFormat;
    }).toList();
    if (todayTask.isNotEmpty) {
      todayTask.sort((a, b) {
        return a.isCompleted ? 1 : -1;
      });
    }
    var lateTask = tasks.where((task) {
      return (!task.isCompleted &&
          dateTimeToyyyyMMdd(DateTime.fromMillisecondsSinceEpoch(task.dueDate))
                  .compareTo(dateTimeToyyyyMMdd(_dateNow)) ==
              -1);
    }).toList();

    var inCompletedTask = tasks.where((task) {
      return !task.isCompleted;
    }).toList();

    var completedTask = tasks.where((task) {
      return task.isCompleted;
    }).toList();

    var justAddTask = tasks
        .where((task) => task.createDate != null
            ? task.createDate! >
                DateTime.now()
                    .subtract(const Duration(minutes: 15))
                    .millisecondsSinceEpoch
            : false)
        .toList();

    justAddTask.sort((a, b) => (b.createDate ?? 0) - (a.createDate ?? 0));

    if (tasks.isEmpty) {
      return [
        SizedBox(height: MediaQuery.of(context).size.height / 4),
        const Center(
          child: Text(
            'Project ini tidak memiliki task',
            style: TextStyle(color: AppColor.textSecondary),
          ),
        ),
      ];
    } else if (todayTask.isEmpty &&
        lateTask.isEmpty &&
        inCompletedTask.isEmpty &&
        completedTask.isNotEmpty) {
      return [
        _buildTaskBlock(
            context: context,
            tasks: completedTask,
            arguments: Detail.all,
            title: 'Selesai',
            color: AppColor.textSecondary),
      ];
    } else {
      return [
        if (todayTask.isNotEmpty)
          _buildTaskBlock(
              context: context,
              tasks: todayTask,
              arguments: Detail.today,
              title: 'Hari ini'),
        if (justAddTask.isNotEmpty)
          _buildTaskBlock(
              context: context,
              tasks: justAddTask,
              arguments: Detail.justAdd,
              title: 'Baru Ditambahkan'),
        if (lateTask.isNotEmpty)
          _buildTaskBlock(
              context: context,
              tasks: lateTask,
              color: AppColor.textDanger,
              arguments: Detail.late,
              title: 'Lewat Jadwal'),
        if (inCompletedTask.isNotEmpty)
          _buildTaskBlock(
              context: context,
              tasks: inCompletedTask,
              arguments: Detail.active,
              color: Colors.black,
              title: 'Aktif'),
      ];
    }
  }
}
