import 'package:get/get.dart';
import 'package:stocklyzer/repository/user_repository.dart';
import 'package:stocklyzer/services/supabase/supabase_auth_manager.dart';

class ProfileController extends GetxController {
  final authService = Get.find<AuthService>();
  final UserRepository userRepository = Get.find<UserRepository>();

  var name = ''.obs;
  var email = ''.obs;

  final isLoading = false.obs;

  void onUserLogout() async {
    isLoading.value = true;
    try {
      await authService.signOut();
    } finally {
      isLoading.value = false;
    }
  }

  void populateProfile() {
    final user = authService.currentlyLoggedUser;

    if (user.value == null) {
      return;
    }
    name.value = user.value!.name;
    email.value = user.value!.email;
  }

  @override
  void onInit() {
    super.onInit();
    populateProfile();
  }
}
