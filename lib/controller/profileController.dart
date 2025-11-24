import 'package:get/get.dart';
import 'package:stocklyzer/services/supabase/supabase_auth_manager.dart';

class ProfileController extends GetxController {
  final authService = Get.find<AuthService>();

  final isLoading = false.obs;

  void onUserLogout() async {
    isLoading.value = true;
    try {
      await authService.signOut();
    } finally {
      isLoading.value = false;
    }
  }
}
