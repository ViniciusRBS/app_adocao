import 'package:flutter/material.dart';

class AuthController {
  static final ValueNotifier<bool> isLoggedIn = ValueNotifier(false);
  static final ValueNotifier<String?> username = ValueNotifier(null);

  static void login({required String username}) {
    AuthController.username.value = username;
    isLoggedIn.value = true;
  }

  static void logout() {
    username.value = null;
    isLoggedIn.value = false;
  }
}


