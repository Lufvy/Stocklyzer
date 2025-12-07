import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stocklyzer/controller/navBarController.dart';
import 'package:stocklyzer/dto/stockGraphDTO.dart';
import 'package:stocklyzer/dto/watchListDTO.dart';
import 'package:stocklyzer/repository/stock_repository.dart';
import 'package:stocklyzer/services/supabase/supabase_auth_manager.dart';

class Homecontroller extends GetxController {
  final authService = Get.find<AuthService>();
  final stockRepository = Get.find<StockRepository>();
  final navBar = Get.find<Navbarcontroller>();

  var name = ''.obs;
  final Rx<DateTime?> currentTrackedDate = Rx<DateTime?>(null);

  var isWatchListLoading = false.obs;
  var isIHSGGraphLoading = false.obs;

  var IHSGGraphData = Rxn<StockGraphDTO>();
  var IHSGHoverPoint = Rxn<StockGraphHoverPoint>();

  var watchListData = <WatchListDTO>[].obs;

  void populateIHSGGraph() async {
    isIHSGGraphLoading.value = true;
    final ihsgGraphData = await stockRepository.getStockGraph('^JKSE');

    IHSGGraphData.value = ihsgGraphData;
    isIHSGGraphLoading.value = false;

    // Grab latest data point for hover point
    if (ihsgGraphData.stockData.isNotEmpty) {
      final latestData = ihsgGraphData.stockData.first;
      final latestPrediction = ihsgGraphData.stockPrediction.isNotEmpty
          ? ihsgGraphData.stockPrediction.first
          : null;

      updateIHSGHoverPoint(
        latestData.date,
        latestData.close,
        latestPrediction?.closePrediction,
      );
    }
  }

  void updateIHSGHoverPoint(
    DateTime date,
    double closePrice,
    double? predictedClosePrice,
  ) {
    IHSGHoverPoint.value = StockGraphHoverPoint(
      date: date,
      closePrice: closePrice,
      predictedClosePrice: predictedClosePrice,
    );
  }

  void populateWatchlist() async {
    isWatchListLoading.value = true;
    final email = authService.currentlyLoggedUser.value?.email;
    if (email == null) {
      return;
    }

    final fetchedWatchlist = await stockRepository.getUserWatchlist(email);

    watchListData.value = fetchedWatchlist;
    isWatchListLoading.value = false;
  }

  void populateProfileData() async {
    final user = authService.currentlyLoggedUser;

    if (user.value == null) {
      return;
    }

    name.value = user.value!.name;
  }

  @override
  void onInit() {
    super.onInit();
    populateProfileData();
    populateWatchlist();
    populateIHSGGraph();

    ever(navBar.selectedIndex, (index) {
      if (index == 0) {
        handleNavbarWatchlistRefresh();
      }
    });
  }

  void handleNavbarWatchlistRefresh() async {
    final prefs = await SharedPreferences.getInstance();
    final isRefreshNeeded =
        prefs.getBool('isNavbarWatchlistRefreshNeeded') ?? false;

    if (isRefreshNeeded) {
      populateWatchlist();
      await prefs.setBool('isNavbarWatchlistRefreshNeeded', false);
    }
  }
}
