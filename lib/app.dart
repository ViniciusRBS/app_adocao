import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'pages/onboarding_page.dart';
import 'pages/home_page.dart';
class MyApp1 extends StatelessWidget {
  const MyApp1({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Coração Animal',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.yellow,
      ),
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          // Enquanto carrega o estado de autenticação, mostra um loading
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }

          // Se tem usuário logado, vai direto para HomePage
          if (snapshot.hasData) {
            return const HomePage();
          }

          // Se não estiver logado, mostra a OnboardingPage
          return const OnboardingPage();
        },
      ),
    );
  }
}
