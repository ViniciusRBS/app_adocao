import 'package:flutter/material.dart';
import 'adocao_page.dart';
import 'favoritos_page.dart';
import 'perfil_page.dart';
import 'chats_page.dart';
import 'chat_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  String? _chatSelecionadoId;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      _chatSelecionadoId = null; // Reseta ao sair do chat
    });
  }

  void _abrirChat(String conversaId) {
    setState(() {
      _chatSelecionadoId = conversaId;
      _selectedIndex = 3;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget body;

    if (_selectedIndex == 3) {
      body = _chatSelecionadoId == null
          ? ChatsPage(abrirChat: _abrirChat)
          : ChatPage(conversaId: _chatSelecionadoId!);
    } else {
      final List<Widget> pages = const [
        AdocaoPage(),
        FavoritosPage(),
        PerfilPage(),
      ];
      body = pages[_selectedIndex];
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Coração Animal', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFFFFA726),
      ),
      body: body,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: const Color(0xFFFFA726),
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Início'),
          BottomNavigationBarItem(icon: Icon(Icons.favorite_border), label: 'Favoritos'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Perfil'),
          BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'Chats'),
        ],
      ),
    );
  }
}
