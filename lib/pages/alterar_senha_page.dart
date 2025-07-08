import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AlterarSenhaPage extends StatefulWidget {
  const AlterarSenhaPage({super.key});

  @override
  State<AlterarSenhaPage> createState() => _AlterarSenhaPageState();
}

class _AlterarSenhaPageState extends State<AlterarSenhaPage> {
  final TextEditingController novaSenhaController = TextEditingController();
  final TextEditingController confirmarSenhaController = TextEditingController();

  final user = FirebaseAuth.instance.currentUser;

  Future<void> alterarSenha() async {
    final novaSenha = novaSenhaController.text.trim();
    final confirmarSenha = confirmarSenhaController.text.trim();

    if (novaSenha != confirmarSenha) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('As senhas não coincidem.')),
      );
      return;
    }

    try {
      await user?.updatePassword(novaSenha);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Senha alterada com sucesso!')),
      );
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao alterar senha: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Alterar Senha'), backgroundColor: const Color(0xFFFFA726)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: novaSenhaController,
              decoration: const InputDecoration(labelText: 'Nova senha'),
              obscureText: true,
            ),
            TextField(
              controller: confirmarSenhaController,
              decoration: const InputDecoration(labelText: 'Confirmar nova senha'),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: alterarSenha,
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFFFA726)),
              child: const Text('Alterar senha'),
            ),
          ],
        ),
      ),
    );
  }
}
