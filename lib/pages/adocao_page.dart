import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'detalhes_pet_page.dart';
import 'package:app_teste1/widgets/botao_favorito.dart';

class AdocaoPage extends StatelessWidget {
  const AdocaoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('pets').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text('Nenhum animal disponível para adoção.'));
        }

        final animais = snapshot.data!.docs;

        return ListView.builder(
          itemCount: animais.length,
          padding: const EdgeInsets.all(16),
          itemBuilder: (context, index) {
            final animal = animais[index];
            final nome = animal['nome'] ?? 'Sem nome';
            final descricao = animal['descricao'] ?? 'Sem descrição';
            final foto = animal['foto'] ?? '';
            final tipo = animal['tipo'] ?? 'Desconhecido';


            return Card(
              margin: const EdgeInsets.symmetric(vertical: 10),
              elevation: 3,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                    child: Image.network(
                    foto.isNotEmpty ? foto : 'https://via.placeholder.com/300x180?text=Sem+Imagem',
                    width: double.infinity,
                    height: 180,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => const Icon(Icons.broken_image),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Chip(
                              label: Text(tipo),
                              backgroundColor: Colors.green.shade100,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              nome,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          descricao,
                          style: const TextStyle(fontSize: 16, color: Colors.black54),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ElevatedButton.icon(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => DetalhesPetPage(petId: animal.id),
                                  ),
                                );
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Mais detalhes de $nome')),
                                );
                              },
                              icon: const Icon(Icons.info_outline),
                              label: const Text('Ver detalhes'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xFFFFA726),
                                foregroundColor: Colors.white,
                              ),
                            ),
                            BotaoFavorito(petId: animal.id),
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _toggleFavorito(String animalId) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final docRef = FirebaseFirestore.instance.collection('pets').doc(animalId);
    final doc = await docRef.get();

    List favoritos = doc['favoritadoPor'] ?? [];

    if (favoritos.contains(user.uid)) {
      favoritos.remove(user.uid);
    } else {
      favoritos.add(user.uid);
    }

    await docRef.update({'favoritadoPor': favoritos});
  }
}
