import 'package:get/get.dart';

class Userpersonalizationcontroller extends GetxController {
  final watchlist = <Map<String, dynamic>>[
    {'name': 'BBCA', 'selected': false},
    {'name': 'BBCA', 'selected': false},
    {'name': 'BBCA', 'selected': false},
    {'name': 'BBCA', 'selected': false},
    {'name': 'BBCA', 'selected': false},
    {'name': 'BBCA', 'selected': false},
  ].obs;

  List<String> get selectedwatchList => watchlist
      .where((stock) => stock['selected'] == true)
      .map((stock) => stock['name'] as String)
      .toList();
}
