import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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
  List<String> _fotosUrls = [];
  List<File> _novasImagens = [];

  bool _isLoading = false;
  bool _carregandoDados = true;

  final List<String> _tamanhos = ['Pequeno', 'Médio', 'Grande'];
  final List<String> _sexos = ['Macho', 'Fêmea'];
  List<String> _tiposAnimais = [];

  final picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _carregarTiposDoFirebase();
    _carregarDadosPet();
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

  Future<void> _carregarDadosPet() async {
    try {
      final doc = await FirebaseFirestore.instance.collection('pets').doc(widget.petId).get();
      if (!doc.exists) return;

      final data = doc.data()!;
      _nomeController.text = data['nome'] ?? '';
      _descricaoController.text = data['descricao'] ?? '';
      _tipoSelecionado = data['tipo'];
      _tamanhoSelecionado = data['tamanho'];
      _sexoSelecionado = data['sexo'];
      _fotosUrls = List<String>.from(data['fotos'] ?? []);

      setState(() {
        _carregandoDados = false;
      });
    } catch (e) {
      print('Erro ao carregar dados do pet: $e');
    }
  }

  Future<void> _selecionarImagem() async {
    final picked = await picker.pickMultiImage();
    if (picked.isNotEmpty) {
      setState(() {
        _novasImagens.addAll(picked.map((e) => File(e.path)));
      });
    }
  }

  Future<String?> _uploadParaCloudinary(File imagem) async {
    const cloudName = 'SEU_CLOUD_NAME';
    const uploadPreset = 'SEU_UPLOAD_PRESET';

    final url = Uri.parse('https://api.cloudinary.com/v1_1/$cloudName/image/upload');
    final request = http.MultipartRequest('POST', url)
      ..fields['upload_preset'] = uploadPreset
      ..files.add(await http.MultipartFile.fromPath('file', imagem.path));

    final response = await request.send();
    if (response.statusCode == 200) {
      final respStr = await response.stream.bytesToString();
      final data = json.decode(respStr);
      return data['secure_url'];
    } else {
      print('Erro no upload: ${response.statusCode}');
      return null;
    }
  }

  Future<void> _salvarAlteracoes() async {
    if (!_formKey.currentState!.validate()) return;

    if (_tipoSelecionado == null || _tamanhoSelecionado == null || _sexoSelecionado == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Preencha todos os campos obrigatórios')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      List<String> imagensFinal = List.from(_fotosUrls);

      for (File img in _novasImagens) {
        final url = await _uploadParaCloudinary(img);
        if (url != null) imagensFinal.add(url);
      }

      await FirebaseFirestore.instance.collection('pets').doc(widget.petId).update({
        'nome': _nomeController.text.trim(),
        'descricao': _descricaoController.text.trim(),
        'tipo': _tipoSelecionado,
        'tamanho': _tamanhoSelecionado,
        'sexo': _sexoSelecionado,
        'fotos': imagensFinal,
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Pet atualizado com sucesso!')),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao salvar alterações: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _removerImagem(String url) {
    setState(() {
      _fotosUrls.remove(url);
    });
  }

  void _removerNovaImagem(File file) {
    setState(() {
      _novasImagens.remove(file);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_carregandoDados) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Pet'),
        backgroundColor: const Color(0xFFFFA726),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Campos de texto
              TextFormField(
                controller: _nomeController,
                decoration: const InputDecoration(labelText: 'Nome', border: OutlineInputBorder()),
                validator: (value) => value!.isEmpty ? 'Informe o nome' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descricaoController,
                decoration: const InputDecoration(labelText: 'Descrição', border: OutlineInputBorder()),
                maxLines: 3,
                validator: (value) => value!.isEmpty ? 'Informe a descrição' : null,
              ),
              const SizedBox(height: 16),

              // Dropdowns
              DropdownButtonFormField<String>(
                value: _tipoSelecionado,
                items: _tiposAnimais.map((tipo) => DropdownMenuItem(value: tipo, child: Text(tipo))).toList(),
                decoration: const InputDecoration(labelText: 'Tipo de animal', border: OutlineInputBorder()),
                onChanged: (val) => setState(() => _tipoSelecionado = val),
                validator: (value) => value == null ? 'Selecione o tipo' : null,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _tamanhoSelecionado,
                items: _tamanhos.map((t) => DropdownMenuItem(value: t, child: Text(t))).toList(),
                decoration: const InputDecoration(labelText: 'Tamanho', border: OutlineInputBorder()),
                onChanged: (val) => setState(() => _tamanhoSelecionado = val),
                validator: (value) => value == null ? 'Selecione o tamanho' : null,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _sexoSelecionado,
                items: _sexos.map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
                decoration: const InputDecoration(labelText: 'Sexo', border: OutlineInputBorder()),
                onChanged: (val) => setState(() => _sexoSelecionado = val),
                validator: (value) => value == null ? 'Selecione o sexo' : null,
              ),
              const SizedBox(height: 24),

              // Imagens existentes
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  ..._fotosUrls.map((url) => Stack(
                        alignment: Alignment.topRight,
                        children: [
                          Image.network(url, width: 100, height: 100, fit: BoxFit.cover),
                          IconButton(
                            icon: const Icon(Icons.close, color: Colors.red),
                            onPressed: () => _removerImagem(url),
                          ),
                        ],
                      )),
                  ..._novasImagens.map((file) => Stack(
                        alignment: Alignment.topRight,
                        children: [
                          Image.file(file, width: 100, height: 100, fit: BoxFit.cover),
                          IconButton(
                            icon: const Icon(Icons.close, color: Colors.red),
                            onPressed: () => _removerNovaImagem(file),
                          ),
                        ],
                      )),
                  GestureDetector(
                    onTap: _selecionarImagem,
                    child: Container(
                      width: 100,
                      height: 100,
                      color: Colors.grey[300],
                      child: const Icon(Icons.add_a_photo, size: 32),
                    ),
                  ),
                ],
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
                      : const Text('Salvar Alterações', style: TextStyle(fontSize: 18, color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
