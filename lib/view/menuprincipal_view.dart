// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MenuPrincipalView extends StatelessWidget {
  const MenuPrincipalView({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Menu Principal'),
          leading: Image.asset(
            'assets/images/wyvernlogo.png',
            height: 40,
            width: 40,
            fit: BoxFit.contain,
          ),
        ),
        body: const Center(
          child: Text(
            'Usuário não autenticado. Faça login para ver seus servidores.',
            style: TextStyle(color: Colors.white, fontSize: 16),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    final stream = FirebaseFirestore.instance
        .collection('servidores')
        .where('donoId', isEqualTo: user.uid)
        .orderBy('criadoEm', descending: true)
        .snapshots();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Menu Principal'),
        leading: Image.asset(
          'assets/images/wyvernlogo.png',
          height: 40,
          width: 40,
          fit: BoxFit.contain,
        ),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'configuracoes') {
                Navigator.pushNamed(context, 'personalizacao');
              } else if (value == 'informacoes') {
                Navigator.pushNamed(context, 'informacoes');
              } else if (value == 'sobre') {
                Navigator.pushNamed(context, 'sobre');
              }
            },
            itemBuilder: (BuildContext context) => [
              const PopupMenuItem<String>(
                value: 'informacoes',
                child: Text('Informações'),
              ),
              const PopupMenuItem<String>(
                value: 'sobre',
                child: Text('Sobre o Projeto'),
              ),
              const PopupMenuItem<String>(
                value: 'configuracoes',
                child: Text('Configurações'),
              ),
            ],
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: stream,
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        'Erro ao carregar servidores: ${snapshot.error}',
                        style: const TextStyle(color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                    );
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  final docs = snapshot.data?.docs ?? [];
                  if (docs.isEmpty) {
                    return const Center(
                      child: Text(
                        'Nenhum servidor encontrado. Adicione um servidor para começar.',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                        textAlign: TextAlign.center,
                      ),
                    );
                  }

                  return ListView.separated(
                    itemCount: docs.length,
                    separatorBuilder: (context, index) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final data = docs[index].data();
                      final nome = data['nome'] as String? ?? 'Servidor';
                      final categoria = data['categoria'] as String? ?? 'Categoria';
                      final timestamp = data['criadoEm'] as Timestamp?;
                      final criadoEm = timestamp != null
                          ? DateTime.fromMillisecondsSinceEpoch(timestamp.millisecondsSinceEpoch)
                          : null;

                      return Card(
                        color: const Color(0xFF2F3136),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: ListTile(
                          title: Text(
                            nome,
                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Categoria: $categoria',
                                style: const TextStyle(color: Colors.white70),
                              ),
                              if (criadoEm != null)
                                Text(
                                  'Criado em: ${criadoEm.toLocal().toString().split('.').first}',
                                  style: const TextStyle(color: Colors.white54, fontSize: 12),
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
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.pushNamed(context, 'addserver');
              },
              icon: const Icon(Icons.add, color: Colors.white),
              label: const Text('Adicionar servidor'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF5865F2),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.pushNamed(context, 'amigos');
        },
        label: const Text('Amigos'),
        icon: const Icon(Icons.people),
      ),
    );
  }
}
