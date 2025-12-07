import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stocklyzer/dto/stockGraphDTO.dart';
import 'package:stocklyzer/dto/stockHistoryDetailDTO.dart';
import 'package:stocklyzer/model/MsStock.dart';
import 'package:stocklyzer/repository/stock_repository.dart';
import 'package:stocklyzer/repository/user_repository.dart';
import 'package:stocklyzer/services/supabase/supabase_auth_manager.dart';

class StockDetailController extends GetxController {
  final Rx<DateTime?> currentTrackedDate = Rx<DateTime?>(null);
  final StockRepository stockRepository = Get.find<StockRepository>();
  final AuthService authService = Get.find<AuthService>();
  final UserRepository userRepository = Get.find<UserRepository>();

  var isLoading = true.obs;

  final Rxn<MsStock> selectedStock = Rxn();
  var selectedStockGraphData = Rxn<StockGraphDTO>();
  var selectedStockHoverPoint = Rxn<StockGraphHoverPoint>();
  var stockHistoryDetails = <StockHistoryDetailDTO>[].obs;

  var isBookmarked = false.obs;

  String get stockTicker {
    final ticker = selectedStock.value?.ticker ?? '';
    return ticker.length >= 3 ? ticker.substring(0, ticker.length - 3) : ticker;
  }

  void initBookmarkStatus(String ticker) async {
    final email = authService.currentlyLoggedUser.value?.email;
    try {
      final bookmarks = await stockRepository.getUserWatchlist(email!);
      isBookmarked.value = bookmarks.any((stock) {
        return stock.ticker == ticker;
      });
    } catch (e) {
      print("Error fetching bookmark status: $e");
    }
  }

  void onBookmarkToggled() async {
    isBookmarked.value = !isBookmarked.value;

    // Handle adding/removing bookmark in the database
    if (isBookmarked.value) {
      userRepository.addWatchList([selectedStock.value!.ticker]);
    } else {
      userRepository.removeWatchList([selectedStock.value!.ticker]);
    }

    // Invalidate redis cache
    stockRepository.invalidateUserWatchlistCache(
      authService.currentlyLoggedUser.value!.email,
    );

    // Set preferences to refresh navbar watchlist
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isNavbarWatchlistRefreshNeeded', true);
  }

  void initDetailStock(String ticker) async {
    isLoading.value = true;
    try {
      final queryTicker = "$ticker.JK";
      fetchMsStockDetail(queryTicker);
      populateSelectedStockGraph(queryTicker);
      fetchStockHistoryDetail(queryTicker);
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

  void fetchStockHistoryDetail(String ticker) async {
    try {
      stockHistoryDetails.value = await stockRepository.getStockHistoryDetail(
        ticker: ticker,
      );

      if (stockHistoryDetails.isNotEmpty) {
        // Set the current tracked date to the most recent date
        currentTrackedDate.value = stockHistoryDetails.first.date;
      }
    } catch (e) {
      print("Error fetching stock history detail: $e");
    }
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
