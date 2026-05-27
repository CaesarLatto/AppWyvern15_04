import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class RecuperarSenhaView extends StatefulWidget {
  const RecuperarSenhaView({super.key});

  @override
  State<RecuperarSenhaView> createState() => _RecuperarSenhaViewState();
}

class _RecuperarSenhaViewState extends State<RecuperarSenhaView> {
  final AuthService _authService = AuthService();
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _solicitarRecuperacao() async {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    final email = _emailController.text.trim();

    try {
      await _authService.sendPasswordResetEmail(email);

      if (!mounted) return;
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Solicitação enviada'),
            content: Text(
              'Um link de recuperação foi enviado para:\n\n$email\n\nVerifique sua caixa de entrada.',
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;
      String title = 'Erro';
      String message = 'Não foi possível enviar o e-mail de recuperação. Tente novamente.';

      if (e.code == 'user-not-found') {
        title = 'E-mail não cadastrado';
        message = 'O e-mail informado não está registrado. Verifique e tente novamente.';
      } else if (e.code == 'invalid-email') {
        title = 'E-mail inválido';
        message = 'O e-mail informado não tem um formato válido.';
      } else if (e.code == 'too-many-requests') {
        title = 'Muitas tentativas';
        message = 'Você tentou muitas vezes. Aguarde alguns instantes e tente novamente.';
      } else if (e.message != null && e.message!.isNotEmpty) {
        message = e.message!;
      }

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(title),
            content: Text(message),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    } catch (_) {
      if (!mounted) return;
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Erro inesperado'),
            content: const Text('Ocorreu um erro inesperado. Tente novamente mais tarde.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Recuperar senha')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 24),
                const Text(
                  'Insira seu e-mail cadastrado para recuperar sua senha',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),

                // Campo de email
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  style: const TextStyle(color: Colors.white),
                  cursorColor: Colors.white,
                  decoration: const InputDecoration(
                    labelText: 'E-mail',
                    hintText: 'seu@email.com',
                    prefixIcon: Icon(Icons.email),
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    // 1. Verifica se o campo está vazio
                    if (value == null || value.trim().isEmpty) {
                      return 'Por favor, informe seu e-mail';
                    }
                    
                    // 2. Verifica se é um email válido (contém @)
                    if (!value.contains('@')) {
                      return 'E-mail inválido';
                    }
                    
                    // 3. Verifica se tem um ponto após o @
                    if (!value.contains('.')) {
                      return 'E-mail inválido';
                    }
                    
                    return null; // email válido
                  },
                ),
                const SizedBox(height: 24),

                // Botão para solicitar recuperação
                ElevatedButton(
                  onPressed: _solicitarRecuperacao,
                  child: const Text('Solicitar recuperação'),
                ),
                const SizedBox(height: 16),

                // Link para voltar ao login
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Voltar ao login'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}