import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stocklyzer/component/logo.dart';
import 'package:stocklyzer/config/appTheme.dart';
import 'package:stocklyzer/config/extension.dart';
import 'package:stocklyzer/controller/themeController.dart';
import 'package:stocklyzer/view/login.dart';

class Register extends StatelessWidget {
  Register({super.key});
  final themeController = Get.find<Themecontroller>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        return Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            gradient: themeController.isDarkMode.value
                ? Apptheme.darkGradient
                : Apptheme.lightGradient,
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        spacing: 27,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            spacing: 20,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Logo(size: 75),
                                  Obx(
                                    () => AnimatedToggleSwitch<bool>.size(
                                      current: themeController.isEnglish.value,
                                      values: const [false, true],
                                      height: 30,
                                      indicatorSize: const Size(45, 25),
                                      iconOpacity: 1.0,
                                      animationDuration: const Duration(
                                        milliseconds: 300,
                                      ),
                                      style: ToggleStyle(
                                        backgroundColor: Theme.of(
                                          context,
                                        ).colorScheme.background,
                                        indicatorColor: Colors.transparent,
                                        borderColor: Colors.transparent,
                                        borderRadius: BorderRadius.circular(6),
                                      ),

                                      onChanged: themeController.toggleLanguage,
                                      iconBuilder: (value) => ClipRRect(
                                        borderRadius: BorderRadius.circular(6),
                                        child: Image.asset(
                                          value
                                              ? 'assets/EN.png'
                                              : 'assets/ID.png',
                                          fit: BoxFit.cover,
                                          width: 30,
                                          height: 30,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                'registerTitle'.tr,
                                style: GoogleFonts.poppins(
                                  fontSize: 32,
                                  fontWeight: CustomFontWeight.bold,
                                ),
                              ),
                            ],
                          ),

                          Column(
                            spacing: 10,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'register'.tr,
                                    style: GoogleFonts.poppins(
                                      fontSize: 20,
                                      fontWeight: CustomFontWeight.semiBold,
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  FractionallySizedBox(
                                    widthFactor: 0.3,
                                    child: Container(
                                      height: 3,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(3),
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.onPrimary,
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Name',
                                    style: GoogleFonts.poppins(fontSize: 15),
                                  ),
                                  SizedBox(height: 5),
                                  TextFormField(
                                    decoration: InputDecoration(
                                      hintText: 'nameHint'.tr,
                                      hintStyle: TextStyle(
                                        color: themeController.isDarkMode.value
                                            ? Colors.white.withOpacity(0.59)
                                            : Colors.black.withOpacity(0.59),
                                      ),
                                      border: OutlineInputBorder(),
                                      prefixIcon: Icon(Icons.person_outline),
                                      contentPadding: EdgeInsets.symmetric(
                                        horizontal: 15,
                                        vertical: 0,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                spacing: 5,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Email',
                                    style: GoogleFonts.poppins(fontSize: 15),
                                  ),
                                  TextFormField(
                                    decoration: InputDecoration(
                                      hintText: 'emailHint'.tr,
                                      hintStyle: TextStyle(
                                        color: themeController.isDarkMode.value
                                            ? Colors.white.withOpacity(0.59)
                                            : Colors.black.withOpacity(0.59),
                                      ),
                                      border: OutlineInputBorder(),
                                      prefixIcon: Icon(Icons.email_outlined),
                                      contentPadding: EdgeInsets.symmetric(
                                        horizontal: 15,
                                        vertical: 0,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                spacing: 5,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Password',
                                    style: GoogleFonts.poppins(fontSize: 15),
                                  ),
                                  TextFormField(
                                    obscureText: true,
                                    decoration: InputDecoration(
                                      hintText: 'passwordHint'.tr,
                                      hintStyle: TextStyle(
                                        color: themeController.isDarkMode.value
                                            ? Colors.white.withOpacity(0.59)
                                            : Colors.black.withOpacity(0.59),
                                      ),
                                      suffixIcon: Icon(
                                        Icons.visibility_outlined,
                                      ),

                                      border: OutlineInputBorder(),
                                      prefixIcon: Icon(Icons.lock_outline),
                                      contentPadding: EdgeInsets.symmetric(
                                        horizontal: 15,
                                        vertical: 0,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Theme.of(context).primaryColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                padding: EdgeInsets.symmetric(vertical: 8),
                              ),
                              child: Text(
                                'registerButton'.tr,
                                style: GoogleFonts.poppins(
                                  fontSize: 20,
                                  fontWeight: CustomFontWeight.semiBold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Center(
                    child: RichText(
                      text: TextSpan(
                        style: GoogleFonts.poppins(
                          fontSize: 15,
                          fontWeight: CustomFontWeight.medium,
                          color: Theme.of(context).colorScheme.onPrimary,
                        ),
                        children: [
                          TextSpan(
                            text: 'haveAccount'.tr,
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          TextSpan(
                            text: 'haveAccount1'.tr,
                            style: GoogleFonts.poppins(
                              color: Theme.of(context).colorScheme.secondary,
                              fontWeight: CustomFontWeight.bold,
                              decoration: TextDecoration.underline,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Get.to(() => Login());
                              },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}
