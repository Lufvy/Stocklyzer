import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:stocklyzer/IOHelper/IOHelper.dart';
import 'package:stocklyzer/config/extension.dart';
import 'package:stocklyzer/controller/themeController.dart';
import 'package:stocklyzer/dto/stockGraphDTO.dart';
import 'package:stocklyzer/model/StockData.dart';
import 'package:stocklyzer/model/StockPrediction.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class StockChart extends StatelessWidget {
  StockChart({
    super.key,
    required this.themeController,
    required this.context,
    required this.dataGraph,
    required this.hoverPoint,
  });

  final Themecontroller themeController;
  final BuildContext context;
  final StockGraphDTO dataGraph;
  final StockGraphHoverPoint hoverPoint;
  final Rx<DateTime?> currentTrackedDate = Rx<DateTime?>(null);

  @override
  Widget build(BuildContext context) {
    final currentDate = DateTime.now();
    final actualData = dataGraph.stockData
        .where((s) => s.date.isBefore(currentDate))
        .toList();

    final predictedData = dataGraph.stockPrediction
        // .where((s) => s.date.isAfter(currentDate))
        .toList();

    final double yAxisMin;
    final double yAxisMax;

    final List<double> allPrices = [
      ...actualData.map((s) => s.close) ?? [],
      ...predictedData.map((s) => s.closePrediction),
    ];

    if (allPrices.isEmpty) {
      // Safety fallback when data is loading or missing
      yAxisMin = 0.0;
      yAxisMax = 1.0;
    } else {
      final double calculatedMin = allPrices
          .map((e) => e.toDouble())
          .reduce(min);
      final double calculatedMax = allPrices
          .map((e) => e.toDouble())
          .reduce(max);

      // Set buffer: use 1% of the range or a minimum of 100, whichever is larger.
      const double minimumBuffer = 100.0;
      final double dynamicBuffer = (calculatedMax - calculatedMin) * 0.01;
      final double buffer = max(minimumBuffer, dynamicBuffer);

      yAxisMin = calculatedMin - buffer;
      yAxisMax = calculatedMax + buffer;
    }

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
            if (dataGraph.ticker == '^JKSE')
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IntrinsicWidth(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          dataGraph.ticker == '^JKSE'
                              ? 'IHSG'
                              : dataGraph.ticker.substring(
                                  0,
                                  dataGraph.ticker.length - 3,
                                ),
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
                        '${IOHelper.getPercentageDigit(dataGraph.totalAccuracy)}%',
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
              DateFormat('dd/MM/yyyy').format(hoverPoint.date),
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
                      IOHelper.formatPrice(hoverPoint.closePrice),
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
                      hoverPoint.predictedClosePrice != null
                          ? IOHelper.formatPrice(
                              hoverPoint.predictedClosePrice ?? 0,
                            )
                          : "-",
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
                      hoverPoint.accuracy != null
                          ? '${IOHelper.getPercentageDigit(hoverPoint.accuracy!)}%'
                          : "-",
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
                    if (points.isEmpty) {
                      currentTrackedDate.value = currentDate;
                      return const SizedBox.shrink();
                    }

                    final date = points.first.x as DateTime;

                    currentTrackedDate.value = date;
                    final dateText = DateFormat('MMM dd, yyyy').format(date);

                    final actual = actualData.firstWhereOrNull(
                      (s) => IOHelper.sameDate(s.date, date),
                    );
                    final predicted = predictedData.firstWhereOrNull(
                      (s) => IOHelper.sameDate(s.date, date),
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
                              'Actual: Rp ${IOHelper.formatPrice(actual.close)}',
                              style: const TextStyle(
                                color: Colors.greenAccent,
                                fontSize: 12,
                              ),
                            ),
                          if (predicted != null)
                            Text(
                              'Predicted: Rp ${IOHelper.formatPrice(predicted.closePrediction)}',
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
                  minimum: yAxisMin,
                  maximum: yAxisMax,
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
                  LineSeries<StockPrediction, DateTime>(
                    name: 'Predicted',
                    dataSource: predictedData,
                    xValueMapper: (StockPrediction stock, _) => stock.date,
                    yValueMapper: (StockPrediction stock, _) =>
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
}
