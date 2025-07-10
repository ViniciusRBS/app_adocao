import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatPage extends StatefulWidget {
  final String conversaId;
  final String userId;

  const ChatPage({Key? key, required this.conversaId, required this.userId}) : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _mensagemController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _marcarMensagensLidas();
  }

void _marcarMensagensLidas() async {
  final mensagensRef = FirebaseFirestore.instance
      .collection('conversas')
      .doc(widget.conversaId)
      .collection('mensagens');

  final allMessagesSnapshot = await mensagensRef.get();

  for (var msg in allMessagesSnapshot.docs) {
    final data = msg.data();
    final lidas = List<String>.from(data['lidas'] ?? []);
    final remetente = data['remetenteId'];
    if (!lidas.contains(widget.userId) && remetente != widget.userId) {
      await msg.reference.update({
        'lidas': FieldValue.arrayUnion([widget.userId])
      });
    }
  }
}


  void _enviarMensagem() async {
    final texto = _mensagemController.text.trim();
    if (texto.isEmpty) return;

    await FirebaseFirestore.instance
        .collection('conversas')
        .doc(widget.conversaId)
        .collection('mensagens')
        .add({
      'texto': texto,
      'remetenteId': widget.userId,
      'timestamp': FieldValue.serverTimestamp(),
      'lidas': [widget.userId], // Já marca como lida para quem enviou
    });

    _mensagemController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(''),
        backgroundColor: const Color(0xFFFFA726),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('conversas')
                    .doc(widget.conversaId)
                    .collection('mensagens')
                    .orderBy('timestamp', descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(child: Text('Nenhuma mensagem ainda.'));
                  }

                  final mensagens = snapshot.data!.docs;

                  return ListView.builder(
                    reverse: true,
                    physics: const BouncingScrollPhysics(),
                    itemCount: mensagens.length,
                    itemBuilder: (context, index) {
                      final msg = mensagens[index];
                      final texto = msg['texto'];
                      final isMinha = msg['remetenteId'] == widget.userId;

                      return Align(
                        alignment: isMinha ? Alignment.centerRight : Alignment.centerLeft,
                        child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: isMinha ? const Color(0xFFFFA726) : Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            texto,
                            style: TextStyle(
                              color: isMinha ? Colors.white : Colors.black,
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _mensagemController,
                      maxLines: 3,
                      minLines: 1,
                      decoration: const InputDecoration(
                        hintText: 'Digite uma mensagem...',
                        border: OutlineInputBorder(),
                        isDense: true,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.send, color: Color(0xFFFFA726)),
                    onPressed: _enviarMensagem,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _mensagemController.dispose();
    super.dispose();
  }
}
