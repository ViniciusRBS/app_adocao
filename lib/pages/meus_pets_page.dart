import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'detalhes_pet_page.dart';

class MeusPetsPage extends StatelessWidget {
  const MeusPetsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final String? uid = FirebaseAuth.instance.currentUser?.uid;

    if (uid == null) {
      return const Center(child: Text('Usuário não está logado.'));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Meus Pets', style: TextStyle(color: Colors.white)),
        backgroundColor: Color(0xFFFFA726), // Cor laranja
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('pets')
            .where('userId', isEqualTo: uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text('Você ainda não cadastrou nenhum pet.'),
            );
          }

          final pets = snapshot.data!.docs;

          return ListView.builder(
            itemCount: pets.length,
            itemBuilder: (context, index) {
              final pet = pets[index].data() as Map<String, dynamic>;
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  leading: const Icon(Icons.pets, color:Color(0xFFFFA726)),
                  title: Text(pet['nome'] ?? 'Sem nome'),
                  subtitle: Text('${pet['descricao'] ?? ''} • ${pet['tipo'] ?? ''}'),
                  trailing: const Icon(Icons.arrow_forward_ios, color: Colors.grey),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => DetalhesPetPage(petId: pets[index].id),
                      ),
                    );
                  },
                ),
              );

            },
          );
        },
      ),
    );
  }
}
