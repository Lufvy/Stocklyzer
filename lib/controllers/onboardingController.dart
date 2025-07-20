import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Onboardingcontroller extends GetxController {
  final PageController pageController = PageController();
  final RxInt currentPage = 0.obs;

  final List<String> images = [
    'assets/onboarding1.png',
    'assets/onboarding2.png',
    'assets/onboarding3.png',
  ];
  final List<String> title = [
    'onboardingTitle1',
    'onboardingTitle2',
    'onboardingTitle3',
  ];

  final List<String> descriptions = [
    'onboardingDesc1',
    'onboardingDesc2',
    'onboardingDesc3',
  ];

  Timer? timer;

  @override
  void onInit() {
    super.onInit();
    startAutoSlide();
  }

  void startAutoSlide() {
    timer = Timer.periodic(Duration(seconds: 3), (timer) {
      int nextPage = currentPage.value + 1;

      if (nextPage >= images.length) {
        nextPage = 0;
      }

      currentPage.value = nextPage;
      pageController.animateToPage(
        nextPage,
        duration: Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void onClose() {
    timer?.cancel();
    pageController.dispose();
    super.onClose();
  }
}
