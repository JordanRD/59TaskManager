import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:limasembilan_todo_app/shared/app_theme.dart';
import 'package:limasembilan_todo_app/routes/app_route.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await GetStorage.init();
  await initializeDateFormatting('id_ID', null).then((_) {
    runApp(const MyApp());
  });
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Future.delayed(const Duration(seconds: 3)),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return GetMaterialApp(
              title: 'Lima Sembilan',
              debugShowCheckedModeBanner: false,
              theme: ThemeData(
                primarySwatch: Colors.grey,
                primaryColor: AppColor.primaryColor,
                backgroundColor: const Color.fromARGB(255, 250, 250, 250),
                scaffoldBackgroundColor:
                    const Color.fromARGB(255, 250, 250, 250),
                textTheme: GoogleFonts.montserratTextTheme(
                    Theme.of(context).textTheme),
              ),
              initialRoute: RouteNames.login,
              getPages: appRoutes,
              unknownRoute: appRoutes[0],
            );
          }
          return Container(color: Colors.cyan);
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