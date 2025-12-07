import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stocklyzer/component/languageToggleButton.dart';
import 'package:stocklyzer/component/loading.dart';
import 'package:stocklyzer/component/logo.dart';
import 'package:stocklyzer/config/appTheme.dart';
import 'package:stocklyzer/config/extension.dart';
import 'package:stocklyzer/controller/registerController.dart';
import 'package:stocklyzer/controller/themeController.dart';
import 'package:stocklyzer/view/login.dart';

class Register extends StatelessWidget {
  Register({super.key});
  final themeController = Get.find<Themecontroller>();
  final registerController = Get.put(RegisterController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        return Stack(
          children: [
            Container(
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
                                  IntrinsicWidth(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'register'.tr,
                                          style: GoogleFonts.poppins(
                                            fontSize: 20,
                                            fontWeight: CustomFontWeight.medium,
                                          ),
                                        ),
                                        Container(
                                          height: 3,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                              3,
                                            ),
                                            color: Theme.of(
                                              context,
                                            ).colorScheme.onPrimary,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Name',
                                        style: GoogleFonts.poppins(
                                          fontSize: 15,
                                        ),
                                      ),
                                      SizedBox(height: 5),
                                      TextFormField(
                                        onChanged: (value) {
                                          registerController.name.value = value;
                                        },
                                        decoration: InputDecoration(
                                          hintText: 'nameHint'.tr,
                                          hintStyle: TextStyle(
                                            color:
                                                themeController.isDarkMode.value
                                                ? Colors.white.withValues(
                                                    alpha: 0.59,
                                                  )
                                                : Colors.black.withValues(
                                                    alpha: 0.59,
                                                  ),
                                          ),
                                          border: OutlineInputBorder(),
                                          prefixIcon: Icon(
                                            Icons.person_outline,
                                          ),
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Email',
                                        style: GoogleFonts.poppins(
                                          fontSize: 15,
                                        ),
                                      ),
                                      TextFormField(
                                        onChanged: (value) {
                                          registerController.email.value =
                                              value;
                                        },
                                        decoration: InputDecoration(
                                          hintText: 'emailHint'.tr,
                                          hintStyle: TextStyle(
                                            color:
                                                themeController.isDarkMode.value
                                                ? Colors.white.withValues(
                                                    alpha: 0.59,
                                                  )
                                                : Colors.black.withValues(
                                                    alpha: 0.59,
                                                  ),
                                          ),
                                          border: OutlineInputBorder(),
                                          prefixIcon: Icon(
                                            Icons.email_outlined,
                                          ),
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Password',
                                        style: GoogleFonts.poppins(
                                          fontSize: 15,
                                        ),
                                      ),
                                      TextFormField(
                                        onChanged: (value) {
                                          registerController.password.value =
                                              value;
                                        },
                                        obscureText:
                                            registerController.isHidden.value,
                                        decoration: InputDecoration(
                                          hintText: 'passwordHint'.tr,
                                          hintStyle: TextStyle(
                                            color:
                                                themeController.isDarkMode.value
                                                ? Colors.white.withValues(
                                                    alpha: 0.59,
                                                  )
                                                : Colors.black.withValues(
                                                    alpha: 0.59,
                                                  ),
                                          ),
                                          suffixIcon: IconButton(
                                            icon: Icon(
                                              registerController.isHidden.value
                                                  ? Icons
                                                        .visibility_off_outlined
                                                  : Icons.visibility_outlined,
                                            ),
                                            onPressed: () {
                                              registerController
                                                  .isHidden
                                                  .value = !registerController
                                                  .isHidden
                                                  .value;
                                            },
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
                                  onPressed: () {
                                    // Register action
                                    registerController.onUserRegister();
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
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.secondary,
                                  fontWeight: CustomFontWeight.bold,
                                  decoration: TextDecoration.underline,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    Get.off(() => Login());
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
            ),

            if (registerController.isLoading.value) OverlayLoading(),
          ],
        );
      }),
    );
  }
}
