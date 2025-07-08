import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'detalhes_pet_page.dart';
import 'package:app_teste1/widgets/botao_favorito.dart';

class AdocaoPage extends StatefulWidget {
  const AdocaoPage({super.key});

  @override
  State<AdocaoPage> createState() => _AdocaoPageState();
}

class _AdocaoPageState extends State<AdocaoPage> {
  String _searchQuery = '';
  String _filtroTipo = '';
  String _filtroTamanho = '';
  String _filtroSexo = '';

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Barra de pesquisa
        Padding(
          padding: const EdgeInsets.all(12),
          child: TextField(
            decoration: const InputDecoration(
              hintText: 'Buscar por nome',
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(),
            ),
            onChanged: (value) {
              setState(() {
                _searchQuery = value.toLowerCase();
              });
            },
          ),
        ),

        // Filtros
        Wrap(
          spacing: 8,
          runSpacing: 4,
          alignment: WrapAlignment.start,
          children: [
            _buildChip('Cachorro', _filtroTipo, (val) {
              setState(() => _filtroTipo = val);
            }),
            _buildChip('Gato', _filtroTipo, (val) {
              setState(() => _filtroTipo = val);
            }),
            _buildChip('Pequeno', _filtroTamanho, (val) {
              setState(() => _filtroTamanho = val);
            }),
            _buildChip('Médio', _filtroTamanho, (val) {
              setState(() => _filtroTamanho = val);
            }),
            _buildChip('Grande', _filtroTamanho, (val) {
              setState(() => _filtroTamanho = val);
            }),
            _buildChip('Macho', _filtroSexo, (val) {
              setState(() => _filtroSexo = val);
            }),
            _buildChip('Fêmea', _filtroSexo, (val) {
              setState(() => _filtroSexo = val);
            }),
            ActionChip(
              label: const Text('Limpar filtros'),
              onPressed: () {
                setState(() {
                  _filtroTipo = '';
                  _filtroTamanho = '';
                  _filtroSexo = '';
                  _searchQuery = '';
                });
              },
              backgroundColor: Colors.grey.shade200,
            ),
          ],
        ),

        const SizedBox(height: 8),

        // Lista de pets
        Expanded(
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection('pets').snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return const Center(child: Text('Nenhum animal disponível.'));
              }

              final animais = snapshot.data!.docs.where((doc) {
                final data = doc.data() as Map<String, dynamic>;
                final nome = (data['nome'] ?? '').toString().toLowerCase();
                final tipo = (data['tipo'] ?? '').toString();
                final tamanho = (data['tamanho'] ?? '').toString();
                final sexo = (data['sexo'] ?? '').toString();

                final correspondeBusca = _searchQuery.isEmpty || nome.contains(_searchQuery);
                final correspondeTipo = _filtroTipo.isEmpty || tipo == _filtroTipo;
                final correspondeTamanho = _filtroTamanho.isEmpty || tamanho == _filtroTamanho;
                final correspondeSexo = _filtroSexo.isEmpty || sexo == _filtroSexo;

                return correspondeBusca && correspondeTipo && correspondeTamanho && correspondeSexo;
              }).toList();

              if (animais.isEmpty) {
                return const Center(child: Text('Nenhum animal encontrado com esses critérios.'));
              }

              return GridView.builder(
                padding: const EdgeInsets.all(12),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.75,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                ),
                itemCount: animais.length,
                itemBuilder: (context, index) {
                  final animal = animais[index];
                  final data = animal.data() as Map<String, dynamic>;
                  final nome = data['nome'] ?? 'Sem nome';
                  final descricao = data['descricao'] ?? '';
                  final foto = data['foto'] ?? '';
                  final tipo = data['tipo'] ?? '';

                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => DetalhesPetPage(petId: animal.id),
                        ),
                      );
                    },
                    child: Card(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      elevation: 3,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                            child: Image.network(
                              foto.isNotEmpty
                                  ? foto
                                  : 'https://via.placeholder.com/300x200?text=Sem+Imagem',
                              height: 120,
                              width: double.infinity,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  const Icon(Icons.broken_image),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Chip(
                                  label: Text(tipo),
                                  backgroundColor: Colors.green.shade100,
                                  visualDensity: VisualDensity.compact,
                                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                  labelStyle: const TextStyle(fontSize: 12),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  nome,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold, fontSize: 16),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  descricao,
                                  style: const TextStyle(
                                      fontSize: 12, color: Colors.black54),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 6),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: BotaoFavorito(petId: animal.id, detalhesPage: false),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildChip(String label, String selected, void Function(String) onSelected) {
    final bool isSelected = selected == label;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (_) => onSelected(isSelected ? '' : label),
      selectedColor: const Color(0xFFFFA726),
      labelStyle: TextStyle(
        color: isSelected ? Colors.white : Colors.black,
      ),
    );
  }
}
