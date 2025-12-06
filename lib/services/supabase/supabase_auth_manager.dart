import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:stocklyzer/component/snackBar.dart';
import 'package:stocklyzer/controller/homeController.dart';
import 'package:stocklyzer/controller/navBarController.dart';
import 'package:stocklyzer/controller/profileController.dart';
import 'package:stocklyzer/model/MsUser.dart';
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

  var currentlyLoggedUser = Rx<MsUser?>(null);

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

  Future<AuthResponse> signInWithEmail(String email, String password) async {
    try {
      final res = await _client.auth.signInWithPassword(
        email: email,
        password: password,
      );

      return res; // success
    } on AuthException catch (e) {
      // This is where 400 "Invalid login credentials" lands
      if (e.statusCode == 400 ||
          e.message.contains("Invalid login credentials")) {
        SnackbarHelper.show(
          title: "Error",
          message: "Invalid email or password.",
          type: SnackType.error,
        );
      } else {
        SnackbarHelper.show(
          title: "Error",
          message: e.message,
          type: SnackType.error,
        );
      }
      rethrow;
    } catch (e) {
      // Other unexpected errors (network, server, unknown)
      SnackbarHelper.show(
        title: "Error",
        message: e.toString(),
        type: SnackType.error,
      );
      rethrow;
    }
  }

  Future<void> signOut() async {
    // Reset your app state
    isLoggedIn.value = false;
    currentlyLoggedUser.value = null;

    // Sign out from Supabase
    await _client.auth.signOut();

    // Always try to clear GoogleSignIn cache
    final signIn = GoogleSignIn.instance;

    try {
      await signIn.signOut(); // logs out current account
    } catch (_) {}

    try {
      await signIn
          .disconnect(); // removes cached account, forces account selection next time
    } catch (_) {}
  }

  Future<AuthResponse> signInWithGoogle() async {
    const webClientId =
        '108094242500-fh641onb4l045sv44cq9hcm63rrf041b.apps.googleusercontent.com';
    const iosClientId =
        '108094242500-5bbfj7si3f0l7mkmkkpjms26fuv7d0vq.apps.googleusercontent.com';

    // Google sign in on Android will work without providing the Android
    // Client ID registered on Google Cloud.

    final signIn = GoogleSignIn.instance;

    // **Initialize** GoogleSignIn once
    if (Platform.isAndroid) {
      await signIn.initialize(serverClientId: webClientId);
    } else if (Platform.isIOS) {
      await signIn.initialize(
        clientId: iosClientId,
        serverClientId: webClientId,
      );
    }

    // Try lightweight auth first (silent)
    await signIn.attemptLightweightAuthentication();

    // If not signed in, do the interactive flow
    final account = await signIn.authenticate();

    final idToken = account.authentication.idToken;

    if (idToken == null) {
      throw 'No tokens found from Google Sign-In';
    }

    // Pass nonce when signing in with Supabase
    return _client.auth.signInWithIdToken(
      provider: OAuthProvider.google,
      idToken: idToken,
    );
  }

  void checkSession() async {
    final session = _client.auth.currentSession;
    if (session != null) {
      isLoggedIn.value = true;
      final user = session.user;

      final newlyLoggedUser = await userRepository.getUserByEmail(user.email!);

      if (newlyLoggedUser != null) {
        currentlyLoggedUser.value = newlyLoggedUser;
      }
    }
  }

  void _listenAuth() {
    final client = _client;

    client.auth.onAuthStateChange.listen((data) async {
      final event = data.event;
      final session = data.session;

      if (event == AuthChangeEvent.signedIn && session != null) {
        print("User signed in: ${session.user.email}");

        // Fetch user safely
        final newlyLoggedUser = await userRepository.getUserByEmail(
          session.user.email!,
        );

        if (newlyLoggedUser == null) return;

        currentlyLoggedUser.value = newlyLoggedUser;
        isLoggedIn.value = true;

        // Use a small delay to ensure UI is ready for navigation
        await Future.delayed(Duration(milliseconds: 100));

        if (newlyLoggedUser.isNewUser) {
          Get.offAll(() => Userpersonalization());
        } else {
          Get.offAll(() => Navbar());
        }
      }

      if (event == AuthChangeEvent.signedOut) {
        print("User signed out");
        isLoggedIn.value = false;

        if (Get.isRegistered<ProfileController>()) {
          Get.delete<ProfileController>();
        }

        if (Get.isRegistered<Homecontroller>()) {
          Get.delete<Homecontroller>();
        }

        if (Get.isRegistered<SearchController>()) {
          Get.delete<SearchController>();
        }

        if (Get.isRegistered<Navbarcontroller>()) {
          Get.delete<Navbarcontroller>();
        }

        Get.offAll(() => Onboarding());
      }
    });
  }
}
