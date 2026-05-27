import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
// 12/04 rf005 - tela de info adicional

import 'package:get_it/get_it.dart';
import '../controller/iniciarlogin_controller.dart';

class InformacoesView extends StatefulWidget {
  const InformacoesView({super.key});

  @override
  State<InformacoesView> createState() => _InformacoesViewState();
}

class _InformacoesViewState extends State<InformacoesView> {
  late final IniciarloginController _controller;
  late String _nome;
  late String _email;
  String? _advice;
  String? _adviceError;
  bool _isLoadingAdvice = false;

  @override
  void initState() {
    super.initState();
    _controller = GetIt.instance<IniciarloginController>();
    _nome = _controller.usuarioLogadoNome.isEmpty
        ? 'Nome do usuário'
        : _controller.usuarioLogadoNome;
    _email = _controller.usuarioLogadoEmail.isEmpty
        ? 'email@exemplo.com'
        : _controller.usuarioLogadoEmail;
    _fetchAdvice();
  }

  Future<void> _editarNome() async {
    final TextEditingController textController = TextEditingController(text: _nome);
    final novoNome = await showDialog<String?>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Editar Nome'),
          content: TextField(
            controller: textController,
            decoration: const InputDecoration(
              labelText: 'Novo nome',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(null),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                final value = textController.text.trim();
                if (value.isEmpty) return;
                Navigator.of(context).pop(value);
              },
              child: const Text('Salvar'),
            ),
          ],
        );
      },
    );

    if (novoNome == null || novoNome.isEmpty) {
      return;
    }

    await _atualizarNomeFirestore(novoNome);
  }

  Future<void> _atualizarNomeFirestore(String novoNome) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Usuário não autenticado. Faça login novamente.')),
      );
      return;
    }

    try {
      // Criterio 004: Atualização do nome do perfil no Firestore com feedback de sucesso/erro.
      await FirebaseFirestore.instance.collection('usuarios').doc(user.uid).update({
        'nome': novoNome,
      });

      if (!mounted) return;
      _controller.definirUsuarioLogado(_controller.usuarioLogadoEmail, novoNome);
      setState(() {
        _nome = novoNome;
      });

      // Atualizar displayName no Firebase Auth para manter consistência
      try {
        // Criterio 004: Sincronização do displayName do Firebase Auth com o nome atualizado no Firestore.
        await user.updateDisplayName(novoNome);
      } catch (_) {
        // não bloquear a UX se o update do Auth falhar
      }

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nome atualizado com sucesso.')),
      );
    } on FirebaseException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Falha ao atualizar nome: ${e.message}')),
      );
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro inesperado: ${error.toString()}')),
      );
    }
  }

  Future<void> _fetchAdvice() async {
    if (!mounted) return;
    setState(() {
      _isLoadingAdvice = true;
      _adviceError = null;
    });

    try {
      // Criterio 007: Consumo de uma API pública com tratamento de erro e parse JSON.
      final response = await http.get(Uri.parse('https://api.adviceslip.com/advice')).timeout(
            const Duration(seconds: 10),
          );

      if (response.statusCode != 200) {
        throw Exception('Resposta inválida: ${response.statusCode}');
      }

      final body = json.decode(response.body) as Map<String, dynamic>;
      final advice = (body['slip'] as Map<String, dynamic>)['advice'] as String?;
      if (advice == null || advice.isEmpty) {
        throw Exception('Resposta da API sem conselho válido.');
      }

      if (!mounted) return;
      setState(() {
        _advice = advice;
      });
    } catch (error) {
      if (mounted) {
        setState(() {
          _adviceError = 'Falha ao carregar conselho. Tente novamente.';
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoadingAdvice = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sobre o usuário'),
        backgroundColor: const Color(0xFF2F3136),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
            const SizedBox(height: 24),
            const CircleAvatar(
              radius: 48,
              backgroundColor: Colors.white24,
              child: Icon(
                Icons.person,
                size: 48,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              _nome,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _email,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 32),
            const Text(
              'Conselho do Wyvern',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            Card(
              color: const Color(0xFF40444B),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: _isLoadingAdvice
                    ? const SizedBox(
                        height: 48,
                        child: Center(
                          child: CircularProgressIndicator(color: Colors.white),
                        ),
                      )
                    : Text(
                        _adviceError ?? _advice ?? 'Aguardando conselho...',
                        style: TextStyle(
                          color: _adviceError != null ? Colors.red[200] : Colors.white70,
                          fontSize: 16,
                        ),
                      ),
              ),
            ),
            const SizedBox(height: 8),
            ElevatedButton.icon(
              onPressed: _isLoadingAdvice ? null : _fetchAdvice,
              icon: const Icon(Icons.refresh),
              label: const Text('Atualizar Conselho'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF5865F2),
              ),
            ),
            const SizedBox(height: 32),
            const Text(
              'Informações do perfil',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            Card(
              color: const Color(0xFF40444B),
              child: ListTile(
                title: const Text(
                  'Nome',
                  style: TextStyle(color: Colors.white70),
                ),
                subtitle: Text(
                  _nome,
                  style: const TextStyle(color: Colors.white),
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.edit, color: Colors.white70),
                  onPressed: _editarNome,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Card(
              color: const Color(0xFF40444B),
              child: ListTile(
                title: const Text(
                  'E-mail',
                  style: TextStyle(color: Colors.white70),
                ),
                subtitle: Text(
                  _email,
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF5865F2),
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              onPressed: () {
                // botão ilustrativo
              },
              child: const Text('Trocar senha'),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFED4245),
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              onPressed: () {
                // botão ilustrativo
              },
              child: const Text('Deletar Conta'),
            ),
          ],
          ),
        ),
      ),
    );
  }
}
