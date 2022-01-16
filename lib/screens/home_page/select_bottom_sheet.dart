import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:limasembilan_todo_app/routes/app_route.dart';

class SelectBottomSheet extends StatelessWidget {
  const SelectBottomSheet({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
          height: max(
            200,
            MediaQuery.of(context).size.height * 0.2,
          ),
          padding: const EdgeInsets.all(30),
          child: Row(
            children: [
              _buildSelectButton(
                context,
                text: 'New Project',
                onTap: () {
                  Get.toNamed(RouteNames.addProject);
                },
              ),
              const SizedBox(width: 30),
              _buildSelectButton(context, text: 'New User', onTap: () {
                Get.toNamed(RouteNames.addUser);
              }),
            ],
          )),
    );
  }

  Widget _buildSelectButton(BuildContext context,
      {required String text, required void Function()? onTap}) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(30)),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.add),
              Text(
                text,
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
