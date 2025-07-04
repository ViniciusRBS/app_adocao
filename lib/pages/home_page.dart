import 'package:flutter/material.dart';
import 'favorites_page.dart';
import 'perfil_page.dart';
import 'adocao_page.dart'; // nova importação

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  final List<Widget> _pages = const [
    AdocaoPage(),
    MockFavoritesPage(),
    PerfilPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Icon(Icons.pets, color: Colors.white, size: 35),
        title: const Text('Coração Animal'),
        backgroundColor: Colors.green[400],
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.green[800],
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Início',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_border),
            label: 'Favoritos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'Perfil',
          ),
        ],
      ),
    );
  }
}

class _MockHomeContent extends StatelessWidget {
  const _MockHomeContent({super.key});

  @override
  Widget build(BuildContext context) {
    final animais = [
      {'nome': 'Luna', 'descricao': 'Cachorra brincalhona'},
      {'nome': 'Milo', 'descricao': 'Gato tranquilo'},
      {'nome': 'Bella', 'descricao': 'Cachorra dócil'},
    ];

    return ListView.builder(
      itemCount: animais.length,
      padding: const EdgeInsets.all(16),
      itemBuilder: (context, index) {
        final animal = animais[index];
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8),
          child: ListTile(
            leading: const Icon(Icons.pets),
            title: Text(animal['nome']!),
            subtitle: Text(animal['descricao']!),
          ),
        );
      },
    );
  }
}
