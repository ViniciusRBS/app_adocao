import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:app_teste1/widgets/botao_favorito.dart';

class DetalhesPetPage extends StatelessWidget {
  final String petId;

  const DetalhesPetPage({super.key, required this.petId});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(
      future: FirebaseFirestore.instance.collection('pets').doc(petId).get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }

        if (!snapshot.hasData || !snapshot.data!.exists) {
          return const Scaffold(body: Center(child: Text('Pet não encontrado.')));
        }

        final pet = snapshot.data!.data() as Map<String, dynamic>;

        final nome = pet['nome'] ?? 'Sem nome';
        final descricao = pet['descricao'] ?? 'Sem descrição';
        final tipo = pet['tipo'] ?? 'Desconhecido';
        final foto = pet['foto'] ?? '';
        final userId = pet['userId'];
        final criadoEm = (pet['criadoEm'] as Timestamp?)?.toDate();

        return Scaffold(
          appBar: AppBar(
            title: Text(nome, style: const TextStyle(color: Colors.white)),
            backgroundColor: Color(0xFFFFA726),
            actions: [
              BotaoFavorito(petId: petId),
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (foto.isNotEmpty)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      foto,
                      height: 200,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                const SizedBox(height: 16),
                Chip(
                  label: Text(tipo),
                  backgroundColor: Colors.green.shade100,
                ),
                const SizedBox(height: 12),
                Text(
                  descricao,
                  style: const TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 24),
                if (criadoEm != null)
                  Text(
                    'Anunciado há: ${_tempoDesde(criadoEm)}',
                    style: const TextStyle(color: Colors.grey),
                  ),
                const SizedBox(height: 12),
                FutureBuilder<DocumentSnapshot>(
                  future: FirebaseFirestore.instance.collection('usuarios').doc(userId).get(),
                  builder: (context, snapshotUser) {
                    if (snapshotUser.connectionState == ConnectionState.waiting) {
                      return const Text('Carregando dono...');
                    }
                    final nomeDono = snapshotUser.data?.get('nome') ?? 'Desconhecido';
                    return Text('Dono: $nomeDono');
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  String _tempoDesde(DateTime data) {
    final agora = DateTime.now();
    final duracao = agora.difference(data);

    if (duracao.inDays > 0) return '${duracao.inDays} dia(s)';
    if (duracao.inHours > 0) return '${duracao.inHours} hora(s)';
    if (duracao.inMinutes > 0) return '${duracao.inMinutes} minuto(s)';
    return 'Há poucos segundos';
  }
}
