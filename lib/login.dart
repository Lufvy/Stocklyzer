import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stocklyzer/appTheme.dart';
import 'package:stocklyzer/controllers/loginController.dart';
import 'package:stocklyzer/controllers/themeController.dart';
import 'package:stocklyzer/register.dart';

class Login extends StatelessWidget {
  const Login({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<Themecontroller>();
    // final Logincontroller logincontroller = Get.put(Logincontroller());
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
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              themeController.isDarkMode.value
                                  ? SvgPicture.asset('assets/Logo.svg')
                                  : ShaderMask(
                                      shaderCallback: (bounds) =>
                                          LinearGradient(
                                            colors: [
                                              Color(0XFF01353D),
                                              Color(0XFF007283),
                                            ],
                                            stops: [0.2, 0.75],
                                            begin: Alignment.topCenter,
                                            end: Alignment.bottomCenter,
                                          ).createShader(bounds),
                                      blendMode: BlendMode.srcIn,
                                      child: SvgPicture.asset(
                                        'assets/Logo.svg',
                                        color: Colors.white,
                                      ),
                                    ),
                              Row(
                                children: [
                                  AnimatedToggleSwitch<bool>.dual(
                                    current: themeController.isDarkMode.value,
                                    first: false,
                                    second: true,
                                    spacing: 4.0,
                                    onChanged: (_) =>
                                        themeController.toggleTheme(),
                                    style: ToggleStyle(
                                      borderRadius: BorderRadius.circular(20.0),
                                      indicatorColor: Theme.of(
                                        context,
                                      ).primaryColor,
                                      backgroundColor: Theme.of(
                                        context,
                                      ).colorScheme.background,
                                      indicatorBorder: Border.all(
                                        color: Theme.of(context).primaryColor,
                                        width: 3,
                                      ),
                                      borderColor: Colors.transparent,
                                    ),
                                    iconBuilder: (value) => value
                                        ? Icon(
                                            Icons.nightlight_round,
                                            color: Color(0xFF01353D),
                                          )
                                        : Icon(
                                            Icons.wb_sunny,
                                            color: Colors.yellow,
                                          ),

                                    height: 40,
                                    indicatorSize: const Size.square(35),

                                    animationDuration: const Duration(
                                      milliseconds: 250,
                                    ),
                                  ),
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
                            ],
                          ),
                          const SizedBox(height: 20),
                          Text(
                            'loginTitle'.tr,
                            style: GoogleFonts.poppins(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'login'.tr,
                            style: GoogleFonts.poppins(
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(height: 2),
                          FractionallySizedBox(
                            widthFactor: 0.2,
                            child: Container(
                              height: 5,
                              color: Theme.of(context).colorScheme.onPrimary,
                            ),
                          ),

                          SizedBox(height: 10),
                          Text(
                            'Email',
                            style: GoogleFonts.poppins(fontSize: 15),
                          ),
                          SizedBox(height: 5),
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
                          SizedBox(height: 10),
                          Text(
                            'Password',
                            style: GoogleFonts.poppins(fontSize: 15),
                          ),
                          SizedBox(height: 5),
                          TextFormField(
                            obscureText: true,
                            decoration: InputDecoration(
                              hintText: 'passwordHint'.tr,
                              hintStyle: TextStyle(
                                color: themeController.isDarkMode.value
                                    ? Colors.white.withOpacity(0.59)
                                    : Colors.black.withOpacity(0.59),
                              ),
                              suffixIcon: Icon(Icons.visibility_outlined),

                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.lock_outline),
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 15,
                                vertical: 0,
                              ),
                            ),
                          ),
                          SizedBox(height: 30),
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
                                'loginButton'.tr,
                                style: GoogleFonts.poppins(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 15),
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
                          SizedBox(height: 15),
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
                                      fontWeight: FontWeight.w700,
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
                    ),
                  ),
                  // Spacer(),
                  Center(
                    child: RichText(
                      text: TextSpan(
                        style: GoogleFonts.poppins(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
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
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Get.to(() => Register());
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
