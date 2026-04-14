import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import '../controller/iniciarlogin_controller.dart';

class RecuperarSenhaView extends StatefulWidget {
  const RecuperarSenhaView({super.key});

  @override
  State<RecuperarSenhaView> createState() => _RecuperarSenhaViewState();
}

class _RecuperarSenhaViewState extends State<RecuperarSenhaView> {
  // Chave para validar o formulário
  final _formKey = GlobalKey<FormState>();
  
  // Controller para ler o email
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  // Função que valida e mostra AlertDialog
  void _solicitarRecuperacao() {
    // 1. Valida o formulário
    if (_formKey.currentState?.validate() ?? false) {
      final email = _emailController.text.trim();
      final controller = GetIt.instance<IniciarloginController>();

      // 2. Verifica se o email está cadastrado
      if (!controller.isEmailCadastrado(email)) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('E-mail não cadastrado'),
              content: const Text(
                'O e-mail informado não está registrado. Verifique e tente novamente.',
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);      // fecha o AlertDialog
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
        return;
      }

      // 3. Se válido e cadastrado, mostra AlertDialog de sucesso
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Solicitação enviada'),
            content: Text(
              'Um link de recuperação foi enviado para:\n\n$email\n\nVerifique sua caixa de entrada.',
            ),
            actions: [
              TextButton( // botão para fechar o AlertDialog e voltar ao login
                onPressed: () {
                  Navigator.pop(context); // fecha o AlertDialog
                  Navigator.pop(context); // volta pra tela de login
                },
                child: const Text('OK'), // texto do botão
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