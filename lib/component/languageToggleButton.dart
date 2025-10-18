import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stocklyzer/config/extension.dart';
import 'package:stocklyzer/controller/themeController.dart';
import 'package:get/get.dart';

class Languagetogglebutton extends StatefulWidget {
  const Languagetogglebutton({super.key});

  @override
  State<Languagetogglebutton> createState() => _LanguagetogglebuttonState();
}

class _LanguagetogglebuttonState extends State<Languagetogglebutton> {
  final themeController = Get.find<Themecontroller>();

  final isENToggled = true.obs;

  @override
  void initState() {
    super.initState();
    themeController.loadLanguage();
    if (themeController.isEnglish.value) {
      isENToggled.value = true;
    } else {
      isENToggled.value = false;
    }
  }

  Widget toggleLanguageContent(String language, bool isToggled) {
    return GestureDetector(
      onTap: () {
        if (language == "EN" && !themeController.isEnglish.value ||
            language == "ID" && themeController.isEnglish.value) {
          themeController.toggleLanguage(!themeController.isEnglish.value);
          isENToggled.value = themeController.isEnglish.value;
        }
      },
      child: Container(
        decoration: isToggled
            ? BoxDecoration(
                color: Colors.grey[600],
                borderRadius: BorderRadius.circular(5),
                border: Border.all(color: Colors.white, width: 1),
              )
            : null,
        padding: EdgeInsets.symmetric(horizontal: 5, vertical: 1),
        child: Row(
          spacing: 5.0,
          children: [
            Image.asset(width: 25, height: 25, 'assets/$language.png'),
            Text(
              language,
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: CustomFontWeight.semiBold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.black.withAlpha(77),
        borderRadius: BorderRadius.circular(3),
      ),
      child: Row(
        spacing: 5,
        children: [
          toggleLanguageContent("ID", !isENToggled.value),
          toggleLanguageContent("EN", isENToggled.value),
        ],
      ),
    );
  }
}
