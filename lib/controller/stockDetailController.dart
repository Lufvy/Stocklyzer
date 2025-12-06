import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:stocklyzer/dto/stockGraphDTO.dart';
import 'package:stocklyzer/model/MsStock.dart';
import 'package:stocklyzer/repository/stock_repository.dart';

class StockDetailController extends GetxController {
  final Rx<DateTime?> currentTrackedDate = Rx<DateTime?>(null);
  final stockRepository = Get.find<StockRepository>();

  var isLoading = true.obs;

  final Rxn<MsStock> selectedStock = Rxn();
  var selectedStockGraphData = Rxn<StockGraphDTO>();
  var selectedStockHoverPoint = Rxn<StockGraphHoverPoint>();

  String get stockTicker {
    final ticker = selectedStock.value?.ticker ?? '';
    return ticker.length >= 3 ? ticker.substring(0, ticker.length - 3) : ticker;
  }

  void initDetailStock(String ticker) async {
    isLoading.value = true;
    try {
      final queryTicker = "$ticker.JK";
      fetchMsStockDetail(queryTicker);
      populateSelectedStockGraph(queryTicker);
      // TODO: fetch 20 latest record for this ticker
    } finally {
      isLoading.value = false;
    }
  }

  void fetchMsStockDetail(String ticker) async {
    try {
      final stockDetail = await stockRepository.getStockByTicker(ticker);
      selectedStock.value = stockDetail;
    } catch (e) {
      print("Error fetching stock detail: $e");
    }
  }

  void populateSelectedStockGraph(String ticker) async {
    try {
      selectedStockGraphData.value = await stockRepository.getStockGraph(
        ticker,
      );

      // Grab latest data point for hover point
      if (selectedStockGraphData.value?.stockData.isNotEmpty ?? false) {
        final latestData = selectedStockGraphData.value!.stockData.first;
        final latestPrediction =
            selectedStockGraphData.value!.stockPrediction.isNotEmpty
            ? selectedStockGraphData.value!.stockPrediction.first
            : null;

        updateSelectedStockHoverPoint(
          latestData.date,
          latestData.close,
          latestPrediction?.closePrediction,
        );
      }
    } catch (e) {
      print("Error fetching stock graph data: $e");
    }
  }

  void updateSelectedStockHoverPoint(
    DateTime date,
    double closePrice,
    double? predictedClosePrice,
  ) {
    selectedStockHoverPoint.value = StockGraphHoverPoint(
      date: date,
      closePrice: closePrice,
      predictedClosePrice: predictedClosePrice,
    );
  }

  bool sameDate(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  static String formatPrice(double value) {
    final f = NumberFormat.currency(
      locale: 'en_US',
      symbol: '',
      decimalDigits: 2,
    );
    return f.format(value);
  }

  static int getPercentageDigit(double value) {
    // Multiplies the decimal (e.g., 0.95) by 100 and truncates the result
    return (value * 100).truncate();
  }
}
