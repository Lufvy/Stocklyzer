import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stocklyzer/IOHelper/IOHelper.dart';
import 'package:stocklyzer/component/StockChart.dart';
import 'package:stocklyzer/component/loading.dart';
import 'package:stocklyzer/component/logo.dart';
import 'package:stocklyzer/config/appTheme.dart';
import 'package:stocklyzer/config/extension.dart';
import 'package:stocklyzer/controller/homeController.dart';
import 'package:stocklyzer/controller/themeController.dart';
import 'package:stocklyzer/view/stockDetail.dart';

class Home extends StatelessWidget {
  Home({super.key});
  final themeController = Get.find<Themecontroller>();
  final homeController = Get.put(Homecontroller());

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
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 15,
                  children: [
                    Row(
                      spacing: 10,
                      children: [
                        Logo(size: 44),
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
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onPrimary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    Text.rich(
                      TextSpan(
                        text: 'Welcome,',
                        style: GoogleFonts.poppins(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                        children: [
                          TextSpan(
                            text: "${homeController.name.value}!",
                            style: GoogleFonts.poppins(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (homeController.isIHSGGraphLoading.value)
                      Container(
                        width: double
                            .infinity, // Set the desired width in logical pixels
                        height: 335, // Set the desired height in logical pixels
                        decoration: BoxDecoration(
                          color: Theme.of(context)
                              .colorScheme
                              .secondaryContainer, // Set the background color
                          borderRadius: BorderRadius.circular(
                            8.0,
                          ), // Set the corner radius
                        ),
                        child: Center(
                          child: OverlayLoading(isBackground: false, size: 200),
                        ),
                      )
                    else
                      StockChart(
                        themeController: themeController,
                        context: context,
                        dataGraph: homeController.IHSGGraphData.value!,
                        hoverPoint: homeController.IHSGHoverPoint.value!,
                      ),
                    watchList(context),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget watchList(BuildContext context) {
    return Column(
      spacing: 15,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        IntrinsicWidth(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Watchlist',
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: CustomFontWeight.medium,
                ),
              ),
              Container(
                height: 3,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(3),
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
              ),
            ],
          ),
        ),

        Column(
          children: [
            Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      flex: 5,
                      child: Text(
                        'Stock',
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          fontWeight: CustomFontWeight.regular,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Text(
                        'Last Price',
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          fontWeight: CustomFontWeight.regular,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Text(
                        'Predicted Price',
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          fontWeight: CustomFontWeight.regular,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
                Divider(),
              ],
            ),

            if (homeController.isWatchListLoading.value)
              OverlayLoading(isBackground: false, size: 40)
            else if (homeController.watchListData.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Center(
                  child: Text(
                    'No stocks in your watchlist.',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: CustomFontWeight.medium,
                      color: themeController.isDarkMode.value
                          ? Colors.white.withValues(alpha: 0.8)
                          : Colors.black.withValues(alpha: 0.8),
                    ),
                  ),
                ),
              )
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: homeController.watchListData.length,
                itemBuilder: (context, index) {
                  final stockWatchlist = homeController.watchListData[index];

                  return Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Get.to(
                            () => StockDetail(
                              selectedTicker: stockWatchlist.ticker,
                            ),
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Theme.of(
                              context,
                            ).colorScheme.secondaryContainer,
                            borderRadius: BorderRadius.circular(8),
                            border: themeController.isDarkMode.value
                                ? null
                                : Border.all(
                                    width: 2,
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.onSecondaryContainer,
                                  ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8),
                            child: Row(
                              children: [
                                Image.asset(
                                  'assets/tickers/${stockWatchlist.ticker}.png',
                                  width: 32,
                                  height: 32,
                                ),
                                SizedBox(width: 10),
                                Expanded(
                                  flex: 4,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        stockWatchlist.ticker,
                                        style: GoogleFonts.poppins(
                                          fontSize: 13,
                                          fontWeight: CustomFontWeight.bold,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                      Text(
                                        stockWatchlist.name,
                                        style: GoogleFonts.poppins(
                                          fontSize: 10,
                                          fontWeight: CustomFontWeight.regular,
                                          color:
                                              themeController.isDarkMode.value
                                              ? Color(
                                                  0XFFFFFFFF,
                                                ).withValues(alpha: 0.8)
                                              : Color(
                                                  0XFF000000,
                                                ).withValues(alpha: 0.8),
                                        ),
                                        textAlign: TextAlign.left,
                                        maxLines: 1, // Limit to one line
                                        overflow: TextOverflow
                                            .ellipsis, // Truncate with "..."
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  flex: 3,
                                  child: Text(
                                    IOHelper.formatPrice(
                                      stockWatchlist.lastPrice,
                                    ).toString(),
                                    style: GoogleFonts.poppins(
                                      fontSize: 13,
                                      fontWeight: CustomFontWeight.bold,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                Expanded(
                                  flex: 3,
                                  child: Text(
                                    IOHelper.formatPrice(
                                          stockWatchlist.predictedPrice,
                                        ) // for demo
                                        .toString(),
                                    style: GoogleFonts.poppins(
                                      fontSize: 13,
                                      fontWeight: CustomFontWeight.bold,
                                      color: Color(0XFFFFB700),
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 14),
                    ],
                  );
                },
              ),
          ],
        ),
      ],
    );
  }
}
