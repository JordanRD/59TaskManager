import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:limasembilan_todo_app/controller/home_page_controller.dart';
import 'package:limasembilan_todo_app/controller/project_controller.dart';
import 'package:limasembilan_todo_app/controller/user_controller.dart';
import 'package:limasembilan_todo_app/screens/home_page/project_tab.dart';
import 'package:limasembilan_todo_app/screens/home_page/select_bottom_sheet.dart';
import 'package:limasembilan_todo_app/screens/home_page/user_tab.dart';
import 'package:limasembilan_todo_app/shared/app_theme.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    HomePageController homePageC = Get.put(HomePageController());
    Get.put(ProjectController(), permanent: true);
    Get.put(UserController(), permanent: true);
    return Obx(() => Scaffold(
          extendBody: true,
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Get.bottomSheet(
                const SelectBottomSheet(),
              );
            },
            child: const Icon(Icons.add, color: Colors.white),
            splashColor: Theme.of(context).primaryColor,
            focusColor: null,
            focusElevation: 0,
            highlightElevation: 0,
            elevation: 0,
            backgroundColor: Theme.of(context).primaryColor,
          ),
          bottomNavigationBar: _buildBottomNavigationBar(
            context,
            currentIndex: homePageC.currentIndex.value,
            onTap: (int idx) {
              homePageC.currentIndex.value = idx;
            },
          ),
          body: IndexedStack(
            index: homePageC.currentIndex.value,
            children: const [
              ProjectTab(),
              UserTab(),
            ],
          ),
        ));
  }

  Widget _buildBottomNavigationBar(BuildContext context,
      {required Function(int) onTap, required int currentIndex}) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
        boxShadow: [AppStyle.defaultShadow],
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
        child: BottomNavigationBar(
            elevation: 2,
            backgroundColor: Colors.white,
            type: BottomNavigationBarType.fixed,
            showSelectedLabels: false,
            showUnselectedLabels: false,
            currentIndex: currentIndex,
            onTap: onTap,
            items: [
              _buildBottomNavigationBarItem(
                context,
                iconData: Icons.book_outlined,
              ),
              _buildBottomNavigationBarItem(
                context,
                iconData: Icons.people_outline,
              ),
            ]),
      ),
    );
  }

  BottomNavigationBarItem _buildBottomNavigationBarItem(BuildContext context,
      {required IconData iconData}) {
    return BottomNavigationBarItem(
      icon: Icon(iconData),
      label: '',
      activeIcon: Icon(iconData, color: Theme.of(context).primaryColor),
    );
  }
}
