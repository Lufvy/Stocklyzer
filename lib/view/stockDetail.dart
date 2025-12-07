import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:stocklyzer/IOHelper/IOHelper.dart';
import 'package:stocklyzer/component/StockChart.dart';
import 'package:stocklyzer/component/loading.dart';
import 'package:stocklyzer/config/appTheme.dart';
import 'package:stocklyzer/config/extension.dart';
import 'package:stocklyzer/controller/stockDetailController.dart';
import 'package:stocklyzer/controller/themeController.dart';
import 'package:stocklyzer/dto/stockHistoryDetailDTO.dart';

class StockDetail extends StatefulWidget {
  final String selectedTicker;

  const StockDetail({super.key, required this.selectedTicker});

  @override
  State<StockDetail> createState() => _StockDetailState();
}

class _StockDetailState extends State<StockDetail> {
  final themeController = Get.find<Themecontroller>();
  // final homeController = Get.find<Homecontroller>();
  final stockDetailController = Get.put(StockDetailController());

  @override
  void initState() {
    super.initState();
    stockDetailController.initBookmarkStatus(widget.selectedTicker);
    stockDetailController.initDetailStock(widget.selectedTicker);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(
        () => Stack(
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
                                Get.back(result: true);
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
                              stockDetailController.stockTicker,
                              style: GoogleFonts.poppins(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            InkWell(
                              onTap: stockDetailController.onBookmarkToggled,
                              child: stockDetailController.isBookmarked.value
                                  ? Icon(Icons.bookmark_outlined)
                                  : Icon(Icons.bookmark_border_outlined),
                            ),
                          ],
                        ),

                        stockDetailController.selectedStockGraphData.value !=
                                null
                            ? StockChart(
                                themeController: themeController,
                                context: context,
                                dataGraph: stockDetailController
                                    .selectedStockGraphData
                                    .value!,
                                hoverPoint: stockDetailController
                                    .selectedStockHoverPoint
                                    .value!,
                              )
                            : Container(
                                width: double
                                    .infinity, // Set the desired width in logical pixels
                                height:
                                    335, // Set the desired height in logical pixels
                                decoration: BoxDecoration(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .secondaryContainer, // Set the background color
                                  borderRadius: BorderRadius.circular(
                                    8.0,
                                  ), // Set the corner radius
                                ),
                                child: Center(
                                  child: OverlayLoading(
                                    isBackground: false,
                                    size: 200,
                                  ),
                                ),
                              ),

                        companyInformation(context),
                        predictHistory(
                          context,
                          stockDetailController.stockHistoryDetails,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            if (stockDetailController.isLoading.value) OverlayLoading(),
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
        stockDetailController.selectedStock.value == null
            ? Container(
                width:
                    double.infinity, // Set the desired width in logical pixels
                height: 103, // Set the desired height in logical pixels
                decoration: BoxDecoration(
                  color: Theme.of(
                    context,
                  ).colorScheme.secondaryContainer, // Set the background color
                  borderRadius: BorderRadius.circular(
                    8.0,
                  ), // Set the corner radius
                ),
                child: Center(
                  child: OverlayLoading(isBackground: false, size: 200),
                ),
              )
            : Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.secondaryContainer,
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
                  padding: EdgeInsets.fromLTRB(18, 8, 18, 13),
                  child: Column(
                    spacing: 15,
                    children: [
                      Row(
                        spacing: 10,
                        children: [
                          Image.asset(
                            'assets/tickers/${stockDetailController.stockTicker}.png',
                            width: 38,
                            height: 38,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            spacing: 4,
                            children: [
                              Text(
                                stockDetailController.selectedStock.value!.name,
                                style: GoogleFonts.poppins(
                                  fontSize: 15,
                                  fontWeight: CustomFontWeight.bold,
                                ),
                              ),
                              Text(
                                themeController.isEnglish.value
                                    ? stockDetailController
                                          .selectedStock
                                          .value!
                                          .sector
                                    : stockDetailController
                                          .selectedStock
                                          .value!
                                          .sectorID
                                          .toString(),
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
                        themeController.isEnglish.value
                            ? stockDetailController
                                  .selectedStock
                                  .value!
                                  .description
                            : stockDetailController
                                  .selectedStock
                                  .value!
                                  .descriptionID
                                  .toString(),
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

  Widget predictHistory(
    BuildContext context,
    List<StockHistoryDetailDTO> stockHistoryDetail,
  ) {
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
                  "${StockDetailController.getPercentageDigit(stockDetailController.selectedStock.value?.accuracy ?? 0.0)}%",
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
                  stockHistoryDetail;

                  return ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: stockHistoryDetail.length,
                    itemBuilder: (context, index) {
                      final stockData = stockHistoryDetail[index];
                      final date = stockData.date;
                      final realClose = stockData.close;
                      final prediction = stockData.predictedClose;
                      final accuracy = stockData.accuracy;

                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 3,
                              child: Text(
                                DateFormat('dd/MM/yyyy').format(date),
                                style: GoogleFonts.poppins(fontSize: 11),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Expanded(
                              flex: 3,
                              child: Text(
                                IOHelper.formatPrice(realClose),
                                style: GoogleFonts.poppins(fontSize: 11),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Expanded(
                              flex: 4,
                              child: Text(
                                IOHelper.formatPrice(prediction),
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
                                "${IOHelper.getPercentageDigit(accuracy)}%",
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
