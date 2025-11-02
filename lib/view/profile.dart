import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stocklyzer/component/languageToggleButton.dart';
import 'package:stocklyzer/component/logo.dart';
import 'package:stocklyzer/config/appTheme.dart';
import 'package:stocklyzer/config/extension.dart';
import 'package:stocklyzer/controller/themeController.dart';
import 'package:stocklyzer/view/login.dart';

enum CTAButtonType { cancel, logout }

class Profile extends StatelessWidget {
  Profile({super.key});
  final themeController = Get.find<Themecontroller>();

  // bool isLanguageButtonToggled = false;

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
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(34, 0, 34, 0),
              child: Column(
                spacing: 40,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  profileHeader(context),
                  Column(
                    spacing: 20,
                    children: [languageButton(context), logoutButton()],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget profileHeader(BuildContext context) {
    return Column(
      spacing: 20,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'profile'.tr,
          style: GoogleFonts.poppins(
            fontSize: 24,
            fontWeight: CustomFontWeight.bold,
          ),
        ),
        Container(
          padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          decoration: BoxDecoration(
            color: themeController.isDarkMode.value
                ? Theme.of(context).colorScheme.onSecondaryContainer
                : Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: Theme.of(context).colorScheme.onSecondaryContainer,
              width: 2,
            ),
          ),
          child: Row(
            spacing: 15,
            children: [
              Logo(size: 72),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 5,
                children: [
                  Text(
                    "<Nama>",
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: CustomFontWeight.bold,
                    ),
                  ),
                  Text(
                    "<Email>",
                    style: GoogleFonts.poppins(
                      fontSize: 10,
                      fontWeight: CustomFontWeight.medium,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget languageButton(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Color(0XFF007283),
        borderRadius: BorderRadius.circular(10),
      ),
      padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            spacing: 10,
            children: [
              Icon(Icons.public, size: 24, color: Colors.white),
              Text(
                "language".tr,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: CustomFontWeight.medium,
                  color: Colors.white,
                ),
              ),
            ],
          ),

          // Button toggle bahasa
          // TODO: Pake component yang ada di onboarding.dart aja, samain aja di design nya
          Languagetogglebutton(),
        ],
      ),
    );
  }

  Widget CTAButton(String label, CTAButtonType type, VoidCallback onTap) {
    return TextButton(
      style: TextButton.styleFrom(
        backgroundColor: type == CTAButtonType.cancel
            ? Colors.grey[300]
            : Colors.red,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      onPressed: onTap,
      child: Text(
        label,
        style: GoogleFonts.poppins(
          fontSize: 14,
          fontWeight: CustomFontWeight.semiBold,
          color: type == CTAButtonType.cancel ? Colors.black : Colors.white,
        ),
      ),
    );
  }

  void logoutDialog() {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Container(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(5)),
          padding: EdgeInsets.all(15),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            spacing: 15,
            children: [
              Text(
                "logoutDialogTitle".tr,
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  color: Colors.black,
                  fontWeight: CustomFontWeight.semiBold,
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.max,
                spacing: 20,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CTAButton("cancel".tr, CTAButtonType.cancel, onCancel),
                  CTAButton("logout".tr, CTAButtonType.logout, onLogout),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void onCancel() {
    Get.back();
  }

  void onLogout() {
    Get.offAll(() => Login());
  }

  Widget logoutButton() {
    return GestureDetector(
      onTap: logoutDialog,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: themeController.isDarkMode.value
                ? Colors.transparent
                : Colors.red,
            width: 2,
          ),
        ),
        padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        child: Row(
          spacing: 10,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(Icons.logout_outlined, color: Colors.red),
            Text(
              "logout".tr,
              style: GoogleFonts.poppins(
                color: Colors.red,
                fontSize: 14,
                fontWeight: CustomFontWeight.medium,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
