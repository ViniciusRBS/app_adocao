import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'detalhes_pet_page.dart';

class FavoritosPage extends StatelessWidget {
  const FavoritosPage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return const Center(child: Text('Você precisa estar logado.'));
    }

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('pets')
          .where('favoritadoPor', arrayContains: user.uid)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text('Nenhum pet favoritado ainda.'));
        }

        final favoritos = snapshot.data!.docs;

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: favoritos.length,
          itemBuilder: (context, index) {
            final animal = favoritos[index];
            final nome = animal['nome'] ?? 'Sem nome';
            final descricao = animal['descricao'] ?? '';
            final tipo = animal['tipo'] ?? 'Desconhecido';

            // Pega a lista de fotos do pet
            final List<dynamic> fotos = animal['fotos'] ?? [];

            // URL da primeira foto ou string vazia
            final String? primeiraFoto = fotos.isNotEmpty ? fotos[0] as String : null;

            return Card(
              margin: const EdgeInsets.symmetric(vertical: 10),
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: ListTile(
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: primeiraFoto != null && primeiraFoto.isNotEmpty
                      ? Image.network(
                          primeiraFoto,
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              const Icon(Icons.broken_image, size: 50),
                        )
                      : const Icon(Icons.image_not_supported, size: 50),
                ),
                title: Text(nome),
                subtitle: Text('$descricao • $tipo'),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => DetalhesPetPage(petId: animal.id),
                    ),
                  );
                },
              ),
            );
          },
        );
      },
    );
  }
}
