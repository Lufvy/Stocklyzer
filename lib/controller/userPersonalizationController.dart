import 'package:get/get.dart';

class Userpersonalizationcontroller extends GetxController {
  final watchlist = <Map<String, dynamic>>[
    {'name': 'BBCA', 'selected': false},
<<<<<<< HEAD:lib/controllers/userPersonalizationController.dart
    {'name': 'BBCA', 'selected': false},
    {'name': 'BBCA', 'selected': false},
    {'name': 'BBCA', 'selected': false},
    {'name': 'BBCA', 'selected': false},
    {'name': 'BBCA', 'selected': false},
=======
    {'name': 'BBRI', 'selected': false},
    {'name': 'INCO', 'selected': false},
    {'name': 'ADMR', 'selected': false},
    {'name': 'BBTN', 'selected': false},
    {'name': 'KLBF', 'selected': false},
>>>>>>> origin/main:lib/controller/userPersonalizationController.dart
  ].obs;

  List<String> get selectedwatchList => watchlist
      .where((stock) => stock['selected'] == true)
      .map((stock) => stock['name'] as String)
      .toList();
}
