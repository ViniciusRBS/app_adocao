import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditarPerfilPage extends StatefulWidget {
  const EditarPerfilPage({super.key});

  @override
  State<EditarPerfilPage> createState() => _EditarPerfilPageState();
}

class _EditarPerfilPageState extends State<EditarPerfilPage> {
  final TextEditingController nomeController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController telefoneController = TextEditingController();

  final user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    carregarDadosUsuario();
  }

  Future<void> carregarDadosUsuario() async {
    if (user == null) return;
    final doc = await FirebaseFirestore.instance.collection('usuarios').doc(user!.uid).get();
    final data = doc.data();
    if (data != null) {
      nomeController.text = data['nome'] ?? '';
      emailController.text = user!.email ?? '';
      telefoneController.text = data['telefone'] ?? '';
    }
  }

Future<void> salvarPerfil() async {
  if (user == null) return;

  try {
    // Atualiza o e-mail no Firebase Auth
    await user!.updateEmail(emailController.text.trim());

    // Atualiza os dados no Firestore
    await FirebaseFirestore.instance.collection('usuarios').doc(user!.uid).set({
      'nome': nomeController.text.trim(),
      'telefone': telefoneController.text.trim(),
      'email': emailController.text.trim(),
    }, SetOptions(merge: true));

    if (!mounted) return;

    // Mostra snackbar com círculo e mensagem
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 3),
        content: Row(
          children: const [
            SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                strokeWidth: 2,
              ),
            ),
            SizedBox(width: 16),
            Text('Perfil atualizado com sucesso...'),
          ],
        ),
        backgroundColor: Colors.green,
      ),
    );

    // Espera 3 segundos e volta
    await Future.delayed(const Duration(seconds: 3));

    if (mounted) Navigator.pop(context);

  } catch (e) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Erro ao atualizar perfil: $e')),
    );
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Editar Perfil'), backgroundColor: const Color(0xFFFFA726)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(controller: nomeController, decoration: const InputDecoration(labelText: 'Nome')),
            TextField(controller: emailController, decoration: const InputDecoration(labelText: 'Email')),
            TextField(controller: telefoneController, decoration: const InputDecoration(labelText: 'Telefone')),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: salvarPerfil ,
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFFFA726)),
              child: const Text('Salvar'),
            ),
          ],
        ),
      ),
    );
  }
}
