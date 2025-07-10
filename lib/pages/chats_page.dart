import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatsPage extends StatelessWidget {
  final void Function(String conversaId) abrirChat;

  const ChatsPage({super.key, required this.abrirChat});

  Future<List<String>> _buscarNomesParticipantes(List<String> ids) async {
    final usuariosCollection = FirebaseFirestore.instance.collection('usuarios');

    final futurosDocs = ids.map((id) => usuariosCollection.doc(id).get());
    final snapshots = await Future.wait(futurosDocs);

    final nomes = snapshots.map((doc) {
      if (doc.exists && doc.data() != null && doc.data()!.containsKey('nome')) {
        return doc['nome'] as String;
      }
      return 'Usuário desconhecido';
    }).toList();

    return nomes;
  }

  @override
  Widget build(BuildContext context) {
    final userId = FirebaseAuth.instance.currentUser?.uid;

    if (userId == null) {
      return const Center(child: Text('Você precisa estar logado para ver os chats.'));
    }

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('conversas')
          .where('participantes', arrayContains: userId)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text('Nenhuma conversa encontrada.'));
        }

        final conversas = snapshot.data!.docs;

        return ListView.builder(
          itemCount: conversas.length,
          itemBuilder: (context, index) {
            final doc = conversas[index];
            final List<dynamic> participantes = doc['participantes'];
            final outrosIds = participantes.where((id) => id != userId).cast<String>().toList();

            return FutureBuilder<List<String>>(
              future: _buscarNomesParticipantes(outrosIds),
              builder: (context, nomesSnapshot) {
                if (nomesSnapshot.connectionState == ConnectionState.waiting) {
                  return ListTile(
                    title: const Text('Carregando...'),
                    trailing: const CircularProgressIndicator(),
                  );
                }
                if (nomesSnapshot.hasError) {
                  return const ListTile(
                    title: Text('Erro ao carregar nomes'),
                  );
                }

                final nomes = nomesSnapshot.data ?? ['Usuário desconhecido'];
                final textoTitulo = 'Conversa com ${nomes.join(', ')}';

                return ListTile(
                  title: Text(textoTitulo),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () => abrirChat(doc.id),
                );
              },
            );
          },
        );
      },
    );
  }
}
