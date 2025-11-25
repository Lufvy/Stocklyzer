import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stocklyzer/component/loading.dart';
import 'package:stocklyzer/config/appTheme.dart';
import 'package:stocklyzer/config/extension.dart';
import 'package:stocklyzer/controller/themeController.dart';
import 'package:stocklyzer/controller/userPersonalizationController.dart';
import 'package:stocklyzer/view/navBar.dart';

class Userpersonalization extends StatelessWidget {
  Userpersonalization({super.key});
  final themeController = Get.find<Themecontroller>();
  final userPersonalizationController = Get.put(
    Userpersonalizationcontroller(),
  );

  Widget watchListTitleHeader() {
    return Column(
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
    );
  }

  Widget watchlistSection(BuildContext context, String title) {
    return Column(
      spacing: 20,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title.tr,
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
                color: Theme.of(context).colorScheme.onPrimary,
              ),

              child: LayoutBuilder(
                builder: (context, constraints) {
                  final textWidth = (TextPainter(
                    text: TextSpan(
                      text: title.tr,
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: CustomFontWeight.medium,
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
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              crossAxisSpacing: 22,
              mainAxisSpacing: 22,
              childAspectRatio: 0.74,
            ),
            itemCount: userPersonalizationController.watchlist[title]!.length,
            itemBuilder: (context, index) {
              final stock =
                  userPersonalizationController.watchlist[title]![index];

              return watchListTickerSelectionCard(context, stock);
            },
          ),
        ),
      ],
    );
  }

  Widget watchListTickerSelectionCard(
    BuildContext context,
    Map<String, dynamic> stock,
  ) {
    return GestureDetector(
      onTap: () {
        stock['selected'] = !stock['selected'];
        userPersonalizationController.watchlist.refresh();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: stock['selected']
              ? Theme.of(context).colorScheme.onPrimaryContainer
              : Theme.of(context).colorScheme.primaryContainer,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          spacing: 10,

          children: [
            Image.asset(
              'assets/tickers/${stock['name']}.png',
              width: 47,
              height: 47,
            ),
            Text(
              '${stock['name']}',
              style: GoogleFonts.poppins(
                fontWeight: CustomFontWeight.bold,
                color: stock['selected']
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.onPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget floatingSkipButton() {
    return Positioned(
      bottom: 25,
      right: 15,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0XFF01353D),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        ),
        onPressed: () {
          userPersonalizationController.onFloatingButtonPressed();
          // Get.offAll(() => Navbar());
        },
        child: Row(
          spacing: 5,
          children: [
            Text(
              userPersonalizationController.watchListSelectedCount <= 0
                  ? 'skipButton'.tr
                  : 'nextButton'.tr,
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: CustomFontWeight.semiBold,
              ),
            ),
            Icon(Icons.arrow_right_alt, size: 20),
          ],
        ),
      ),
    );
  }

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
                bottom: false,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Stack(
                    children: [
                      SingleChildScrollView(
                        padding: const EdgeInsets.only(bottom: 65),
                        child: Column(
                          spacing: 13,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            watchListTitleHeader(),
                            Column(
                              spacing: 20,
                              children: [
                                // From userPersonalizationController.watchlist keys, for loop each key to create section
                                for (var title
                                    in userPersonalizationController
                                        .watchlist
                                        .keys)
                                  watchlistSection(context, title),
                              ],
                            ),
                          ],
                        ),
                      ),
                      floatingSkipButton(),
                    ],
                  ),
                ),
              ),
            ),

            if (userPersonalizationController.isLoading.value) OverlayLoading(),
          ],
        );
      }),
    );
  }
}
