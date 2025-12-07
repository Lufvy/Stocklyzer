import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:get/get.dart';
import 'package:stocklyzer/config/appTheme.dart';
import 'package:stocklyzer/config/language.dart';
import 'package:stocklyzer/controller/themeController.dart';
import 'package:stocklyzer/repository/stock_repository.dart';
import 'package:stocklyzer/repository/user_repository.dart';
import 'package:stocklyzer/services/supabase/supabase_auth_manager.dart';
import 'package:stocklyzer/view/navBar.dart';
import 'package:stocklyzer/view/onboarding.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:stocklyzer/view/splash.dart';
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
  Get.put(UserRepository(), permanent: true);
  Get.put(StockRepository(), permanent: true);

  Get.put(AuthService(), permanent: true);
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final themeController = Get.find<Themecontroller>();
  final authService = Get.find<AuthService>();

  var isSplashVisible = true.obs;

  @override
  void initState() {
    super.initState();
    themeController.loadTheme();
    themeController.loadLanguage();

    authService.checkSession();
    delaySplash();
  }

  Future<void> delaySplash() async {
    await Future.delayed(const Duration(seconds: 2));
    isSplashVisible.value = false;
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
          home: AnimatedSwitcher(
            duration: const Duration(milliseconds: 600),
            transitionBuilder: (Widget child, Animation<double> animation) {
              return FadeTransition(opacity: animation, child: child);
            },
            child: isSplashVisible.value ? Splash() : handleAfterSplash(),
          ),
        ),
      );
    });
  }

  Widget handleAfterSplash() {
    if (authService.isLoggedIn.value) {
      // User is already logged in — restore session
      return Navbar();
    } else {
      // User is not logged in — go to onboarding
      return Onboarding();
    }
  }
}
