import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatServidorView extends StatefulWidget {
  final String servidorId;
  final String nomeServidor;

  const ChatServidorView({
    super.key,
    required this.servidorId,
    required this.nomeServidor,
  });

  @override
  State<ChatServidorView> createState() => _ChatServidorViewState();
}

class _ChatServidorViewState extends State<ChatServidorView> {
  final TextEditingController _messageController = TextEditingController();
  bool _isSending = false;

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _sendMessage() async {
    final messageText = _messageController.text.trim();
    if (messageText.isEmpty) return;

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Faça login para enviar mensagens.')),
      );
      return;
    }

    setState(() {
      _isSending = true;
    });

    try {
      // Criterio 003: Inserção da mensagem na subcoleção do servidor, com remetente e timestamp.
      // Campos: texto, remetenteNome, remetenteEmail, enviadoEm (serverTimestamp)
      await FirebaseFirestore.instance
          .collection('servidores')
          .doc(widget.servidorId)
          .collection('mensagens')
          .add({
        'texto': messageText,
        'remetenteNome': user.displayName ?? 'Usuário Wyvern',
        'remetenteEmail': user.email ?? 'email desconhecido',
        'enviadoEm': FieldValue.serverTimestamp(),
      });
      _messageController.clear();
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao enviar mensagem: ${error.toString()}')),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isSending = false;
        });
      }
    }
  }

  Widget _buildMessageTile(Map<String, dynamic> data, String currentUserEmail) {
    final text = data['texto'] as String? ?? '';
    final senderName = data['remetenteNome'] as String? ?? 'Wyvern';
    final senderEmail = data['remetenteEmail'] as String? ?? 'email@wyvern.com';
    final timestamp = data['enviadoEm'] as Timestamp?;
    final sentAt = timestamp != null
        ? DateTime.fromMillisecondsSinceEpoch(timestamp.millisecondsSinceEpoch)
        : null;
    final isMine = senderEmail == currentUserEmail;

    return Align(
      alignment: isMine ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
        decoration: BoxDecoration(
          color: isMine ? const Color(0xFF5865F2) : const Color(0xFF2F3136),
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: Radius.circular(isMine ? 16 : 4),
            bottomRight: Radius.circular(isMine ? 4 : 16),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              senderName,
              style: TextStyle(
                color: isMine ? Colors.white70 : Colors.white60,
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              text,
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
            if (sentAt != null) ...[
              const SizedBox(height: 8),
              Text(
                '${sentAt.toLocal().hour.toString().padLeft(2, '0')}:${sentAt.toLocal().minute.toString().padLeft(2, '0')}',
                style: TextStyle(
                  color: Colors.white54,
                  fontSize: 11,
                ),
              ),
            ]
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final currentUserEmail = user?.email ?? '';
    // Criterio 005: Leitura em tempo real das mensagens do chat na subcoleção do servidor.
    // Ordenado por 'enviadoEm' desc para uso com ListView(reverse: true)
    final messagesStream = FirebaseFirestore.instance
        .collection('servidores')
        .doc(widget.servidorId)
        .collection('mensagens')
        .orderBy('enviadoEm', descending: true)
        .snapshots();

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.nomeServidor),
        backgroundColor: const Color(0xFF2F3136),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: messagesStream,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      'Erro ao carregar chat: ${snapshot.error}',
                      style: const TextStyle(color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                  );
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(color: Colors.white),
                  );
                }

                final messages = snapshot.data?.docs ?? [];
                if (messages.isEmpty) {
                  return const Center(
                    child: Text(
                      'Nenhuma mensagem ainda. Seja o primeiro a enviar!',
                      style: TextStyle(color: Colors.white70),
                      textAlign: TextAlign.center,
                    ),
                  );
                }

                return ListView.builder(
                  reverse: true,
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final data = messages[index].data();
                    return _buildMessageTile(data, currentUserEmail);
                  },
                );
              },
            ),
          ),
          Container(
            color: const Color(0xFF2F3136),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    style: const TextStyle(color: Colors.white),
                    cursorColor: Colors.white,
                    decoration: InputDecoration(
                      hintText: 'Digite uma mensagem...',
                      hintStyle: const TextStyle(color: Colors.white54),
                      filled: true,
                      fillColor: const Color(0xFF36393E),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    ),
                    onSubmitted: (_) => _sendMessage(),
                  ),
                ),
                const SizedBox(width: 8),
                CircleAvatar(
                  backgroundColor: const Color(0xFF5865F2),
                  child: IconButton(
                    onPressed: _isSending ? null : _sendMessage,
                    icon: const Icon(Icons.send, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
