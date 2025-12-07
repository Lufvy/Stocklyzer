import 'package:get/get.dart';
import 'package:stocklyzer/controller/themeController.dart';
import 'package:stocklyzer/model/MsStock.dart';
import 'package:stocklyzer/repository/stock_repository.dart';

class Searchcontroller extends GetxController {
  final StockRepository stockRepository = Get.find<StockRepository>();
  final Themecontroller themeController = Get.find<Themecontroller>();

  var selectedIndex = 0.obs;

  List<String> get uniqueSectors {
    final sectors = listOfAllStocks
        .map(
          (stock) => themeController.isEnglish.value
              ? stock.sector
              : stock.sectorID.toString(),
        )
        .where((sector) => sector.isNotEmpty)
        .toSet()
        .toList();

    sectors.insert(0, "All");
    return sectors;
  }

  var listOfAllStocks = <MsStock>[].obs;

  var isLoading = false.obs;

  String get filterQuery {
    return uniqueSectors[selectedIndex.value];
  }

  var searchQuery = ''.obs;

  List<MsStock> get filteredStocks {
    final filteredBySector = filterQuery == 'All'
        ? listOfAllStocks
        : listOfAllStocks.where((stock) {
            final sector = themeController.isEnglish.value
                ? stock.sector
                : stock.sectorID.toString();
            return sector == filterQuery;
          }).toList();

    if (searchQuery.value.isEmpty) {
      return filteredBySector;
    }

    final query = searchQuery.value.toLowerCase();

    return filteredBySector.where((stock) {
      return stock.name.toLowerCase().contains(query) ||
          stock.ticker.toLowerCase().contains(query);
    }).toList();
  }

  void getStock() async {
    isLoading.value = true;
    try {
      final stocks = (await stockRepository.getAllStocks())
          .where((e) => e != null)
          .cast<MsStock>()
          .where(
            (stock) => !stock.ticker.startsWith('^'),
          ) // filter out ^ tickers
          .map((stock) {
            stock.ticker = stock.ticker.substring(0, stock.ticker.length - 3);
            return stock;
          })
          .toList();

      // Remove tickers starting with '^' (^ JKSE)
      stocks.removeWhere((stock) => stock.ticker.startsWith('^'));

      listOfAllStocks.value = stocks;
    } catch (e) {
      print("Error fetching stocks: $e");
    }
    isLoading.value = false;
  }

  @override
  void onInit() async {
    // TODO: implement onInit
    super.onInit();

    getStock();
  }
}
