import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stocklyzer/config/appTheme.dart';
import 'package:stocklyzer/config/extension.dart';
import 'package:stocklyzer/controllers/themeController.dart';
import 'package:stocklyzer/controllers/userPersonalizationController.dart';
import 'package:stocklyzer/view/navBar.dart';

class Userpersonalization extends StatelessWidget {
  Userpersonalization({super.key});
  final themeController = Get.find<Themecontroller>();
  final userPersonalizationController = Get.put(
    Userpersonalizationcontroller(),
  );

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
              child: Stack(
                children: [
                  SingleChildScrollView(
                    child: Column(
                      spacing: 13,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          spacing: 10,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'userPersonaTitle'.tr,
                              style: GoogleFonts.poppins(
                                fontSize: 20,
                                fontWeight: CustomFontWeight.bold,
                              ),
                            ),
                            Text(
                              'userPersonaTitle1'.tr,
                              style: GoogleFonts.poppins(
                                fontSize: 24,
                                fontWeight: CustomFontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          spacing: 20,
                          children: [
                            Column(
                              spacing: 20,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'bank'.tr,
                                      style: GoogleFonts.poppins(
                                        fontSize: 16,
                                        fontWeight: CustomFontWeight.medium,
                                      ),
                                    ),
                                    SizedBox(height: 3),
                                    Container(
                                      height: 1,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(3),
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.onPrimary,
                                      ),

                                      child: LayoutBuilder(
                                        builder: (context, constraints) {
                                          final textWidth = (TextPainter(
                                            text: TextSpan(
                                              text: 'bank'.tr,
                                              style: GoogleFonts.poppins(
                                                fontSize: 16,
                                                fontWeight:
                                                    CustomFontWeight.medium,
                                              ),
                                            ),
                                            maxLines: 1,
                                            textDirection: TextDirection.ltr,
                                          )..layout()).size.width;
                                          return SizedBox(width: textWidth);
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                                Obx(
                                  () => GridView.builder(
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 4,
                                          crossAxisSpacing: 22,
                                          mainAxisSpacing: 22,
                                          childAspectRatio: 0.74,
                                        ),
                                    itemCount: userPersonalizationController
                                        .watchlist
                                        .length,
                                    itemBuilder: (context, index) {
                                      final stock =
                                          userPersonalizationController
                                              .watchlist[index];
                                      return GestureDetector(
                                        onTap: () {
                                          stock['selected'] =
                                              !stock['selected'];
                                          userPersonalizationController
                                              .watchlist
                                              .refresh();
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 10,
                                          ),
                                          decoration: BoxDecoration(
                                            color: stock['selected']
                                                ? Theme.of(context)
                                                      .colorScheme
                                                      .onPrimaryContainer
                                                : Theme.of(context)
                                                      .colorScheme
                                                      .primaryContainer,
                                            borderRadius: BorderRadius.circular(
                                              10,
                                            ),
                                          ),
                                          child: Column(
                                            spacing: 10,

                                            children: [
                                              Image.asset(
                                                'assets/${stock['name']}.png',
                                                scale: 3,
                                              ),
                                              Text(
                                                '${stock['name']}',
                                                style: GoogleFonts.poppins(
                                                  fontWeight:
                                                      CustomFontWeight.bold,
                                                  color: stock['selected']
                                                      ? Theme.of(
                                                          context,
                                                        ).colorScheme.primary
                                                      : Theme.of(
                                                          context,
                                                        ).colorScheme.onPrimary,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              spacing: 20,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'commodity'.tr,
                                      style: GoogleFonts.poppins(
                                        fontSize: 16,
                                        fontWeight: CustomFontWeight.medium,
                                      ),
                                    ),
                                    SizedBox(height: 3),
                                    Container(
                                      height: 1,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(3),
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.onPrimary,
                                      ),
                                      child: LayoutBuilder(
                                        builder: (context, constraints) {
                                          final textWidth = (TextPainter(
                                            text: TextSpan(
                                              text: 'commodity'.tr,
                                              style: GoogleFonts.poppins(
                                                fontSize: 16,
                                                fontWeight:
                                                    CustomFontWeight.medium,
                                              ),
                                            ),
                                            maxLines: 1,
                                            textDirection: TextDirection.ltr,
                                          )..layout()).size.width;
                                          return SizedBox(width: textWidth);
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                                Obx(
                                  () => GridView.builder(
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 4,
                                          crossAxisSpacing: 22,
                                          mainAxisSpacing: 22,
                                          childAspectRatio: 0.74,
                                        ),
                                    itemCount: userPersonalizationController
                                        .watchlist
                                        .length,
                                    itemBuilder: (context, index) {
                                      final stock =
                                          userPersonalizationController
                                              .watchlist[index];
                                      return GestureDetector(
                                        onTap: () {
                                          stock['selected'] =
                                              !stock['selected'];
                                          userPersonalizationController
                                              .watchlist
                                              .refresh();
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 10,
                                          ),
                                          decoration: BoxDecoration(
                                            color: stock['selected']
                                                ? Theme.of(context)
                                                      .colorScheme
                                                      .onPrimaryContainer
                                                : Theme.of(context)
                                                      .colorScheme
                                                      .primaryContainer,
                                            borderRadius: BorderRadius.circular(
                                              10,
                                            ),
                                          ),
                                          child: Column(
                                            spacing: 10,

                                            children: [
                                              Image.asset(
                                                'assets/${stock['name']}.png',
                                                scale: 3,
                                              ),
                                              Text(
                                                '${stock['name']}',
                                                style: GoogleFonts.poppins(
                                                  fontWeight:
                                                      CustomFontWeight.bold,
                                                  color: stock['selected']
                                                      ? Theme.of(
                                                          context,
                                                        ).colorScheme.primary
                                                      : Theme.of(
                                                          context,
                                                        ).colorScheme.onPrimary,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              spacing: 20,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'energy'.tr,
                                      style: GoogleFonts.poppins(
                                        fontSize: 16,
                                        fontWeight: CustomFontWeight.medium,
                                      ),
                                    ),
                                    SizedBox(height: 3),
                                    Container(
                                      height: 1,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(3),
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.onPrimary,
                                      ),
                                      child: LayoutBuilder(
                                        builder: (context, constraints) {
                                          final textWidth = (TextPainter(
                                            text: TextSpan(
                                              text: 'energy'.tr,
                                              style: GoogleFonts.poppins(
                                                fontSize: 16,
                                                fontWeight:
                                                    CustomFontWeight.medium,
                                              ),
                                            ),
                                            maxLines: 1,
                                            textDirection: TextDirection.ltr,
                                          )..layout()).size.width;
                                          return SizedBox(width: textWidth);
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                                Obx(
                                  () => GridView.builder(
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 4,
                                          crossAxisSpacing: 22,
                                          mainAxisSpacing: 22,
                                          childAspectRatio: 0.74,
                                        ),
                                    itemCount: userPersonalizationController
                                        .watchlist
                                        .length,
                                    itemBuilder: (context, index) {
                                      final stock =
                                          userPersonalizationController
                                              .watchlist[index];
                                      return GestureDetector(
                                        onTap: () {
                                          stock['selected'] =
                                              !stock['selected'];
                                          userPersonalizationController
                                              .watchlist
                                              .refresh();
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 10,
                                          ),
                                          decoration: BoxDecoration(
                                            color: stock['selected']
                                                ? Theme.of(context)
                                                      .colorScheme
                                                      .onPrimaryContainer
                                                : Theme.of(context)
                                                      .colorScheme
                                                      .primaryContainer,
                                            borderRadius: BorderRadius.circular(
                                              10,
                                            ),
                                          ),
                                          child: Column(
                                            spacing: 10,

                                            children: [
                                              Image.asset(
                                                'assets/${stock['name']}.png',
                                                scale: 3,
                                              ),
                                              Text(
                                                '${stock['name']}',
                                                style: GoogleFonts.poppins(
                                                  fontWeight:
                                                      CustomFontWeight.bold,
                                                  color: stock['selected']
                                                      ? Theme.of(
                                                          context,
                                                        ).colorScheme.primary
                                                      : Theme.of(
                                                          context,
                                                        ).colorScheme.onPrimary,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0XFF01353D),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                      ),
                      onPressed: () {
                        Get.offAll(() => Navbar());
                      },
                      child: Row(
                        spacing: 5,
                        children: [
                          Text(
                            'skipButton'.tr,
                            style: GoogleFonts.poppins(
                              fontSize: 20,
                              fontWeight: CustomFontWeight.semiBold,
                            ),
                          ),
                          Icon(Icons.arrow_right_alt, size: 20),
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
