import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'pages/onboarding_page.dart';
import 'pages/home_page.dart';
import 'controllers/auth_controller.dart';

class MyApp1 extends StatelessWidget {
  const MyApp1({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Coração Animal',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      home: AuthController.isLoggedIn.value
    ? const HomePage(paginaInicial: 2)
    : const OnboardingPage(),
    );
  }
}