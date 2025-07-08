import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class EditarPetPage extends StatefulWidget {
  final String petId;

  const EditarPetPage({super.key, required this.petId});

  @override
  State<EditarPetPage> createState() => _EditarPetPageState();
}

class _EditarPetPageState extends State<EditarPetPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _descricaoController = TextEditingController();

  String? _tipoSelecionado;
  String? _tamanhoSelecionado;
  String? _sexoSelecionado;
  File? _imagemSelecionada;
  String? _fotoUrl; // Foto atual do pet

  bool _isLoading = false;
  bool _carregandoDados = true;

  final List<String> _tamanhos = ['Pequeno', 'Médio', 'Grande'];
  final List<String> _sexos = ['Macho', 'Fêmea'];
  List<String> _tiposAnimais = [];

  @override
  void initState() {
    super.initState();
    _carregarTiposDoFirebase();
    _carregarDadosPet();
  }

  Future<void> _carregarTiposDoFirebase() async {
    try {
      final snapshot = await FirebaseFirestore.instance.collection('tipos').get();
      final tipos = snapshot.docs.map((doc) => doc['nome'].toString()).toList();
      setState(() {
        _tiposAnimais = tipos;
      });
    } catch (e) {
      print('Erro ao carregar tipos: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao carregar tipos de animais: $e')),
      );
    }
  }

  Future<void> _carregarDadosPet() async {
    try {
      final doc = await FirebaseFirestore.instance.collection('pets').doc(widget.petId).get();
      if (!doc.exists) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Pet não encontrado.')),
          );
          Navigator.of(context).pop();
        }
        return;
      }

      final data = doc.data()!;
      _nomeController.text = data['nome'] ?? '';
      _descricaoController.text = data['descricao'] ?? '';
      _tipoSelecionado = data['tipo'];
      _tamanhoSelecionado = data['tamanho'];
      _sexoSelecionado = data['sexo'];
      _fotoUrl = data['foto'];

      setState(() {
        _carregandoDados = false;
      });
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao carregar dados do pet: $e')),
        );
        Navigator.of(context).pop();
      }
    }
  }

  Future<void> _selecionarImagem() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imagemSelecionada = File(pickedFile.path);
        _fotoUrl = null; // Remove a url para mostrar a imagem nova local
      });
    }
  }

  Future<void> _salvarAlteracoes() async {
    if (!_formKey.currentState!.validate()) return;

    if (_tipoSelecionado == null || _tamanhoSelecionado == null || _sexoSelecionado == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Preencha todos os campos obrigatórios.')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Aqui você precisaria tratar o upload da imagem caso queira salvar imagem nova
      // Como o Firebase Storage não está disponível, manteremos a url antiga se não alterar

      await FirebaseFirestore.instance.collection('pets').doc(widget.petId).update({
        'nome': _nomeController.text.trim(),
        'descricao': _descricaoController.text.trim(),
        'tipo': _tipoSelecionado,
        'tamanho': _tamanhoSelecionado,
        'sexo': _sexoSelecionado,
        'foto': _fotoUrl, // mantemos a foto atual
      });

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Pet atualizado com sucesso!')),
        );
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao atualizar pet: $e')),
        );
      }
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
    if (_carregandoDados) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Pet', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFFFFA726),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Nome
              TextFormField(
                controller: _nomeController,
                decoration: const InputDecoration(
                  labelText: 'Nome',
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value == null || value.trim().isEmpty ? 'Informe o nome' : null,
              ),
              const SizedBox(height: 16),

              // Descrição
              TextFormField(
                controller: _descricaoController,
                decoration: const InputDecoration(
                  labelText: 'Descrição',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
                validator: (value) => value == null || value.trim().isEmpty ? 'Informe a descrição' : null,
              ),
              const SizedBox(height: 16),

              // Tipo
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
                validator: (value) => value == null || value.isEmpty ? 'Selecione o tipo do animal' : null,
              ),
              const SizedBox(height: 16),

              // Tamanho
              DropdownButtonFormField<String>(
                value: _tamanhoSelecionado,
                decoration: const InputDecoration(
                  labelText: 'Tamanho',
                  border: OutlineInputBorder(),
                ),
                items: _tamanhos
                    .map((tam) => DropdownMenuItem(value: tam, child: Text(tam)))
                    .toList(),
                onChanged: (val) => setState(() => _tamanhoSelecionado = val),
                validator: (value) => value == null ? 'Selecione o tamanho do pet' : null,
              ),
              const SizedBox(height: 16),

              // Sexo
              DropdownButtonFormField<String>(
                value: _sexoSelecionado,
                decoration: const InputDecoration(
                  labelText: 'Sexo',
                  border: OutlineInputBorder(),
                ),
                items: _sexos
                    .map((sexo) => DropdownMenuItem(value: sexo, child: Text(sexo)))
                    .toList(),
                onChanged: (val) => setState(() => _sexoSelecionado = val),
                validator: (value) => value == null ? 'Selecione o sexo do pet' : null,
              ),
              const SizedBox(height: 24),

              // Imagem
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
                  child: _imagemSelecionada != null
                      ? Image.file(_imagemSelecionada!, fit: BoxFit.cover)
                      : (_fotoUrl != null
                          ? Image.network(_fotoUrl!, fit: BoxFit.cover)
                          : const Center(child: Text('Toque para selecionar a foto do pet'))),
                ),
              ),
              const SizedBox(height: 24),

              // Botão salvar
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _salvarAlteracoes,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFFA726),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          'Salvar Alterações',
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
