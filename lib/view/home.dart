import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stocklyzer/config/appTheme.dart';
import 'package:stocklyzer/controller/themeController.dart';

class Home extends StatelessWidget {
  Home({super.key});
  final themeController = Get.find<Themecontroller>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(
        () => Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            gradient: themeController.isDarkMode.value
                ? Apptheme.darkGradient
                : Apptheme.lightGradient,
          ),
          child: Center(child: const Text('Welcome to Home Page!')),
        ),
      ),
    );
  }
}
