import 'package:flutter/material.dart';
import '../controllers/auth_controller.dart';
import 'login_page.dart';

class PerfilPage extends StatelessWidget {
  const PerfilPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: AuthController.isLoggedIn,
      builder: (context, isLoggedIn, _) {
        if (!isLoggedIn) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.lock_outline, size: 80, color: Colors.grey),
                  const SizedBox(height: 16),
                  const Text(
                    'Você não está logado.',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Entre para acessar seu perfil.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, color: Colors.black54),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const LoginPage()),
                      );
                    },
                    icon: const Icon(Icons.login, color: Colors.white),
                    label: const Text(
                      'Fazer Login',
                      style: TextStyle(color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF388E3C),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 12),
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        // Conteúdo de perfil do usuário logado
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(height: 32),
              const CircleAvatar(
                radius: 48,
                backgroundColor: Color(0xFFA5D6A7),
                child: Icon(Icons.account_circle,
                    size: 80, color: Colors.white),
              ),
              const SizedBox(height: 16),
              Text(
                AuthController.userName ?? 'Usuário',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF388E3C),
                ),
              ),
              const SizedBox(height: 8),
              const SizedBox(height: 32),
              ListTile(
                leading: const Icon(Icons.pets, color: Color(0xFF388E3C)),
                title: const Text('Meus Pets para Adoção'),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {},
              ),
              ListTile(
                leading: const Icon(Icons.favorite, color: Color(0xFF388E3C)),
                title: const Text('Favoritos'),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {},
              ),
              ListTile(
                leading: const Icon(Icons.settings, color: Color(0xFF388E3C)),
                title: const Text('Configurações'),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {},
              ),
              const SizedBox(height: 24),
              TextButton.icon(
                onPressed: () {
                  AuthController.logout();
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (_) => const LoginPage()),
                  );
                },
                icon: const Icon(Icons.logout, color: Colors.red),
                label: const Text('Sair', style: TextStyle(color: Colors.red)),
              ),
            ],
          ),
        );
      },
    );
  }
}
