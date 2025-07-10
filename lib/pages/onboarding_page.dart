import 'package:flutter/material.dart';
import 'login_page.dart';
import 'package:flutter_animate/flutter_animate.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;


  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Widget _buildDot(int index) {
    bool isSelected = _currentPage == index;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: isSelected ? 36 : 24,
      height: isSelected ? 18 : 12,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        color: isSelected ? Colors.black : Colors.grey,
        borderRadius: BorderRadius.circular(20),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() => _currentPage = index);
            },
            children: [
              _buildPage1(),
              _buildPage2(),
              _buildPage3(),
            ],
          ),
          Positioned(
            bottom: 16,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(3, _buildDot),
            ),
          ),
        ],
      ),
    );
  }

Widget _buildPage1() {
  return Container(
    color: const Color(0xFFFFA726),
    child: Center(
      child: Card(
        elevation: 4,
        margin: const EdgeInsets.symmetric(horizontal: 32, vertical: 48),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                'assets/images/adocao.png',
                width: 300,
                height: 200,
                fit: BoxFit.cover,
              ).animate().fadeIn(duration: 600.ms).slideY(begin: 0.4),
              const SizedBox(height: 12),
              const Text(
                'Bem-vindo ao Coração Animal',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ).animate().fadeIn(duration: 600.ms).slideY(begin: 0.5, delay: 100.ms),
              const SizedBox(height: 12),
              const Text(
                'Este aplicativo ajuda você a encontrar animais para adoção e se conectar com abrigos e tutores.',
                textAlign: TextAlign.center,
              ).animate().fadeIn(duration: 600.ms).slideY(begin: 0.6, delay: 200.ms),
            ],
          ),
        ),
      ),
    ),
  );
}

Widget _buildPage2() {
  return Container(
    color: const Color(0xFFFFA726),
    child: Center(
      child: Card(
        elevation: 4,
        margin: const EdgeInsets.symmetric(horizontal: 32, vertical: 48),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.explore, size: 48, color: Colors.orange)
                  .animate()
                  .fadeIn()
                  .slideY(begin: 0.4),
              const SizedBox(height: 12),
              const Text(
                'Como Funciona',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ).animate().fadeIn().slideY(begin: 0.5, delay: 100.ms),
              const SizedBox(height: 12),
              const Text(
                'Escolha um pet, leia sua história e veja se vocês combinam.',
                textAlign: TextAlign.center,
              ).animate().fadeIn().slideY(begin: 0.6, delay: 200.ms),
            ],
          ),
        ),
      ),
    ),
  );
}

Widget _buildPage3() {
  return Container(
    color: const Color(0xFFFFA726),
    child: Center(
      child: Card(
        elevation: 4,
        margin: const EdgeInsets.symmetric(horizontal: 32, vertical: 48),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.favorite, size: 48, color: Color(0xFFFFA726))
                  .animate()
                  .fadeIn()
                  .slideY(begin: 0.4),
              const SizedBox(height: 12),
              const Text(
                'Comece Agora!',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ).animate().fadeIn().slideY(begin: 0.5, delay: 100.ms),
              const SizedBox(height: 12),
              const Text(
                'Adote com segurança e amor.\nToque no botão abaixo para começar.',
                textAlign: TextAlign.center,
              ).animate().fadeIn().slideY(begin: 0.6, delay: 200.ms),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushReplacement(
                    PageRouteBuilder(
                      pageBuilder: (_, __, ___) => const LoginPage(),
                      transitionDuration: const Duration(milliseconds: 500),
                      transitionsBuilder: (_, animation, __, child) {
                        return FadeTransition(
                          opacity: animation,
                          child: child,
                        );
                      },
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFFA726),
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                ),
                child: const Text(
                  'Adote agora!',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              )
              .animate().fadeIn().slideY(begin: 0.7, delay: 300.ms),
            ],
          ),
        ),
      ),
    ),
  );
}

}
