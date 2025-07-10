import 'package:app_teste1/pages/onboarding_page.dart';
import 'package:flutter/material.dart';
import '../controllers/auth_controller.dart';
import 'login_page.dart';
import 'meus_pets_page.dart';
import 'configuracoes_page.dart';
import 'ajuda_page.dart';

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
                      backgroundColor: const Color(0xFFFFA726),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 12),
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        return ListView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          children: [
            const Center(
              child: CircleAvatar(
                radius: 48,
                backgroundColor: Color(0xFFFFA726),
                child: Icon(Icons.account_circle,
                    size: 80, color: Colors.white),
              ),
            ),
            const SizedBox(height: 16),
            Center(
              child: Text(
                AuthController.userName ?? 'Usuário',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFFFA726),
                ),
              ),
            ),
            const SizedBox(height: 32),

            const Text(
              'Conta',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Colors.black54,
              ),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.pets, color: Color(0xFFFFA726)),
              title: const Text('Meus Pets para Adoção'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const MeusPetsPage()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.favorite, color: Color(0xFFFFA726)),
              title: const Text('Favoritos'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                // Implementar favoritos
            },
            ),

            const SizedBox(height: 24),
            const Text(
              'Atividades',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Colors.black54,
              ),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.history, color: Color(0xFFFFA726)),
              title: const Text('Histórico de Adoções'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                // Implementar histórico
              },
            ),
            ListTile(
              leading: const Icon(Icons.share, color: Color(0xFFFFA726)),
              title: const Text('Compartilhar o app'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                // Implementar compartilhamento
              },
            ),

            const SizedBox(height: 24),
            const Text(
              'Preferências',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Colors.black54,
              ),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.settings, color: Color(0xFFFFA726)),
              title: const Text('Configurações'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ConfiguracoesPage()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.help_outline, color: Color(0xFFFFA726)),
              title: const Text('Ajuda e Suporte'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const AjudaPage()),
                );
              },
            ),

            const SizedBox(height: 24),
            Center(
              child: TextButton.icon(
                onPressed: () {
                  AuthController.logout();
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (_) => const OnboardingPage()),
                  );
                },
                icon: const Icon(Icons.logout, color: Colors.red),
                label: const Text('Sair', style: TextStyle(color: Colors.red)),
              ),
            ),
          ],
        );
      },
    );
  }
}
