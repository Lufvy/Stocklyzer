import 'package:get/get.dart';
import 'package:stocklyzer/component/snackBar.dart';
import 'package:stocklyzer/controller/validator.dart';
import 'package:stocklyzer/services/supabase/supabase_auth_manager.dart';

class LoginController extends GetxController {
  var authService = Get.find<AuthService>();

  var isLoading = false.obs;
  var isHidden = true.obs;

  var email = ''.obs;
  var password = ''.obs;

  void onLoginEmail() async {
    setLoading(true);

    final emailValidation = Validator.validateEmail(email.value);
    if (emailValidation != ValidatorResult.valid) {
      SnackbarHelper.show(
        title: emailValidation.title,
        message: emailValidation.message,
        type: SnackType.error,
      );
      setLoading(false);
      return;
    }

    final passwordValue = password.value.trim();
    final passwordValidation = Validator.validatePassword(passwordValue);
    if (passwordValidation != ValidatorResult.valid) {
      SnackbarHelper.show(
        title: passwordValidation.title,
        message: passwordValidation.message,
        type: SnackType.error,
      );
      setLoading(false);
      return;
    }

    try {
      await authService.signInWithEmail(email.value, passwordValue);
    } finally {
      setLoading(false);
    }
  }

  void onLoginGoogle() async {
    setLoading(true);
    try {
      await authService.signInWithGoogle();
    } finally {
      setLoading(false);
    }
  }

  void setLoading(bool value) {
    isLoading.value = value;
  }
}
