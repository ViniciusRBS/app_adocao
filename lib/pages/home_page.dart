import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'adocao_page.dart';
import 'favoritos_page.dart';
import 'perfil_page.dart';
import 'chats_page.dart';
import 'chat_page.dart';

class HomePage extends StatefulWidget {
  final int paginaInicial;

  const HomePage({super.key, this.paginaInicial = 0});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late int _selectedIndex;
  String? _chatSelecionadoId;
  String? _userId;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.paginaInicial;

    final user = FirebaseAuth.instance.currentUser;
    _userId = user?.uid;
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      _chatSelecionadoId = null; // Sai do chat individual
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
      if (_chatSelecionadoId == null) {
        body = ChatsPage(abrirChat: _abrirChat);
      } else {
        if (_userId != null) {
          body = ChatPage(conversaId: _chatSelecionadoId!, userId: _userId!);
        } else {
          body = const Center(child: Text('Usuário não autenticado.'));
        }
      }
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
