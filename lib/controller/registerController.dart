import 'package:get/get.dart';
import 'package:stocklyzer/component/snackBar.dart';
import 'package:stocklyzer/services/supabase/supabase_auth_manager.dart';

class RegisterController extends GetxController {
  var authService = Get.find<AuthService>();

  var isLoading = false.obs;

  var name = ''.obs;
  var email = ''.obs;

  var password = ''.obs;
  var isHidden = true.obs;

  void onUserRegister() async {
    isLoading.value = true;
    if (!_validateName(name.value)) {
      SnackbarHelper.show(
        title: "Name Error",
        message: "Invalid name. Please enter at least 4 characters.",
        type: SnackType.error,
      );
      isLoading.value = false;
      return;
    }

    if (!_validateEmail(email.value)) {
      SnackbarHelper.show(
        title: "Email Error",
        message: "Invalid email format. Please enter a valid email.",
        type: SnackType.error,
      );
      isLoading.value = false;
      return;
    }

    if (!_validatePassword(password.value)) {
      SnackbarHelper.show(
        title: "Password Error",
        message: "Password must be at least 6 characters long.",
        type: SnackType.error,
      );
      isLoading.value = false;
      return;
    }

    try {
      await authService.signUpWithEmail(
        email.value,
        name.value,
        password.value,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void onUserLogin() {}

  void onUserLoginGoogle() {}

  bool _validateEmail(String email) {
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    return email.isNotEmpty && emailRegex.hasMatch(email);
  }

  bool _validatePassword(String password) {
    return password.length >= 6;
  }

  bool _validateName(String name) {
    return name.isNotEmpty && name.length >= 4;
  }
}
