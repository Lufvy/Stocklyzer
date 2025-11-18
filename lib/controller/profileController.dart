import 'package:get/get.dart';
import 'package:stocklyzer/services/supabase/supabase_auth_manager.dart';
import 'package:stocklyzer/view/onboarding.dart';

class ProfileController extends GetxController {
  final authService = Get.find<AuthService>();

  final isLoading = false.obs;

  void onUserLogout() async {
    isLoading.value = true;
    await authService.signOut();
    isLoading.value = false;
  }
}
