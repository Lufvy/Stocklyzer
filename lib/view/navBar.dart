import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stocklyzer/config/extension.dart';
import 'package:stocklyzer/controllers/navBarController.dart';
import 'package:stocklyzer/view/home.dart';
import 'package:stocklyzer/view/profile.dart';
import 'package:stocklyzer/view/search.dart';

class Navbar extends StatefulWidget {
  const Navbar({super.key});

  @override
  State<Navbar> createState() => _NavbarState();
}

class _NavbarState extends State<Navbar> {
  @override
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
              items: const [
                BottomNavigationBarItem(
                  icon: Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: Icon(Icons.home, size: 40),
                  ),
                  label: "Home",
                ),
                BottomNavigationBarItem(
                  icon: Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: Icon(Icons.search, size: 40),
                  ),
                  label: "Search",
                ),
                BottomNavigationBarItem(
                  icon: Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: Icon(Icons.person, size: 40),
                  ),
                  label: "Profile",
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
        child: Padding(
          padding: const EdgeInsets.all(20),
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
                      'WARNING!',
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
                      text: 'This application uses',
                      style: GoogleFonts.poppins(
                        fontSize: 10,
                        fontWeight: CustomFontWeight.regular,
                        color: Colors.black,
                      ),
                      children: [
                        TextSpan(
                          text: ' AI',
                          style: GoogleFonts.poppins(
                            fontSize: 10,
                            fontWeight: CustomFontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        TextSpan(
                          text:
                              ' to provide stock predictions. These predictions are not financial advice.',
                        ),
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
                                text: 'The creators of this app',
                                style: GoogleFonts.poppins(
                                  fontSize: 10,
                                  fontWeight: CustomFontWeight.regular,
                                  color: Colors.black,
                                ),
                                children: [
                                  TextSpan(
                                    text: ' do not guarantee',
                                    style: GoogleFonts.poppins(
                                      fontSize: 10,
                                      fontWeight: CustomFontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                  TextSpan(
                                    text:
                                        ' accuracy and assume no responsibility for any decisions made based on the predictions.',
                                  ),
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
                              "The AI model is prone to error and may produce inaccurate or outdated information.",
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
                              "Always do your own research and consult with a qualified financial advisor before making investment decisions.",
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
                    text: 'By pressing',
                    style: GoogleFonts.poppins(
                      fontSize: 11,
                      fontWeight: CustomFontWeight.regular,
                      color: Colors.black,
                    ),
                    children: [
                      TextSpan(
                        text: ' continue',
                        style: GoogleFonts.poppins(
                          fontSize: 11,
                          fontWeight: CustomFontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      TextSpan(
                        text: ', you acknowledge and accept these terms.',
                      ),
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
                    'CONTINUE',
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
