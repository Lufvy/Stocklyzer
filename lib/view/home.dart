import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:stocklyzer/component/logo.dart';
import 'package:stocklyzer/config/appTheme.dart';
import 'package:stocklyzer/config/extension.dart';
import 'package:stocklyzer/controller/homeController.dart';
import 'package:stocklyzer/controller/themeController.dart';
import 'package:stocklyzer/model/StockData.dart';
import 'package:stocklyzer/model/StockPrediction.dart';
import 'package:stocklyzer/view/stockDetail.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

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
                    mainChart(context),
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

  Widget mainChart(BuildContext context) {
    final actualData = homeController.stockData
        .where((s) => s.ticker == 'IHSG')
        .where((s) => s.date.isBefore(DateTime(2024, 10, 6)))
        .toList();

    final predictedData = homeController.stockprediction
        .where((s) => s.ticker == 'IHSG')
        .where((s) => s.date.isAfter(DateTime(2024, 10, 5)))
        .toList();

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondaryContainer,
        borderRadius: BorderRadius.circular(8),
        border: themeController.isDarkMode.value
            ? null
            : Border.all(
                width: 2,
                color: Theme.of(context).colorScheme.onSecondaryContainer,
              ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 13,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IntrinsicWidth(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'IHSG',
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
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'IHSG Accuracy',
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        fontWeight: CustomFontWeight.light,
                        color: themeController.isDarkMode.value
                            ? Colors.white.withValues(alpha: 0.8)
                            : Colors.black.withValues(alpha: 0.8),
                      ),
                    ),
                    Text(
                      '98%',
                      style: GoogleFonts.poppins(
                        fontSize: 20,
                        fontWeight: CustomFontWeight.semiBold,
                        color: const Color(0XFF00C9E7),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Text(
              '05/10/2024',
              style: GoogleFonts.poppins(
                fontSize: 15,
                fontWeight: CustomFontWeight.medium,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: 30,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  spacing: 2,
                  children: [
                    Text(
                      'Last Price',
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        fontWeight: CustomFontWeight.light,
                        color: themeController.isDarkMode.value
                            ? Colors.white.withValues(alpha: 0.8)
                            : Colors.black.withValues(alpha: 0.8),
                      ),
                    ),
                    Text(
                      '7.113,42',
                      style: GoogleFonts.poppins(
                        fontSize: 20,
                        fontWeight: CustomFontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  spacing: 2,
                  children: [
                    Text(
                      'Predicted Price',
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        fontWeight: CustomFontWeight.light,
                        color: themeController.isDarkMode.value
                            ? Colors.white.withValues(alpha: 0.8)
                            : Colors.black.withValues(alpha: 0.8),
                      ),
                    ),
                    Text(
                      '7.123,42',
                      style: GoogleFonts.poppins(
                        fontSize: 20,
                        fontWeight: CustomFontWeight.bold,
                        color: Color(0XFFFFB700),
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  spacing: 2,
                  children: [
                    Text(
                      'Accuracy',
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        fontWeight: CustomFontWeight.light,
                        color: themeController.isDarkMode.value
                            ? Colors.white.withValues(alpha: 0.8)
                            : Colors.black.withValues(alpha: 0.8),
                      ),
                    ),
                    Text(
                      '98%',
                      style: GoogleFonts.poppins(
                        fontSize: 20,
                        fontWeight: CustomFontWeight.bold,
                        color: Color(0XFF65DD63),
                      ),
                    ),
                  ],
                ),
              ],
            ),

            // ===== Chart =====
            SizedBox(
              height: 200,
              child: SfCartesianChart(
                backgroundColor: Colors.transparent,
                plotAreaBorderColor: Colors.black,
                legend: const Legend(isVisible: false),
                trackballBehavior: TrackballBehavior(
                  enable: true,
                  activationMode: ActivationMode.singleTap,
                  lineType: TrackballLineType.vertical,
                  tooltipDisplayMode: TrackballDisplayMode.groupAllPoints,
                  tooltipSettings: const InteractiveTooltip(enable: false),
                  builder: (context, dynamic details) {
                    final points = details?.groupingModeInfo?.points ?? [];
                    if (points.isEmpty) return const SizedBox.shrink();

                    final date = points.first.x as DateTime;
                    final dateText = DateFormat('MMM dd, yyyy').format(date);

                    final actual = actualData.firstWhereOrNull(
                      (s) => homeController.sameDate(s.date, date),
                    );
                    final predicted = predictedData.firstWhereOrNull(
                      (s) => homeController.sameDate(s.date, date),
                    );

                    return Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Theme.of(
                          context,
                        ).colorScheme.onSecondaryContainer,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black45,
                            blurRadius: 6,
                            offset: Offset(2, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Date: $dateText',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                          ),
                          if (actual != null)
                            Text(
                              'Actual: Rp ${homeController.formatPrice(actual.close)}',
                              style: const TextStyle(
                                color: Colors.greenAccent,
                                fontSize: 12,
                              ),
                            ),
                          if (predicted != null)
                            Text(
                              'Predicted: Rp ${homeController.formatPrice(predicted.closePrediction)}',
                              style: const TextStyle(
                                color: Colors.orangeAccent,
                                fontSize: 12,
                              ),
                            ),
                        ],
                      ),
                    );
                  },
                ),

                primaryXAxis: DateTimeAxis(
                  dateFormat: DateFormat.MMMd(),
                  intervalType: DateTimeIntervalType.days,
                  interval: 1,
                  majorGridLines: const MajorGridLines(width: 0),
                ),

                primaryYAxis: NumericAxis(
                  axisLine: const AxisLine(width: 0),
                  majorTickLines: const MajorTickLines(size: 0),
                  majorGridLines: const MajorGridLines(color: Colors.black),
                ),

                series: <CartesianSeries>[
                  // ===== Actual =====
                  LineSeries<StockData, DateTime>(
                    name: 'Actual',
                    dataSource: actualData,
                    xValueMapper: (StockData stock, _) => stock.date,
                    yValueMapper: (StockData stock, _) => stock.close,
                    color: Colors.greenAccent,
                    markerSettings: const MarkerSettings(isVisible: true),
                    animationDuration: 1000,
                  ),

                  // ===== Predicted =====
                  LineSeries<Stockprediction, DateTime>(
                    name: 'Predicted',
                    dataSource: predictedData,
                    xValueMapper: (Stockprediction stock, _) => stock.date,
                    yValueMapper: (Stockprediction stock, _) =>
                        stock.closePrediction,
                    color: Colors.orangeAccent,
                    dashArray: const [5, 3],
                    markerSettings: const MarkerSettings(isVisible: true),
                  ),
                ],
              ),
            ),
          ],
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

            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: homeController.watchList.length,
              itemBuilder: (context, index) {
                final stock = homeController.watchList[index];
                final stockData = homeController.stockData.firstWhereOrNull(
                  (s) =>
                      s.ticker == stock.ticker &&
                      s.date == DateTime(2024, 10, 5),
                );

                if (stockData == null) return SizedBox();

                final nextDate = stockData.date.add(const Duration(days: 1));

                final prediction = homeController.stockprediction
                    .firstWhereOrNull(
                      (p) => p.ticker == stock.ticker && p.date == nextDate,
                    );
                return Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        homeController.selected_msStock.value = stock;
                        // homeController.selected_stockprediction.value =
                        // prediction;
                        // homeController.selected_stockData.value = stockData;
                        Get.to(() => Stockdetail());
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
                                'assets/tickers/${stock.ticker}.png',
                                width: 32,
                                height: 32,
                              ),
                              SizedBox(width: 10),
                              Expanded(
                                flex: 4,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      stock.ticker,
                                      style: GoogleFonts.poppins(
                                        fontSize: 13,
                                        fontWeight: CustomFontWeight.bold,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    Text(
                                      stock.name,
                                      style: GoogleFonts.poppins(
                                        fontSize: 10,
                                        fontWeight: CustomFontWeight.regular,
                                        color: themeController.isDarkMode.value
                                            ? Color(
                                                0XFFFFFFFF,
                                              ).withValues(alpha: 0.8)
                                            : Color(
                                                0XFF000000,
                                              ).withValues(alpha: 0.8),
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                flex: 3,
                                child: Text(
                                  homeController
                                      .formatPrice(stockData.close)
                                      .toString(),
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
                                  homeController
                                      .formatPrice(
                                        prediction!.closePrediction,
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
