import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:get/get.dart';
import 'package:stocklyzer/config/appTheme.dart';
import 'package:stocklyzer/config/language.dart';
import 'package:stocklyzer/controller/onboardingController.dart';
import 'package:stocklyzer/controller/themeController.dart';
import 'package:stocklyzer/view/onboarding.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: ".env");
  final supabaseUrl = dotenv.env['SUPABASE_URL'];
  final supabaseAnonKey = dotenv.env['SUPABASE_ANON_KEY'];

  if (supabaseUrl == null || supabaseAnonKey == null) {
    throw Exception('Supabase URL or Anon Key is not set in .env file');
  }

  await Supabase.initialize(url: supabaseUrl, anonKey: supabaseAnonKey);

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
      return KeyboardDismissOnTap(
        child: GetMaterialApp(
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
        ),
      );
    });
  }
}
