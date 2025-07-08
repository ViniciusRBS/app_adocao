import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class CadastroPetPage extends StatefulWidget {
  const CadastroPetPage({super.key});

  @override
  State<CadastroPetPage> createState() => _CadastroPetPageState();
}

class _CadastroPetPageState extends State<CadastroPetPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _descricaoController = TextEditingController();

  String? _tipoSelecionado;
  File? _imagemSelecionada;

  bool _isLoading = false;

  final List<String> _tiposAnimais = [
    'Cachorro',
    'Gato',
    'Passarinho',
    'Coelho',
    'Outro',
  ];

  Future<void> _selecionarImagem() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imagemSelecionada = File(pickedFile.path);
      });
    }
  }

  Future<void> _salvarPet() async {
    if (!_formKey.currentState!.validate()) return;

    if (_tipoSelecionado == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, selecione o tipo de animal.')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) throw Exception('Usuário não logado.');

      await FirebaseFirestore.instance.collection('pets').add({
        'nome': _nomeController.text.trim(),
        'descricao': _descricaoController.text.trim(),
        'tipo': _tipoSelecionado,
        'foto': null,
        'userId': user.uid,
        'criadoEm': FieldValue.serverTimestamp(),
        'favoritadoPor': [],
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pet cadastrado com sucesso!')),
      );

      Navigator.of(context).pop();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao salvar pet: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _descricaoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadastrar Novo Pet',style: TextStyle(color: Colors.white)),
        backgroundColor: Color(0xFFFFA726), // Cor personalizada
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Campo Nome
              TextFormField(
                controller: _nomeController,
                decoration: const InputDecoration(
                  labelText: 'Nome',
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value == null || value.trim().isEmpty ? 'Informe o nome' : null,
              ),
              const SizedBox(height: 16),

              // Campo Descrição
              TextFormField(
                controller: _descricaoController,
                decoration: const InputDecoration(
                  labelText: 'Descrição',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
                validator: (value) =>
                    value == null || value.trim().isEmpty ? 'Informe a descrição' : null,
              ),
              const SizedBox(height: 16),

              // Dropdown Tipo
              DropdownButtonFormField<String>(
                value: _tipoSelecionado,
                decoration: const InputDecoration(
                  labelText: 'Tipo de animal',
                  border: OutlineInputBorder(),
                ),
                items: _tiposAnimais
                    .map((tipo) => DropdownMenuItem(value: tipo, child: Text(tipo)))
                    .toList(),
                onChanged: (val) {
                  setState(() {
                    _tipoSelecionado = val;
                  });
                },
                validator: (value) =>
                    value == null || value.isEmpty ? 'Selecione o tipo do animal' : null,
              ),
              const SizedBox(height: 24),

              // Seletor de Imagem
              GestureDetector(
                onTap: _selecionarImagem,
                child: Container(
                  height: 180,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.grey[200],
                  ),
                  child: _imagemSelecionada == null
                      ? const Center(child: Text('Toque para selecionar a foto do pet'))
                      : Image.file(_imagemSelecionada!, fit: BoxFit.cover),
                ),
              ),
              const SizedBox(height: 24),

              // Botão Salvar
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _salvarPet,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFFFA726), // Cor personalizada
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          'Salvar Pet',
                          style: TextStyle(fontSize: 18,color: Colors.white),
                        ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
