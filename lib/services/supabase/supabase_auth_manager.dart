import 'package:get/get.dart';
import 'package:stocklyzer/component/snackBar.dart';
import 'package:stocklyzer/repository/user_repository.dart';
import 'package:stocklyzer/services/supabase/supabase_manager.dart';
import 'package:stocklyzer/view/navBar.dart';
import 'package:stocklyzer/view/onboarding.dart';
import 'package:stocklyzer/view/userPersonalization.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService extends GetxController {
  final _client = SupabaseManager().client;
  final userRepository = Get.find<UserRepository>();
  var isLoggedIn = false.obs;

  @override
  void onInit() {
    super.onInit();
    _listenAuth();
  }

  Future<AuthResponse> signUpWithEmail(
    String email,
    String name,
    String password,
  ) async {
    try {
      final response = await _client.auth.signUp(
        email: email,
        password: password,
        data: {'name': name},
      );

      return response;
    } on AuthException catch (e) {
      // Supabase known error (ex: 422 = already registered)
      if (e.statusCode == 422 ||
          e.message.contains("already registered") ||
          e.message.contains("exists")) {
        SnackbarHelper.show(
          title: "Error",
          message: "Email is already registered.",
          type: SnackType.error,
        );
      } else {
        SnackbarHelper.show(
          title: "Error",
          message: e.message,
          type: SnackType.error,
        );
      }
      rethrow; // rethrow so caller can still handle if needed
    } catch (e) {
      // Any other unknown exceptions
      SnackbarHelper.show(
        title: "Error",
        message: e.toString(),
        type: SnackType.error,
      );
      rethrow;
    }
  }

  Future<AuthResponse> signInWithEmail(String email, String password) {
    return _client.auth.signInWithPassword(email: email, password: password);
  }

  Future<void> signOut() {
    return _client.auth.signOut();
  }

  Future<void> signInWithGoogle() async {
    await _client.auth.signInWithOAuth(
      OAuthProvider.google,
      redirectTo: 'com.example.stocklyzer://login-callback',
    );
  }

  void _listenAuth() {
    final client = _client; // access your Supabase client

    client.auth.onAuthStateChange.listen((data) {
      final event = data.event;
      final session = data.session;

      if (event == AuthChangeEvent.signedIn && session != null) {
        final user = session.user;

        final provider = user.appMetadata['provider'];

        userRepository.getUserByEmail(user.email!).then((value) {
          if (value == null) {
            return;
          }

          if (value.isNewUser) {
            Get.offAll(() => Userpersonalization());
            return;
          }

          if (provider == 'email') {
          } else {
            Get.offAll(() => Navbar());
          }
        });
      }

      if (event == AuthChangeEvent.signedOut) {
        print("User signed out");
        isLoggedIn.value = false;
        Get.offAll(() => Onboarding()); // navigate back to login
      }
    });
  }
}
