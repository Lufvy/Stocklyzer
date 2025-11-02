import 'package:get/get.dart';

class Searchcontroller extends GetxController {
  var selectedIndex = 0.obs;
  final List<String> categories = [
    'All',
    'Technology',
    'Finance & Banking',
    'Consumer Goods',
    'Energy',
    'Mining',
    'Property & Construction',
    'Healthcare',
    'Transportation',
    'Manufacturing',
    'Telecommunication',
  ];
}
