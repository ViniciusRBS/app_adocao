import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:app_teste1/widgets/botao_favorito.dart';
import 'editar_pet_page.dart';

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

        final currentUser = FirebaseAuth.instance.currentUser;
        final isDono = currentUser != null && currentUser.uid == userId;

        return Scaffold(
          appBar: AppBar(
            title: Text(nome, style: const TextStyle(color: Colors.white)),
            backgroundColor: const Color(0xFFFFA726),
            actions: [
              IconButton(
                icon: const Icon(Icons.contact_mail, color: Colors.white),
                tooltip: 'Ver Contato',
                onPressed: () => _mostrarContato(context, userId),
              ),
              if (isDono) ...[
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.white),
                  tooltip: 'Editar Pet',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => EditarPetPage(petId: petId),
                      ),
                    );
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.white),
                  tooltip: 'Excluir Pet',
                  onPressed: () => _confirmarExclusao(context, petId, nome),
                ),
              ],
              BotaoFavorito(petId: petId, detalhesPage: true),
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
                  label: Text(tipo, style: const TextStyle(color: Colors.white)),
                  backgroundColor: const Color(0xFFFFA726),
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

  void _mostrarContato(BuildContext context, String userId) async {
    try {
      final doc = await FirebaseFirestore.instance.collection('usuarios').doc(userId).get();

      if (!doc.exists) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Informações de contato não encontradas.')),
        );
        return;
      }

      final nome = doc['nome'] ?? 'Nome não disponível';
      final email = doc['email'] ?? 'Email não disponível';
      final telefone = doc['telefone'] ?? 'Telefone não disponível';

      if (!context.mounted) return;

      showDialog(
        context: context,
        builder: (dialogContext) => AlertDialog(
          title: Text('Contato de $nome'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  const Icon(Icons.email, color: Colors.grey),
                  const SizedBox(width: 8),
                  Expanded(child: Text(email)),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  const Icon(Icons.phone, color: Colors.grey),
                  const SizedBox(width: 8),
                  Expanded(child: Text(telefone)),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Fechar'),
            ),
          ],
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao buscar contato: $e')),
      );
    }
  }

  void _confirmarExclusao(BuildContext context, String petId, String nome) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Confirmar exclusão'),
        content: Text('Tem certeza que deseja excluir o pet "$nome"? Essa ação não pode ser desfeita.'),
        actions: [
          TextButton(
            child: const Text('Cancelar'),
            onPressed: () => Navigator.of(ctx).pop(),
          ),
          TextButton(
            child: const Text('Excluir', style: TextStyle(color: Colors.red)),
            onPressed: () async {
              Navigator.of(ctx).pop();
              await FirebaseFirestore.instance.collection('pets').doc(petId).delete();
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Pet "$nome" excluído com sucesso.')),
                );
                Navigator.of(context).pop(); // volta para a tela anterior depois da exclusão
              }
            },
          ),
        ],
      ),
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
