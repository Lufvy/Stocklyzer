import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:stocklyzer/config/appTheme.dart';
import 'package:stocklyzer/controllers/onboardingController.dart';
import 'package:stocklyzer/controllers/themeController.dart';
import 'package:stocklyzer/config/extension.dart';
import 'package:stocklyzer/view/login.dart';
import 'package:stocklyzer/view/register.dart';

class Onboarding extends StatelessWidget {
  Onboarding({super.key});
  final themeController = Get.find<Themecontroller>();
  final onboardingcontroller = Get.find<Onboardingcontroller>();

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
            child: Column(
              children: [
                onboardingHeader(context),
                SizedBox(height: 50),
                Expanded(child: onboardingContent(context)),
                SizedBox(height: 60),
                CTAButton(context),
                SizedBox(height: 50),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Text(
                      'swipe'.tr,
                      style: GoogleFonts.poppins(
                        fontSize: 15,
                        fontWeight: CustomFontWeight.medium,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget CTAButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          SizedBox(
            width: double.infinity,
            height: 45,
            child: ElevatedButton(
              onPressed: () {
                Get.to(() => Login());
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
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
          SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            height: 45,
            child: ElevatedButton(
              onPressed: () {
                Get.to(() => Register());
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: themeController.isDarkMode.value
                    ? Theme.of(context).colorScheme.onSecondary
                    : Colors.transparent,
                side: BorderSide(
                  color: themeController.isDarkMode.value
                      ? Colors.transparent
                      : Theme.of(context).colorScheme.onSecondary,
                  width: 2,
                ),
                shadowColor: Colors.transparent,
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
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget onboardingContent(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        children: [
          Expanded(
            flex: 5,
            child: PageView.builder(
              controller: onboardingcontroller.pageController,
              onPageChanged: (index) {
                onboardingcontroller.currentPage.value = index;
              },
              itemCount: onboardingcontroller.images.length,
              itemBuilder: (context, index) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 30),
                      child: Text(
                        onboardingcontroller.title[index].tr,
                        style: GoogleFonts.poppins(
                          fontSize: 20,
                          fontWeight: CustomFontWeight.semiBold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Text(
                      onboardingcontroller.descriptions[index].tr,
                      style: GoogleFonts.poppins(fontSize: 14),
                      textAlign: TextAlign.center,
                    ),

                    Center(
                      child: Container(
                        margin: EdgeInsets.only(top: 50),
                        width: MediaQuery.of(context).size.width * 0.5,
                        height: MediaQuery.of(context).size.height * 0.2,
                        decoration: BoxDecoration(
                          // color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          image: DecorationImage(
                            image: AssetImage(
                              onboardingcontroller.images[index],
                            ),
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 20, top: 30),
            child: SmoothPageIndicator(
              controller: onboardingcontroller.pageController,
              count: onboardingcontroller.images.length,
              effect: WormEffect(
                dotColor: Colors.grey,
                activeDotColor: Theme.of(context).colorScheme.onPrimary,
                dotHeight: 10,
                dotWidth: 10,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget onboardingHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: Row(
        children: [
          themeController.isDarkMode.value
              ? SvgPicture.asset('assets/Logo.svg', width: 45, height: 45)
              : ShaderMask(
                  shaderCallback: (bounds) => LinearGradient(
                    colors: [Color(0XFF01353D), Color(0XFF007283)],
                    stops: [0.2, 0.75],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ).createShader(bounds),
                  blendMode: BlendMode.srcIn,
                  child: SvgPicture.asset(
                    'assets/Logo.svg',
                    color: Colors.white,
                    width: 45,
                    height: 45,
                  ),
                ),
          SizedBox(width: 10),
          Text.rich(
            TextSpan(
              text: 'Stock',
              style: GoogleFonts.poppins(
                fontSize: 20,
                color: Color(0XFF01ABC4),
                fontWeight: FontWeight.bold,
              ),
              children: [
                TextSpan(
                  text: 'Lyzer',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 20),
          Row(
            children: [
              AnimatedToggleSwitch<bool>.dual(
                current: themeController.isDarkMode.value,
                first: false,
                second: true,
                spacing: 4.0,
                onChanged: (_) => themeController.toggleTheme(),
                style: ToggleStyle(
                  borderRadius: BorderRadius.circular(20.0),
                  indicatorColor: Theme.of(context).primaryColor,
                  backgroundColor: Theme.of(context).colorScheme.background,
                  indicatorBorder: Border.all(
                    color: Theme.of(context).primaryColor,
                    width: 3,
                  ),
                  borderColor: Colors.transparent,
                ),
                iconBuilder: (value) => value
                    ? Icon(Icons.nightlight_round, color: Color(0xFF01353D))
                    : Icon(Icons.wb_sunny, color: Colors.yellow),

                height: 40,
                indicatorSize: const Size.square(35),

                animationDuration: const Duration(milliseconds: 250),
              ),
              Obx(
                () => AnimatedToggleSwitch<bool>.size(
                  current: themeController.isEnglish.value,
                  values: const [false, true],
                  height: 30,
                  indicatorSize: const Size(45, 25),
                  iconOpacity: 1.0,
                  animationDuration: const Duration(milliseconds: 300),
                  style: ToggleStyle(
                    backgroundColor: Theme.of(context).colorScheme.background,
                    indicatorColor: Colors.transparent,
                    borderColor: Colors.transparent,
                    borderRadius: BorderRadius.circular(6),
                  ),

                  onChanged: themeController.toggleLanguage,
                  iconBuilder: (value) => ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: Image.asset(
                      value ? 'assets/EN.png' : 'assets/ID.png',
                      fit: BoxFit.cover,
                      width: 30,
                      height: 30,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
