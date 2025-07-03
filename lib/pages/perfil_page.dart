import 'package:flutter/material.dart';

class PerfilPage extends StatelessWidget {
  const PerfilPage({super.key});

  @override
  Widget build(BuildContext context) {
    // MOCK: Aqui você pode integrar com seu sistema de autenticação real no futuro
    final bool isLoggedIn = false; // Troque para false para testar tela de login
    final String nomeUsuario = 'João Silva';
    final String emailUsuario = 'joao@email.com';

    if (!isLoggedIn) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.lock_outline, size: 80, color: Colors.grey),
              SizedBox(height: 16),
              Text(
                'Você não está logado.',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                'Faça login para acessar seu perfil, favoritos e pets para adoção.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.black54),
              ),
              SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: () {
                  // Ação de login (ex: Navigator.push para página de login)
                },
                icon: Icon(Icons.login),
                label: Text('Entrar'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF388E3C),
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
              ),
            ],
          ),
        ),
      );
    }

    // Caso esteja logado, mostra o conteúdo atual
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: 32),
            CircleAvatar(
              radius: 48,
              backgroundColor: Color(0xFFA5D6A7),
              child: Icon(Icons.account_circle, size: 80, color: Colors.white),
            ),
            SizedBox(height: 16),
            Text(
              nomeUsuario,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF388E3C),
              ),
            ),
            SizedBox(height: 8),
            Text(
              emailUsuario,
              style: TextStyle(
                fontSize: 16,
                color: Colors.black54,
              ),
            ),
            SizedBox(height: 32),
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 2,
              child: ListTile(
                leading: Icon(Icons.pets, color: Color(0xFF388E3C)),
                title: Text('Meus Pets para Adoção'),
                trailing: Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {},
              ),
            ),
            SizedBox(height: 12),
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 2,
              child: ListTile(
                leading: Icon(Icons.favorite, color: Color(0xFF388E3C)),
                title: Text('Favoritos'),
                trailing: Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {},
              ),
            ),
            SizedBox(height: 12),
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 2,
              child: ListTile(
                leading: Icon(Icons.settings, color: Color(0xFF388E3C)),
                title: Text('Configurações'),
                trailing: Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {},
              ),
            ),
            SizedBox(height: 24),
            TextButton.icon(
              onPressed: () {
                // Aqui você pode simular logout
              },
              icon: Icon(Icons.logout, color: Colors.red),
              label: Text(
                'Sair',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
