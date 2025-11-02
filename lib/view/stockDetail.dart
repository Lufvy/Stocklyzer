import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:stocklyzer/config/appTheme.dart';
import 'package:stocklyzer/config/extension.dart';
import 'package:stocklyzer/controller/homeController.dart';
import 'package:stocklyzer/controller/themeController.dart';
import 'package:stocklyzer/model/StockData.dart';
import 'package:stocklyzer/model/StockPrediction.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class Stockdetail extends StatelessWidget {
  Stockdetail({super.key});
  final themeController = Get.find<Themecontroller>();
  final homeController = Get.find<Homecontroller>();

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
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  // vertical: 15,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 15,
                  children: [
                    Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            Get.back();
                          },
                          icon: Icon(
                            Icons.arrow_back,
                            color: Theme.of(context).colorScheme.onPrimary,
                          ),
                        ),
                        Text(
                          'Back',
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            fontWeight: CustomFontWeight.light,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          homeController.selected_msStock.value!.ticker,
                          style: GoogleFonts.poppins(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        InkWell(
                          onTap: () {},
                          child: Icon(Icons.bookmark_border_outlined),
                        ),
                      ],
                    ),
                    mainChart(context),
                    companyInformation(context),

                    predictHistory(context),
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
    final ticker = homeController.selected_msStock.value!.ticker;
    final actualData = homeController.stockData
        .where((s) => s.ticker == ticker)
        .where((s) => s.date.isBefore(DateTime(2024, 10, 6)))
        .toList();

    final predictedData = homeController.stockprediction
        .where((s) => s.ticker == ticker)
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
            Text(
              '05/10/2024',
              style: GoogleFonts.poppins(
                fontSize: 15,
                fontWeight: CustomFontWeight.medium,
              ),
            ),
            Obx(() {
              var actual = homeController.stockData.firstWhereOrNull(
                (s) =>
                    s.ticker == homeController.selected_msStock.value?.ticker &&
                    s.date == DateTime(2024, 10, 5),
              );

              var prediction = homeController.stockprediction.firstWhereOrNull(
                (p) =>
                    p.ticker == homeController.selected_msStock.value?.ticker &&
                    p.date == DateTime(2024, 10, 6),
              );

              return Row(
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
                        actual != null
                            ? homeController.formatPrice(actual.close)
                            : '-',
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
                        prediction != null
                            ? homeController.formatPrice(
                                prediction.closePrediction,
                              )
                            : '-',
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
              );
            }),
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

  Widget companyInformation(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 15,
      children: [
        IntrinsicWidth(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Company Information',
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
        Container(
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
            padding: EdgeInsets.fromLTRB(18, 8, 18, 13),
            child: Column(
              spacing: 15,
              children: [
                Row(
                  spacing: 10,
                  children: [
                    Image.asset(
                      'assets/tickers/${homeController.selected_msStock.value!.ticker}.png',
                      width: 38,
                      height: 38,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 4,
                      children: [
                        Text(
                          homeController.selected_msStock.value!.name,
                          style: GoogleFonts.poppins(
                            fontSize: 15,
                            fontWeight: CustomFontWeight.bold,
                          ),
                        ),
                        Text(
                          homeController.selected_msStock.value!.sector,
                          style: GoogleFonts.poppins(
                            fontSize: 10,
                            color: themeController.isDarkMode.value
                                ? Colors.white.withValues(alpha: 0.8)
                                : Colors.black.withValues(alpha: 0.8),
                            fontWeight: CustomFontWeight.regular,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                Text(
                  homeController.selected_msStock.value!.description,
                  style: GoogleFonts.poppins(
                    fontSize: 10,
                    color: themeController.isDarkMode.value
                        ? Colors.white.withValues(alpha: 0.9)
                        : Colors.black.withValues(alpha: 0.9),
                    fontWeight: CustomFontWeight.light,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget predictHistory(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 15,
      children: [
        IntrinsicWidth(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Predict History',
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

        Container(
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
            padding: const EdgeInsets.all(10),
            child: Row(
              spacing: 10,
              children: [
                Image.asset('assets/accuracy.png', width: 34, height: 29),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 4,
                    children: [
                      Text(
                        'AI Accuracy',
                        style: GoogleFonts.poppins(
                          fontSize: 15,
                          fontWeight: CustomFontWeight.bold,
                        ),
                      ),
                      Text(
                        'of predicting this stock',
                        style: GoogleFonts.poppins(
                          fontSize: 10,
                          color: themeController.isDarkMode.value
                              ? Colors.white.withValues(alpha: 0.8)
                              : Colors.black.withValues(alpha: 0.8),
                          fontWeight: CustomFontWeight.regular,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  '100%',
                  style: GoogleFonts.poppins(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0XFF00C9E7),
                  ),
                ),
              ],
            ),
          ),
        ),
        Container(
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
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
            child: Column(
              spacing: 10,
              children: [
                Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: Text(
                        'Date',
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
                        'Real Price',
                        style: GoogleFonts.poppins(
                          fontSize: 13,
                          fontWeight: CustomFontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Expanded(
                      flex: 4,
                      child: Text(
                        'Predicted Price',
                        style: GoogleFonts.poppins(
                          fontSize: 13,
                          fontWeight: CustomFontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Text(
                        'AI%',
                        style: GoogleFonts.poppins(
                          fontSize: 13,
                          fontWeight: CustomFontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),

                Obx(() {
                  var stockDataList = homeController.stockData
                      .where(
                        (s) =>
                            s.ticker ==
                            homeController.selected_msStock.value?.ticker,
                      )
                      .toList();

                  return ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: stockDataList.length,
                    itemBuilder: (context, index) {
                      final stockData = stockDataList[index];

                      final prediction = homeController.stockprediction
                          .firstWhereOrNull(
                            (p) =>
                                p.ticker ==
                                    homeController
                                        .selected_msStock
                                        .value
                                        ?.ticker &&
                                p.date == stockData.date,
                          );

                      double? accuracy;
                      if (prediction != null && stockData.close > 0) {
                        final diff =
                            (stockData.close - prediction.closePrediction)
                                .abs();
                        accuracy = (1 - diff / stockData.close) * 100;
                      }

                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 3,
                              child: Text(
                                DateFormat('dd/MM/yyyy').format(stockData.date),
                                style: GoogleFonts.poppins(fontSize: 11),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Expanded(
                              flex: 3,
                              child: Text(
                                homeController.formatPrice(stockData.close),
                                style: GoogleFonts.poppins(fontSize: 11),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Expanded(
                              flex: 4,
                              child: Text(
                                prediction != null
                                    ? homeController.formatPrice(
                                        prediction.closePrediction,
                                      )
                                    : '-',
                                style: GoogleFonts.poppins(
                                  fontSize: 11,
                                  color: Color(0XFFFFB700),
                                ),

                                textAlign: TextAlign.center,
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Text(
                                accuracy != null
                                    ? '${accuracy.toStringAsFixed(1)}%'
                                    : '-',
                                style: GoogleFonts.poppins(
                                  fontSize: 11,
                                  color: Color(0XFF00C9E7),
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                }),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
