import 'package:get/get.dart';
import 'package:stocklyzer/repository/user_repository.dart';
import 'package:stocklyzer/services/supabase/supabase_auth_manager.dart';
import 'package:stocklyzer/services/supabase/supabase_manager.dart';

class ProfileController extends GetxController {
  final authService = Get.find<AuthService>();
  final _client = SupabaseManager().client;
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

  void populateProfile() async {
    final user = _client.auth.currentUser;
    if (user != null) {
      // You can populate additional profile data here if needed
      final email = user.email;

      if (email == null) {
        return;
      }

      this.email.value = email;

      final userData = await userRepository.getUserByEmail(email);

      if (userData != null) {
        name.value = userData.name;
      }
    }
  }

  @override
  void onInit() {
    super.onInit();
    populateProfile();
  }
}
