import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CadastroPetPage extends StatefulWidget {
  const CadastroPetPage({super.key});

  @override
  State<CadastroPetPage> createState() => _CadastroPetPageState();
}

class _CadastroPetPageState extends State<CadastroPetPage> {
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _descricaoController = TextEditingController();

  String? _tipoSelecionado;
  String? _tamanhoSelecionado;
  String? _sexoSelecionado;
  List<File> _imagensSelecionadas = [];
  List<String> _tiposAnimais = [];
  bool _isLoading = false;

  final List<String> _tamanhos = ['Pequeno', 'Médio', 'Grande'];
  final List<String> _sexos = ['Macho', 'Fêmea'];

  @override
  void initState() {
    super.initState();
    _carregarTiposDoFirebase();
  }

  Future<void> _carregarTiposDoFirebase() async {
    try {
      final snapshot = await FirebaseFirestore.instance.collection('tipos').get();
      setState(() {
        _tiposAnimais = snapshot.docs.map((doc) => doc['nome'].toString()).toList();
      });
    } catch (e) {
      print('Erro ao carregar tipos: $e');
    }
  }

  Future<void> _selecionarImagens() async {
    final picker = ImagePicker();
    final pickedFiles = await picker.pickMultiImage();
    if (pickedFiles.isNotEmpty) {
      setState(() {
        _imagensSelecionadas = pickedFiles.map((xfile) => File(xfile.path)).toList();
      });
    }
  }

  Future<List<String>> _uploadImagensParaCloudinary() async {
    const cloudName = 'dld0caeon';
    const uploadPreset = 'unsigned_preset';
    final urls = <String>[];

    for (var imagem in _imagensSelecionadas) {
      final bytes = await imagem.readAsBytes();
      final uri = Uri.parse('https://api.cloudinary.com/v1_1/$cloudName/image/upload');
      final request = http.MultipartRequest('POST', uri)
        ..fields['upload_preset'] = uploadPreset
        ..files.add(http.MultipartFile.fromBytes('file', bytes, filename: 'imagem.jpg'));

      final response = await request.send();
      final result = await http.Response.fromStream(response);
      final data = jsonDecode(result.body);

      if (response.statusCode == 200 && data['secure_url'] != null) {
        urls.add(data['secure_url']);
      } else {
        throw Exception('Erro ao fazer upload: ${data['error']['message']}');
      }
    }

    return urls;
  }

  Future<void> _salvarPet() async {
    if (!_formKey.currentState!.validate() || _tipoSelecionado == null || _tamanhoSelecionado == null || _sexoSelecionado == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Preencha todos os campos obrigatórios.')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) throw Exception('Usuário não autenticado.');

      final imagensUrls = await _uploadImagensParaCloudinary();

      await FirebaseFirestore.instance.collection('pets').add({
        'nome': _nomeController.text.trim(),
        'descricao': _descricaoController.text.trim(),
        'tipo': _tipoSelecionado,
        'tamanho': _tamanhoSelecionado,
        'sexo': _sexoSelecionado,
        'fotos': imagensUrls,
        'userId': user.uid,
        'criadoEm': FieldValue.serverTimestamp(),
        'favoritadoPor': [],
      });

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Pet cadastrado com sucesso.')));
      Navigator.of(context).pop();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erro: $e')));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cadastrar Pet'), backgroundColor: const Color(0xFFFFA726)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(controller: _nomeController, decoration: const InputDecoration(labelText: 'Nome', border: OutlineInputBorder()), validator: (v) => v!.isEmpty ? 'Informe o nome' : null),
              const SizedBox(height: 16),
              TextFormField(controller: _descricaoController, decoration: const InputDecoration(labelText: 'Descrição', border: OutlineInputBorder()), maxLines: 3, validator: (v) => v!.isEmpty ? 'Informe a descrição' : null),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(value: _tipoSelecionado, decoration: const InputDecoration(labelText: 'Tipo', border: OutlineInputBorder()), items: _tiposAnimais.map((tipo) => DropdownMenuItem(value: tipo, child: Text(tipo))).toList(), onChanged: (val) => setState(() => _tipoSelecionado = val), validator: (v) => v == null ? 'Selecione o tipo' : null),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(value: _tamanhoSelecionado, decoration: const InputDecoration(labelText: 'Tamanho', border: OutlineInputBorder()), items: _tamanhos.map((tam) => DropdownMenuItem(value: tam, child: Text(tam))).toList(), onChanged: (val) => setState(() => _tamanhoSelecionado = val), validator: (v) => v == null ? 'Selecione o tamanho' : null),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(value: _sexoSelecionado, decoration: const InputDecoration(labelText: 'Sexo', border: OutlineInputBorder()), items: _sexos.map((sexo) => DropdownMenuItem(value: sexo, child: Text(sexo))).toList(), onChanged: (val) => setState(() => _sexoSelecionado = val), validator: (v) => v == null ? 'Selecione o sexo' : null),
              const SizedBox(height: 24),
              ElevatedButton.icon(onPressed: _selecionarImagens, icon: const Icon(Icons.photo_library), label: const Text('Selecionar Imagens'), style: ElevatedButton.styleFrom(backgroundColor: Colors.grey[300])),
              const SizedBox(height: 10),
              if (_imagensSelecionadas.isNotEmpty)
                SizedBox(
                  height: 120,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: _imagensSelecionadas.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 10),
                    itemBuilder: (_, i) => ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.file(_imagensSelecionadas[i], height: 100, width: 100, fit: BoxFit.cover),
                    ),
                  ),
                ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _salvarPet,
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFFFA726), padding: const EdgeInsets.symmetric(vertical: 16)),
                  child: _isLoading ? const CircularProgressIndicator(color: Colors.white) : const Text('Salvar Pet', style: TextStyle(fontSize: 18, color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
// End of file