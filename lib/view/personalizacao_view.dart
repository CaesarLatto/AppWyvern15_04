
// 9/04 rf005 - tela de personalização

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import '../controller/iniciarlogin_controller.dart';

class PersonalizacaoView extends StatefulWidget {
  const PersonalizacaoView({super.key});

  @override
  State<PersonalizacaoView> createState() => _PersonalizacaoViewState();
}

class _PersonalizacaoViewState extends State<PersonalizacaoView> {
  late final IniciarloginController controller;

  @override
  void initState() {
    super.initState();
    controller = GetIt.instance<IniciarloginController>();
  }

  Future<void> _salvarConfiguracoes(bool notificacoes) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final ref = FirebaseFirestore.instance.collection('configuracoes').doc(user.uid);
    final snapshot = await ref.get();

    if (snapshot.exists) {
      await ref.update({
        'notificacoes': notificacoes,
        'tema': 'dark',
        'atualizadoEm': FieldValue.serverTimestamp(),
      });
      return;
    }

    await ref.set({
      'uid': user.uid,
      'email': user.email ?? '',
      'notificacoes': notificacoes,
      'tema': 'dark',
      'criadoEm': FieldValue.serverTimestamp(),
      'atualizadoEm': FieldValue.serverTimestamp(),
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Personalização'),
          ),
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 24),
                const Text(
                  'Personalização do app',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 24),
                SwitchListTile(
                  title: const Text('Ativar notificações'),
                  value: controller.aceitar,
                  onChanged: (value) async {
                    controller.atualizarAceitar(value);
                    await _salvarConfiguracoes(value);
                  },
                  // ignore: deprecated_member_use
                  activeColor: const Color(0xFF5865F2),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                    stream: FirebaseAuth.instance.currentUser?.uid == null
                        ? const Stream.empty()
                        : FirebaseFirestore.instance
                            .collection('configuracoes')
                            .doc(FirebaseAuth.instance.currentUser!.uid)
                            .snapshots(),
                    builder: (context, snapshot) {
                      final data = snapshot.data?.data();
                      final notificacoes = data?['notificacoes'] ?? controller.aceitar;
                      return Text(
                        notificacoes
                            ? 'Notificações ativadas no Firestore'
                            : 'Notificações desativadas no Firestore',
                        style: const TextStyle(color: Colors.white70),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF5865F2),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  onPressed: () {
                    // botão ilustrativo
                  },
                  child: const Text('Alterar saída de som'),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF5865F2),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  onPressed: () {
                    // botão ilustrativo
                  },
                  child: const Text('Alterar microfone'),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2F3136),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  onPressed: () {
                    // botão ilustrativo
                  },
                  child: const Text('Reiniciar para personalização original'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
