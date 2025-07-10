import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class BotaoFavorito extends StatefulWidget {
  final String petId;
  final bool detalhesPage;

  const BotaoFavorito({super.key, required this.petId, this.detalhesPage=false});

  @override
  State<BotaoFavorito> createState() => _BotaoFavoritoState();
}

class _BotaoFavoritoState extends State<BotaoFavorito> {
  bool _favoritado = false;
  final user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    _verificarFavorito();
  }

Future<void> _verificarFavorito() async {
  if (user == null) return;

  final doc = await FirebaseFirestore.instance.collection('pets').doc(widget.petId).get();
  final data = doc.data();

  if (data == null) return; // documento não encontrado

  final List favoritos = data.containsKey('favoritadoPor') ? data['favoritadoPor'] : [];

  setState(() {
    _favoritado = favoritos.contains(user!.uid);
  });
}


  Future<void> _alternarFavorito() async {
    if (user == null) return;
    final docRef = FirebaseFirestore.instance.collection('pets').doc(widget.petId);
    final doc = await docRef.get();

    List favoritos = doc['favoritadoPor'] ?? [];

    if (_favoritado) {
      favoritos.remove(user!.uid);
    } else {
      favoritos.add(user!.uid);
    }

    await docRef.update({'favoritadoPor': favoritos});
    setState(() {
      _favoritado = !_favoritado;
    });
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        _favoritado ? Icons.favorite : Icons.favorite_border,
        color: _favoritado ? Colors.red : (widget.detalhesPage ?Colors.white:Colors.black),
      ),
      onPressed: _alternarFavorito,
    );
  }
}
