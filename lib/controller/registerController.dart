import 'package:get/get.dart';
import 'package:stocklyzer/component/snackBar.dart';
import 'package:stocklyzer/controller/validator.dart';
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
    final nameValidation = Validator.validateName(name.value);
    if (nameValidation != ValidatorResult.valid) {
      SnackbarHelper.show(
        title: nameValidation.title,
        message: nameValidation.message,
        type: SnackType.error,
      );
      isLoading.value = false;
      return;
    }

    final emailValidation = Validator.validateEmail(email.value);
    if (emailValidation != ValidatorResult.valid) {
      SnackbarHelper.show(
        title: emailValidation.title,
        message: emailValidation.message,
        type: SnackType.error,
      );
      isLoading.value = false;
      return;
    }

    final passwordValidation = Validator.validatePassword(password.value);
    if (passwordValidation != ValidatorResult.valid) {
      SnackbarHelper.show(
        title: passwordValidation.title,
        message: passwordValidation.message,
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
}
