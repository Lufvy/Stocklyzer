import 'dart:ffi';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:stocklyzer/controller/navBarController.dart';
import 'package:stocklyzer/dto/stockGraphDTO.dart';
import 'package:stocklyzer/dto/watchListDTO.dart';
import 'package:stocklyzer/model/MsStock.dart';
import 'package:stocklyzer/model/StockData.dart';
import 'package:stocklyzer/model/StockPrediction.dart';
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

  //TODO: OTW hapus
  final stockData = <StockData>[].obs;
  final stockprediction = <StockPrediction>[].obs;
  final selected_msStock = Rx<MsStock?>(null);

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
        // TODO: re-fetch watchlist data if its invalidated
        print("test");
      }
    });
    // loadInitialData();
  }

  // void loadInitialData() {
  //   watchList.assignAll([
  //     MsStock(
  //       'BBCA',
  //       'Bank Central Asia',
  //       'Finance',
  //       92.3,
  //       'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit. ',
  //       'Banking',
  //     ),
  //     MsStock(
  //       'BBRI',
  //       'Bank Rakyat Indonesia',
  //       'Finance',
  //       93.1,
  //       'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit. ',
  //       'Banking',
  //     ),
  //     MsStock(
  //       'ANTM',
  //       'Aneka Tambang',
  //       'Mining',
  //       94.0,
  //       'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit. ',
  //       'Mining',
  //     ),
  //     MsStock(
  //       'UNVR',
  //       'Unilever Indonesia',
  //       'Consumer Goods',
  //       90.2,
  //       'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit. ',
  //       'FMCG',
  //     ),
  //   ]);

  //   msStock.assignAll([
  //     MsStock(
  //       'BBCA',
  //       'Bank Central Asia',
  //       'Finance',
  //       92.3,
  //       'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit. ',
  //       'Banking',
  //     ),
  //     MsStock(
  //       'BBRI',
  //       'Bank Rakyat Indonesia',
  //       'Finance',
  //       93.1,
  //       'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit. ',
  //       'Banking',
  //     ),
  //     MsStock(
  //       'TLKM',
  //       'Telkom Indonesia',
  //       'Telecommunication',
  //       88.7,
  //       'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit. ',
  //       'Telecom',
  //     ),
  //     MsStock(
  //       'UNVR',
  //       'Unilever Indonesia',
  //       'Consumer Goods',
  //       90.2,
  //       'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit. ',
  //       'FMCG',
  //     ),
  //     MsStock(
  //       'ASII',
  //       'Astra International',
  //       'Automotive',
  //       91.8,
  //       'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit. ',
  //       'Automotive',
  //     ),
  //     MsStock(
  //       'BBNI',
  //       'Bank Negara Indonesia',
  //       'Finance',
  //       91.0,
  //       'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit. ',
  //       'Banking',
  //     ),
  //     MsStock(
  //       'ICBP',
  //       'Indofood CBP Sukses Makmur',
  //       'Consumer Goods',
  //       89.4,
  //       'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit. ',
  //       'FMCG',
  //     ),
  //     MsStock(
  //       'ANTM',
  //       'Aneka Tambang',
  //       'Mining',
  //       94.0,
  //       'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit. ',
  //       'Mining',
  //     ),
  //     MsStock(
  //       'ADRO',
  //       'Adaro Energy',
  //       'Finance',
  //       85.6,
  //       'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit. ',
  //       'Banking',
  //     ),
  //     MsStock(
  //       'INDF',
  //       'Indofood Sukses Makmur',
  //       'Consumer Goods',
  //       90.7,
  //       'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit. ',
  //       'FMCG',
  //     ),
  //     MsStock(
  //       'IHSG',
  //       'Indeks Harga Saham Gabungan',
  //       'Index',
  //       100.0,
  //       'Indeks utama pasar modal Indonesia yang mencerminkan pergerakan harga saham secara keseluruhan di Bursa Efek Indonesia (BEI). IHSG dihitung berdasarkan kapitalisasi pasar dari seluruh saham yang tercatat di BEI dan digunakan sebagai indikator kesehatan ekonomi serta sentimen investor terhadap pasar saham Indonesia.',
  //       'Market Index',
  //     ),
  //   ]);

  //   // 🔹 Data harga riil 5 hari terakhir per saham
  //   stockData.assignAll([
  //     StockData(DateTime(2024, 10, 1), 7100, 'BBCA'),
  //     StockData(DateTime(2024, 10, 2), 7150, 'BBCA'),
  //     StockData(DateTime(2024, 10, 3), 7200, 'BBCA'),
  //     StockData(DateTime(2024, 10, 4), 7240, 'BBCA'),
  //     StockData(DateTime(2024, 10, 5), 7280, 'BBCA'),

  //     StockData(DateTime(2024, 10, 1), 5400, 'BBRI'),
  //     StockData(DateTime(2024, 10, 2), 5440, 'BBRI'),
  //     StockData(DateTime(2024, 10, 3), 5470, 'BBRI'),
  //     StockData(DateTime(2024, 10, 4), 5500, 'BBRI'),
  //     StockData(DateTime(2024, 10, 5), 5530, 'BBRI'),

  //     StockData(DateTime(2024, 10, 1), 3720, 'TLKM'),
  //     StockData(DateTime(2024, 10, 2), 3750, 'TLKM'),
  //     StockData(DateTime(2024, 10, 3), 3780, 'TLKM'),
  //     StockData(DateTime(2024, 10, 4), 3800, 'TLKM'),
  //     StockData(DateTime(2024, 10, 5), 3830, 'TLKM'),

  //     StockData(DateTime(2024, 10, 1), 4650, 'UNVR'),
  //     StockData(DateTime(2024, 10, 2), 4670, 'UNVR'),
  //     StockData(DateTime(2024, 10, 3), 4700, 'UNVR'),
  //     StockData(DateTime(2024, 10, 4), 4720, 'UNVR'),
  //     StockData(DateTime(2024, 10, 5), 4740, 'UNVR'),

  //     StockData(DateTime(2024, 10, 1), 6000, 'ASII'),
  //     StockData(DateTime(2024, 10, 2), 6040, 'ASII'),
  //     StockData(DateTime(2024, 10, 3), 6080, 'ASII'),
  //     StockData(DateTime(2024, 10, 4), 6110, 'ASII'),
  //     StockData(DateTime(2024, 10, 5), 6150, 'ASII'),

  //     StockData(DateTime(2024, 10, 1), 5200, 'BBNI'),
  //     StockData(DateTime(2024, 10, 2), 5230, 'BBNI'),
  //     StockData(DateTime(2024, 10, 3), 5260, 'BBNI'),
  //     StockData(DateTime(2024, 10, 4), 5290, 'BBNI'),
  //     StockData(DateTime(2024, 10, 5), 5330, 'BBNI'),

  //     StockData(DateTime(2024, 10, 1), 10500, 'ICBP'),
  //     StockData(DateTime(2024, 10, 2), 10550, 'ICBP'),
  //     StockData(DateTime(2024, 10, 3), 10600, 'ICBP'),
  //     StockData(DateTime(2024, 10, 4), 10630, 'ICBP'),
  //     StockData(DateTime(2024, 10, 5), 10700, 'ICBP'),

  //     StockData(DateTime(2024, 10, 1), 2400, 'ANTM'),
  //     StockData(DateTime(2024, 10, 2), 2420, 'ANTM'),
  //     StockData(DateTime(2024, 10, 3), 2450, 'ANTM'),
  //     StockData(DateTime(2024, 10, 4), 2470, 'ANTM'),
  //     StockData(DateTime(2024, 10, 5), 2490, 'ANTM'),

  //     StockData(DateTime(2024, 10, 1), 130, 'ADRO'),
  //     StockData(DateTime(2024, 10, 2), 132, 'ADRO'),
  //     StockData(DateTime(2024, 10, 3), 134, 'ADRO'),
  //     StockData(DateTime(2024, 10, 4), 136, 'ADRO'),
  //     StockData(DateTime(2024, 10, 5), 137, 'ADRO'),

  //     StockData(DateTime(2024, 10, 1), 6600, 'INDF'),
  //     StockData(DateTime(2024, 10, 2), 6630, 'INDF'),
  //     StockData(DateTime(2024, 10, 3), 6670, 'INDF'),
  //     StockData(DateTime(2024, 10, 4), 6700, 'INDF'),
  //     StockData(DateTime(2024, 10, 5), 6740, 'INDF'),

  //     StockData(DateTime(2024, 10, 1), 7200, 'IHSG'),
  //     StockData(DateTime(2024, 10, 2), 7230, 'IHSG'),
  //     StockData(DateTime(2024, 10, 3), 7280, 'IHSG'),
  //     StockData(DateTime(2024, 10, 4), 7300, 'IHSG'),
  //     StockData(DateTime(2024, 10, 5), 7250, 'IHSG'),
  //   ]);

  //   // 🔹 Data prediksi 5 hari ke depan per saham
  //   stockprediction.assignAll([
  //     // BBCA
  //     Stockprediction(DateTime(2024, 10, 1), 7100, 'BBCA'),
  //     Stockprediction(DateTime(2024, 10, 2), 7120, 'BBCA'),
  //     Stockprediction(DateTime(2024, 10, 3), 7200, 'BBCA'),
  //     Stockprediction(DateTime(2024, 10, 4), 7170, 'BBCA'),
  //     Stockprediction(DateTime(2024, 10, 5), 7300, 'BBCA'),
  //     Stockprediction(DateTime(2024, 10, 6), 7320, 'BBCA'),
  //     Stockprediction(DateTime(2024, 10, 7), 7350, 'BBCA'),
  //     Stockprediction(DateTime(2024, 10, 8), 7380, 'BBCA'),
  //     Stockprediction(DateTime(2024, 10, 9), 7420, 'BBCA'),
  //     Stockprediction(DateTime(2024, 10, 10), 7460, 'BBCA'),

  //     // BBRI
  //     Stockprediction(DateTime(2024, 10, 1), 5400, 'BBRI'),
  //     Stockprediction(DateTime(2024, 10, 2), 5420, 'BBRI'),
  //     Stockprediction(DateTime(2024, 10, 3), 5480, 'BBRI'),
  //     Stockprediction(DateTime(2024, 10, 4), 5490, 'BBRI'),
  //     Stockprediction(DateTime(2024, 10, 5), 5540, 'BBRI'),
  //     Stockprediction(DateTime(2024, 10, 6), 5550, 'BBRI'),
  //     Stockprediction(DateTime(2024, 10, 7), 5570, 'BBRI'),
  //     Stockprediction(DateTime(2024, 10, 8), 5590, 'BBRI'),
  //     Stockprediction(DateTime(2024, 10, 9), 5610, 'BBRI'),
  //     Stockprediction(DateTime(2024, 10, 10), 5630, 'BBRI'),

  //     // TLKM
  //     Stockprediction(DateTime(2024, 10, 1), 3800, 'TLKM'),
  //     Stockprediction(DateTime(2024, 10, 2), 3820, 'TLKM'),
  //     Stockprediction(DateTime(2024, 10, 3), 3830, 'TLKM'),
  //     Stockprediction(DateTime(2024, 10, 4), 3840, 'TLKM'),
  //     Stockprediction(DateTime(2024, 10, 5), 3850, 'TLKM'),
  //     Stockprediction(DateTime(2024, 10, 6), 3870, 'TLKM'),
  //     Stockprediction(DateTime(2024, 10, 7), 3880, 'TLKM'),
  //     Stockprediction(DateTime(2024, 10, 8), 3900, 'TLKM'),
  //     Stockprediction(DateTime(2024, 10, 9), 3920, 'TLKM'),
  //     Stockprediction(DateTime(2024, 10, 10), 3940, 'TLKM'),

  //     // UNVR
  //     Stockprediction(DateTime(2024, 10, 1), 4720, 'UNVR'),
  //     Stockprediction(DateTime(2024, 10, 2), 4740, 'UNVR'),
  //     Stockprediction(DateTime(2024, 10, 3), 4750, 'UNVR'),
  //     Stockprediction(DateTime(2024, 10, 4), 4760, 'UNVR'),
  //     Stockprediction(DateTime(2024, 10, 5), 4780, 'UNVR'),
  //     Stockprediction(DateTime(2024, 10, 6), 4790, 'UNVR'),
  //     Stockprediction(DateTime(2024, 10, 7), 4800, 'UNVR'),
  //     Stockprediction(DateTime(2024, 10, 8), 4820, 'UNVR'),
  //     Stockprediction(DateTime(2024, 10, 9), 4830, 'UNVR'),
  //     Stockprediction(DateTime(2024, 10, 10), 4840, 'UNVR'),

  //     // ASII
  //     Stockprediction(DateTime(2024, 10, 1), 6100, 'ASII'),
  //     Stockprediction(DateTime(2024, 10, 2), 6120, 'ASII'),
  //     Stockprediction(DateTime(2024, 10, 3), 6150, 'ASII'),
  //     Stockprediction(DateTime(2024, 10, 4), 6170, 'ASII'),
  //     Stockprediction(DateTime(2024, 10, 5), 6190, 'ASII'),
  //     Stockprediction(DateTime(2024, 10, 6), 6210, 'ASII'),
  //     Stockprediction(DateTime(2024, 10, 7), 6230, 'ASII'),
  //     Stockprediction(DateTime(2024, 10, 8), 6250, 'ASII'),
  //     Stockprediction(DateTime(2024, 10, 9), 6270, 'ASII'),
  //     Stockprediction(DateTime(2024, 10, 10), 6290, 'ASII'),

  //     // BBNI
  //     Stockprediction(DateTime(2024, 10, 1), 5300, 'BBNI'),
  //     Stockprediction(DateTime(2024, 10, 2), 5320, 'BBNI'),
  //     Stockprediction(DateTime(2024, 10, 3), 5330, 'BBNI'),
  //     Stockprediction(DateTime(2024, 10, 4), 5350, 'BBNI'),
  //     Stockprediction(DateTime(2024, 10, 5), 5370, 'BBNI'),
  //     Stockprediction(DateTime(2024, 10, 6), 5390, 'BBNI'),
  //     Stockprediction(DateTime(2024, 10, 7), 5410, 'BBNI'),
  //     Stockprediction(DateTime(2024, 10, 8), 5430, 'BBNI'),
  //     Stockprediction(DateTime(2024, 10, 9), 5440, 'BBNI'),
  //     Stockprediction(DateTime(2024, 10, 10), 5450, 'BBNI'),

  //     // ICBP
  //     Stockprediction(DateTime(2024, 10, 1), 10600, 'ICBP'),
  //     Stockprediction(DateTime(2024, 10, 2), 10650, 'ICBP'),
  //     Stockprediction(DateTime(2024, 10, 3), 10700, 'ICBP'),
  //     Stockprediction(DateTime(2024, 10, 4), 10730, 'ICBP'),
  //     Stockprediction(DateTime(2024, 10, 5), 10750, 'ICBP'),
  //     Stockprediction(DateTime(2024, 10, 6), 10780, 'ICBP'),
  //     Stockprediction(DateTime(2024, 10, 7), 10820, 'ICBP'),
  //     Stockprediction(DateTime(2024, 10, 8), 10860, 'ICBP'),
  //     Stockprediction(DateTime(2024, 10, 9), 10890, 'ICBP'),
  //     Stockprediction(DateTime(2024, 10, 10), 10900, 'ICBP'),

  //     // ANTM
  //     Stockprediction(DateTime(2024, 10, 1), 2460, 'ANTM'),
  //     Stockprediction(DateTime(2024, 10, 2), 2480, 'ANTM'),
  //     Stockprediction(DateTime(2024, 10, 3), 2490, 'ANTM'),
  //     Stockprediction(DateTime(2024, 10, 4), 2500, 'ANTM'),
  //     Stockprediction(DateTime(2024, 10, 5), 2520, 'ANTM'),
  //     Stockprediction(DateTime(2024, 10, 6), 2530, 'ANTM'),
  //     Stockprediction(DateTime(2024, 10, 7), 2540, 'ANTM'),
  //     Stockprediction(DateTime(2024, 10, 8), 2560, 'ANTM'),
  //     Stockprediction(DateTime(2024, 10, 9), 2570, 'ANTM'),
  //     Stockprediction(DateTime(2024, 10, 10), 2580, 'ANTM'),

  //     // BBKP
  //     Stockprediction(DateTime(2024, 10, 1), 135, 'ADRO'),
  //     Stockprediction(DateTime(2024, 10, 2), 136, 'ADRO'),
  //     Stockprediction(DateTime(2024, 10, 3), 137, 'ADRO'),
  //     Stockprediction(DateTime(2024, 10, 4), 138, 'ADRO'),
  //     Stockprediction(DateTime(2024, 10, 5), 139, 'ADRO'),
  //     Stockprediction(DateTime(2024, 10, 6), 140, 'ADRO'),
  //     Stockprediction(DateTime(2024, 10, 7), 141, 'ADRO'),
  //     Stockprediction(DateTime(2024, 10, 8), 142, 'ADRO'),
  //     Stockprediction(DateTime(2024, 10, 9), 143, 'ADRO'),
  //     Stockprediction(DateTime(2024, 10, 10), 144, 'ADRO'),

  //     // INDF
  //     Stockprediction(DateTime(2024, 10, 1), 6700, 'INDF'),
  //     Stockprediction(DateTime(2024, 10, 2), 6720, 'INDF'),
  //     Stockprediction(DateTime(2024, 10, 3), 6740, 'INDF'),
  //     Stockprediction(DateTime(2024, 10, 4), 6760, 'INDF'),
  //     Stockprediction(DateTime(2024, 10, 5), 6780, 'INDF'),
  //     Stockprediction(DateTime(2024, 10, 6), 6800, 'INDF'),
  //     Stockprediction(DateTime(2024, 10, 7), 6820, 'INDF'),
  //     Stockprediction(DateTime(2024, 10, 8), 6840, 'INDF'),
  //     Stockprediction(DateTime(2024, 10, 9), 6860, 'INDF'),
  //     Stockprediction(DateTime(2024, 10, 10), 6880, 'INDF'),

  //     // IHSG
  //     Stockprediction(DateTime(2024, 10, 1), 7270, 'IHSG'),
  //     Stockprediction(DateTime(2024, 10, 2), 7300, 'IHSG'),
  //     Stockprediction(DateTime(2024, 10, 3), 7320, 'IHSG'),
  //     Stockprediction(DateTime(2024, 10, 4), 7330, 'IHSG'),
  //     Stockprediction(DateTime(2024, 10, 5), 7360, 'IHSG'),
  //     Stockprediction(DateTime(2024, 10, 6), 7380, 'IHSG'),
  //     Stockprediction(DateTime(2024, 10, 7), 7390, 'IHSG'),
  //     Stockprediction(DateTime(2024, 10, 8), 7400, 'IHSG'),
  //     Stockprediction(DateTime(2024, 10, 9), 7410, 'IHSG'),
  //     Stockprediction(DateTime(2024, 10, 10), 7420, 'IHSG'),
  //   ]);
  // }
}
