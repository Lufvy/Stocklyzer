import 'package:get/get.dart';
import 'package:stocklyzer/component/snackBar.dart';
import 'package:stocklyzer/controller/themeController.dart';
import 'package:stocklyzer/model/MsStock.dart';
import 'package:stocklyzer/repository/stock_repository.dart';
import 'package:stocklyzer/repository/user_repository.dart';
import 'package:stocklyzer/view/navBar.dart';

class Userpersonalizationcontroller extends GetxController {
  final StockRepository stockRepository = Get.find<StockRepository>();
  final UserRepository userRepository = Get.find<UserRepository>();
  final Themecontroller themeController = Get.find<Themecontroller>();

  final isLoading = false.obs;

  final watchlist = <String, List<Map<String, dynamic>>>{}.obs;

  List<String> get selectedwatchList => watchlist.values
      .expand((e) => e)
      .where((stock) => stock['selected'] == true)
      .map((stock) => stock['name'] as String)
      .toList();

  int get watchListSelectedCount => watchlist.values
      .expand((e) => e)
      .where((stock) => stock['selected'] == true)
      .length;

  void populatePersonalizedStock() async {
    isLoading.value = true;
    try {
      final stocks = (await stockRepository.getAllStocks())
          .where((e) => e != null)
          .cast<MsStock>()
          .toList();

      // Remove tickers starting with '^' (^ JKSE)
      stocks.removeWhere((stock) => stock.ticker.startsWith('^'));

      // Grouping by sector
      final grouped = <String, List<Map<String, dynamic>>>{};

      for (var stock in stocks) {
        final sector = themeController.isEnglish.value
            ? stock.sector
            : stock.sectorID;

        if (sector == null) continue;

        grouped.putIfAbsent(sector, () => []);

        grouped[sector]!.add({
          'name': stock.ticker.substring(0, stock.ticker.length - 3),
          'selected': false,
        });
      }

      // Assign to observable map
      watchlist.assignAll(grouped);
      isLoading.value = false;
    } catch (e) {
      print("Error fetching stocks: $e");
    }
  }

  void onFloatingButtonPressed() async {
    isLoading.value = true;
    // Check if any stock is selected
    // If none selected, skip and navigate to Navbar
    if (selectedwatchList.isEmpty) {
      Get.offAll(() => Navbar());
      return;
    }
    // set user Watchlist
    print("Selected Stocks: $selectedwatchList");

    // Append ".JK" to each ticker
    final formattedList = selectedwatchList
        .map((ticker) => "${ticker.toUpperCase()}.JK")
        .toList();

    final response = await userRepository.addWatchList(formattedList);

    if (response) {
      Get.offAll(() => Navbar());
    } else {
      SnackbarHelper.show(
        title: 'userPeronalizationErrorTitle'.tr,
        message: 'userPeronalizationErrorMessage'.tr,
        type: SnackType.error,
      );
    }
    isLoading.value = false;
  }

  @override
  void onInit() {
    super.onInit();
    // Initial population of stocks
    populatePersonalizedStock();

    // Set user to not new
    userRepository.updateIsNewUser(false);
  }
}
