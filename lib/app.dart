import 'package:flutter/material.dart';
import 'pages/onboarding_page.dart';

class MyApp1 extends StatelessWidget {
  const MyApp1({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Coração Animal',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.yellow, // Define a cor primária como laranja (0xFFFFA726),
      ),
      home: const OnboardingPage(),
    );
  }
}
