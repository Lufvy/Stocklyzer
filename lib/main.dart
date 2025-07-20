import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stocklyzer/appTheme.dart';
import 'package:stocklyzer/controllers/onboardingController.dart';
import 'package:stocklyzer/controllers/themeController.dart';
import 'package:stocklyzer/language.dart';
import 'package:stocklyzer/login.dart';
import 'package:stocklyzer/onboarding.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Get.put(Themecontroller());
  Get.put(Onboardingcontroller());

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final themeController = Get.find<Themecontroller>();

  @override
  void initState() {
    super.initState();
    themeController.loadTheme();
    themeController.loadLanguage();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Stocklyzer',
        theme: Apptheme.lightTheme(context),
        darkTheme: Apptheme.darkTheme(context),
        themeMode: themeController.isDarkMode.value
            ? ThemeMode.dark
            : ThemeMode.light,
        translations: Language(),
        locale: themeController.isEnglish.value
            ? const Locale('en')
            : const Locale('id'),
        fallbackLocale: const Locale('en'),
        home: Onboarding(),
      );
    });
  }
}
