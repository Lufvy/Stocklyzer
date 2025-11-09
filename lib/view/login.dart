import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stocklyzer/component/languageToggleButton.dart';
import 'package:stocklyzer/component/logo.dart';
import 'package:stocklyzer/config/appTheme.dart';
import 'package:stocklyzer/controller/themeController.dart';
import 'package:stocklyzer/config/extension.dart';
import 'package:stocklyzer/view/register.dart';
import 'package:stocklyzer/view/userPersonalization.dart';

class Login extends StatelessWidget {
  Login({super.key});
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
                                  Languagetogglebutton(),
                                ],
                              ),
                              Text(
                                'loginTitle'.tr,
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
                              IntrinsicWidth(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'login'.tr,
                                      style: GoogleFonts.poppins(
                                        fontSize: 20,
                                        fontWeight: CustomFontWeight.semiBold,
                                      ),
                                    ),
                                    Container(
                                      height: 3,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(3),
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.onPrimary,
                                      ),
                                    ),
                                  ],
                                ),
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
                                            ? Colors.white.withValues(
                                                alpha: 0.59,
                                              )
                                            : Colors.black.withValues(
                                                alpha: 0.59,
                                              ),
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
                                            ? Colors.white.withValues(
                                                alpha: 0.59,
                                              )
                                            : Colors.black.withValues(
                                                alpha: 0.59,
                                              ),
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
                          Column(
                            spacing: 15,
                            children: [
                              SizedBox(
                                width: double.infinity,
                                height: 50,
                                child: ElevatedButton(
                                  onPressed: () {
                                    Get.to(() => Userpersonalization());
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Theme.of(
                                      context,
                                    ).primaryColor,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    padding: EdgeInsets.symmetric(vertical: 8),
                                  ),
                                  child: Text(
                                    'loginButton'.tr,
                                    style: GoogleFonts.poppins(
                                      fontSize: 20,
                                      fontWeight: CustomFontWeight.semiBold,
                                    ),
                                  ),
                                ),
                              ),

                              Row(
                                children: [
                                  Expanded(child: Divider()),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 20,
                                    ),
                                    child: Text('OR'),
                                  ),
                                  Expanded(child: Divider()),
                                ],
                              ),

                              SizedBox(
                                width: double.infinity,
                                height: 50,
                                child: ElevatedButton(
                                  onPressed: () {},
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.transparent,
                                    shadowColor: Colors.transparent,
                                    elevation: 0,
                                    side: BorderSide(
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.onPrimary,
                                      width: 2,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    padding: EdgeInsets.symmetric(vertical: 8),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Image.asset(
                                        'assets/google.png',
                                        width: 30,
                                        height: 30,
                                      ),
                                      SizedBox(width: 10),
                                      Text(
                                        'loginGoogle'.tr,
                                        style: GoogleFonts.poppins(
                                          fontSize: 16,
                                          fontWeight: CustomFontWeight.medium,
                                          color: Theme.of(
                                            context,
                                          ).colorScheme.onPrimary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Spacer(),
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
                            text: 'dontHaveAccount'.tr,
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          TextSpan(
                            text: 'dontHaveAccount1'.tr,
                            style: GoogleFonts.poppins(
                              color: Theme.of(context).colorScheme.secondary,
                              fontWeight: CustomFontWeight.bold,
                              decoration: TextDecoration.underline,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Get.off(() => Register());
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
