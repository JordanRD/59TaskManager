import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:limasembilan_todo_app/controller/auth_controller.dart';
import 'package:limasembilan_todo_app/models/user_model.dart';
import 'package:limasembilan_todo_app/shared/app_theme.dart';
import 'package:limasembilan_todo_app/routes/app_route.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  await Firebase.initializeApp();
  Get.put(AuthController(), permanent: true);
  await initializeDateFormatting('id_ID', null).then((_) {
    runApp(const MyApp());
  });
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AuthController authC = Get.find<AuthController>();

    return Obx(() {
      UserModel user = authC.loggedUser.value;
      // debugPrint('running ${user.userId}');
      if (authC.loading.value) {
        return Container(
          color: Colors.white,
          child: const Center(
            child: SizedBox(
              height: 60,
              width: 60,
              child: CircularProgressIndicator(
                color: AppColor.primaryColor,
              ),
            ),
          ),
        );
      }
      return GetMaterialApp(
        title: 'lima|sembilan',
        // debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.grey,
          primaryColor: AppColor.primaryColor,
          backgroundColor: AppColor.whiteBackround,
          scaffoldBackgroundColor: AppColor.whiteBackround,
          textTheme:
              GoogleFonts.montserratTextTheme(Theme.of(context).textTheme),
        ),
        initialRoute: user.userId != null ? RouteNames.home : RouteNames.login,
        getPages: appRoutes,
        unknownRoute: appRoutes[0],
      );
    });
  }
}
// FutureBuilder(
//       future: Future.delayed(Duration(seconds: 3)),
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.done) {
//           return Obx(
//             () => GetMaterialApp(
//               title: "ChatApp",
//               theme: ThemeData(
//                 brightness: Brightness.light,
//                 primaryColor: Colors.white,
//                 accentColor: Colors.black,
//                 buttonColor: Colors.red[900],
//               ),
//               initialRoute: authC.isSkipIntro.isTrue
//                   ? authC.isAuth.isTrue
//                       ? Routes.HOME
//                       : Routes.LOGIN
//                   : Routes.INTRODUCTION,
//               getPages: AppPages.routes,
//             ),
//           );
//         }
//         return FutureBuilder(
//           future: authC.firstInitialized(),
//           builder: (context, snapshot) => SplashScreen(),
//         );
//       },
//     );