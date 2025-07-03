import 'package:flutter/material.dart';

class AuthController {
  static final ValueNotifier<bool> isLoggedIn = ValueNotifier(false);

  static void login() {
    isLoggedIn.value = true;
  }

  static void logout() {
    isLoggedIn.value = false;
  }
}
