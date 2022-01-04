import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:limasembilan_todo_app/controller/auth_controller.dart';
import 'package:limasembilan_todo_app/controller/user_controller.dart';
import 'package:limasembilan_todo_app/models/user_model.dart';
import 'package:limasembilan_todo_app/shared/app_theme.dart';
// import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class UserTab extends StatelessWidget {
  const UserTab({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final authC = Get.find<AuthController>();
    return GetBuilder<UserController>(builder: (controller) {
      return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(
          padding: const EdgeInsets.only(right: 30, left: 30, top: 30),
          color: Theme.of(context).scaffoldBackgroundColor,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Profile',
                    style: TextStyle(
                      fontSize: TextSize.heading1,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      authC.logout();
                    },
                    child: const Icon(
                      Icons.logout_outlined,
                      color: AppColor.textSecondary,
                    ),
                  )
                ],
              ),
              const SizedBox(height: 30),
              Obx(() => _buildUserProfile(authC.loggedUser.value)),
              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Users',
                    style: TextStyle(
                      fontSize: TextSize.heading4,
                      fontWeight: FontWeight.bold,
                      color: AppColor.primaryColor,
                    ),
                  ),
                  Text(
                    '${controller.users.length}',
                    style: const TextStyle(
                      fontSize: TextSize.body1,
                      fontWeight: FontWeight.bold,
                      color: AppColor.textSecondary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),
            ],
          ),
        ),
        // const SizedBox(height: 30),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.only(right: 30, left: 30),
            physics: const BouncingScrollPhysics(),
            children: [
              StaggeredGrid.count(
                axisDirection: AxisDirection.down,
                crossAxisCount: 2,
                crossAxisSpacing: 15,
                mainAxisSpacing: 15,
                children: controller.users
                    .where((p0) => p0.userId != authC.loggedUser.value.userId)
                    .map(
                      (user) => StaggeredGridTile.fit(
                        crossAxisCellCount: 1,
                        child: _buildUserCard(user),
                      ),
                    )
                    .toList(),
              ),
              const SizedBox(height: 100),
            ],
          ),
        ),
        // const SizedBox(height: 15)
      ]);
    });
  }

  Container _buildUserProfile(UserModel user) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [AppStyle.defaultShadow],
      ),
      padding: const EdgeInsets.all(30),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Text(
              '${user.username}',
              style: const TextStyle(
                fontSize: TextSize.heading4,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 15),
          Column(
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.verified_user_outlined,
                    size: 15,
                  ),
                  const SizedBox(width: 5),
                  Text(
                    '${user.role}',
                    style: const TextStyle(
                      fontSize: TextSize.body2,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 5),
              Row(
                children: [
                  const Icon(
                    Icons.lock_outline_rounded,
                    size: 15,
                  ),
                  const SizedBox(width: 5),
                  Text(
                    '${user.uniqKey}',
                    style: const TextStyle(
                      fontSize: TextSize.body2,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildUserCard(UserModel user) {
    return InkWell(
      onTap: () {},
      child: Ink(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [AppStyle.defaultShadow],
        ),
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              user.username ?? '-',
              style: const TextStyle(
                fontSize: TextSize.heading4,
              ),
            ),
            const SizedBox(height: 15),
            Column(
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.verified_user_outlined,
                      size: 15,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      user.role ?? '-',
                      style: const TextStyle(
                        fontSize: TextSize.body2,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                Row(
                  children: [
                    const Icon(
                      Icons.lock_outline_rounded,
                      size: 15,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      user.uniqKey ?? '-',
                      style: const TextStyle(
                        fontSize: TextSize.body2,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
