import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stocklyzer/config/extension.dart';
import 'package:stocklyzer/controller/navBarController.dart';
import 'package:stocklyzer/view/home.dart';
import 'package:stocklyzer/view/profile.dart';
import 'package:stocklyzer/view/search.dart';

class Navbar extends StatefulWidget {
  const Navbar({super.key});

  @override
  State<Navbar> createState() => _NavbarState();
}

class _NavbarState extends State<Navbar> {
  final Navbarcontroller navController = Get.put(Navbarcontroller());

  final List<Widget> pages = [Home(), Search(), Profile()];

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      warningDialog();
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Scaffold(
        extendBody: true,
        body: IndexedStack(
          index: navController.selectedIndex.value,
          children: pages,
        ),
        bottomNavigationBar: ClipRRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
            child: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              currentIndex: navController.selectedIndex.value,
              onTap: navController.changeTab,
              items: [
                BottomNavigationBarItem(
                  icon: Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: Icon(Icons.home, size: 40),
                  ),
                  label: "home".tr,
                ),
                BottomNavigationBarItem(
                  icon: Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: Icon(Icons.search, size: 40),
                  ),
                  label: "search".tr,
                ),
                BottomNavigationBarItem(
                  icon: Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: Icon(Icons.person, size: 40),
                  ),
                  label: "profile".tr,
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  void warningDialog() {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            spacing: 20,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                child: Column(
                  spacing: 5,
                  children: [
                    Image.asset('assets/warning.png', width: 100, height: 100),
                    Text(
                      'warningTitle'.tr,
                      style: GoogleFonts.poppins(
                        fontSize: 20,
                        fontWeight: CustomFontWeight.bold,
                        color: Colors.red,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                spacing: 10,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text.rich(
                    TextSpan(
                      text: 'warningMsg1'.tr,
                      style: GoogleFonts.poppins(
                        fontSize: 10,
                        fontWeight: CustomFontWeight.regular,
                        color: Colors.black,
                      ),
                      children: [
                        TextSpan(
                          text: 'warningAI'.tr,
                          style: GoogleFonts.poppins(
                            fontSize: 10,
                            fontWeight: CustomFontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        TextSpan(text: 'warningMsg2'.tr),
                      ],
                    ),
                  ),

                  Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "• ",
                            style: GoogleFonts.poppins(
                              fontSize: 10,
                              fontWeight: CustomFontWeight.regular,
                              color: Colors.black,
                            ),
                          ),
                          Expanded(
                            child: Text.rich(
                              TextSpan(
                                text: 'warningPoint1'.tr,
                                style: GoogleFonts.poppins(
                                  fontSize: 10,
                                  fontWeight: CustomFontWeight.regular,
                                  color: Colors.black,
                                ),
                                children: [
                                  TextSpan(
                                    text: 'warningPointBoldPoint1'.tr,
                                    style: GoogleFonts.poppins(
                                      fontSize: 10,
                                      fontWeight: CustomFontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                  TextSpan(text: 'warningPoint1.1'.tr),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),

                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "• ",
                            style: GoogleFonts.poppins(
                              fontSize: 10,
                              fontWeight: CustomFontWeight.regular,
                              color: Colors.black,
                            ),
                          ),
                          Expanded(
                            child: Text(
                              "warningPoint2".tr,
                              style: GoogleFonts.poppins(
                                fontSize: 10,
                                fontWeight: CustomFontWeight.regular,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ],
                      ),

                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "• ",
                            style: GoogleFonts.poppins(
                              fontSize: 10,
                              fontWeight: CustomFontWeight.regular,
                              color: Colors.black,
                            ),
                          ),
                          Expanded(
                            child: Text(
                              "warningPoint3".tr,
                              style: GoogleFonts.poppins(
                                fontSize: 10,
                                fontWeight: CustomFontWeight.regular,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),

              Center(
                child: Text.rich(
                  TextSpan(
                    text: 'warningContinueText'.tr,
                    style: GoogleFonts.poppins(
                      fontSize: 11,
                      fontWeight: CustomFontWeight.regular,
                      color: Colors.black,
                    ),
                    children: [
                      TextSpan(
                        text: 'warningContinueBold'.tr,
                        style: GoogleFonts.poppins(
                          fontSize: 11,
                          fontWeight: CustomFontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      TextSpan(text: 'warningContinueDesc'.tr),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
              ),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Get.back();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  child: Text(
                    'continueButton'.tr,
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: CustomFontWeight.semiBold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }
}
