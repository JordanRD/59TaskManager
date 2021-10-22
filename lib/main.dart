import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:limasembilan_todo_app/app_theme.dart';
import 'package:limasembilan_todo_app/controller/project_controller.dart';
import 'package:limasembilan_todo_app/controller/route_data_controller.dart';
import 'package:limasembilan_todo_app/controller/task_controller.dart';
import 'package:limasembilan_todo_app/routes/app_route.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  GetStorage.init();
  await initializeDateFormatting('id_ID', null).then((_) {
    Get.put(ProjectController());
    Get.put(TaskController());
    Get.put(RouteDataController());
    runApp(const MyApp());
  });
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Lima Sembilan',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.grey,
        primaryColor: AppColor.primaryColor,
        backgroundColor: const Color.fromARGB(255, 250, 250, 250),
        scaffoldBackgroundColor: const Color.fromARGB(255, 250, 250, 250),
        textTheme: GoogleFonts.montserratTextTheme(Theme.of(context).textTheme),
      ),
      initialRoute: RouteNames.project,
      getPages: appRoutes,
      unknownRoute: appRoutes[0],
    );
  }
}
