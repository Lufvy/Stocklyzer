import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Themecontroller extends GetxController {
  final RxBool isDarkMode = true.obs;
  final RxBool isEnglish = true.obs;

  void toggleLanguage(bool value) async {
    isEnglish.value = value;
    var locale = value ? const Locale('en') : const Locale('id');
    Get.updateLocale(locale);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isEnglish', value);
  }

  Future<void> loadLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    final langValue = prefs.getBool('isEnglish') ?? true;
    isEnglish.value = langValue;
    var locale = langValue ? const Locale('en') : const Locale('id');
    Get.updateLocale(locale);
  }

  Future<void> loadTheme() async {
    var brightness =
        SchedulerBinding.instance.platformDispatcher.platformBrightness;
    isDarkMode.value = brightness == Brightness.dark;
    Get.changeThemeMode(isDarkMode.value ? ThemeMode.dark : ThemeMode.light);

    SchedulerBinding
        .instance
        .platformDispatcher
        .onPlatformBrightnessChanged = () {
      var newBrightness =
          SchedulerBinding.instance.platformDispatcher.platformBrightness;
      isDarkMode.value = newBrightness == Brightness.dark;
      Get.changeThemeMode(isDarkMode.value ? ThemeMode.dark : ThemeMode.light);
    };
  }
}
