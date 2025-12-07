import 'package:get/get.dart';

class Navbarcontroller extends GetxController {
  var selectedIndex = 0.obs;

  void changeTab(int index) {
    selectedIndex.value = index;
  }

  @override
  void onInit() {
    super.onInit();

    changeTab(0);
  }
}
