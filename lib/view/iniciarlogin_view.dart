import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import '../controller/iniciarlogin_controller.dart';
import '../services/auth_service.dart';

class IniciarloginView extends StatefulWidget{
  const IniciarloginView({super.key});

  @override
  State<IniciarloginView> createState() => _IniciarloginViewState();
}

class _IniciarloginViewState extends State<IniciarloginView> {
  //  Chave para validar o formuladio
  final _formKey = GlobalKey<FormState>();
  // Controllers que leem os campos de texto
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();

  final AuthService _authService = AuthService();
  bool _isLoading = false;

  @override
  // função para descartar os controllers quando sai da tela
  void dispose(){
    _emailController.dispose();
    _senhaController.dispose();
    super.dispose();
  }

  Future<void> _fazerLogin() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final email = _emailController.text.trim();
    final senha = _senhaController.text.trim();
    final controller = GetIt.instance<IniciarloginController>();

    try {
      // Criterio 001: Login com e-mail/senha e feedback visual do resultado. O código começa nesta linha e vai até o fim da lógica de login.
      final credential = await _authService.signIn(
        email: email,
        password: senha,
      );

      if (!mounted) return;
      // Firebase RF 001, Autenticação de Usuários: armazena estado do usuário (email/nome) no controller para compartilhar entre telas
      controller.definirUsuarioLogado(email, credential.user?.displayName);

      final uid = credential.user?.uid;
      if (uid != null) {
        try {
          final fetchedName = await _authService.fetchUserName(uid);
          if (fetchedName != null && mounted) {
            controller.definirUsuarioLogado(email, fetchedName);
          }
        } catch (_) {
          // Não bloqueia a navegação caso a leitura do perfil falhe.
        }
      }

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Login realizado com sucesso! Bem-vindo, ${controller.usuarioLogadoNome.isNotEmpty ? controller.usuarioLogadoNome : email}')),
      );

      // Firebase RF 001, Autenticação de Usuários: navega para a tela principal após login bem-sucedido
      Navigator.pushReplacementNamed(context, 'menuprincipal');
    } on FirebaseAuthException catch (e) {
      String mensagem;
      if (e.code == 'user-not-found') {
        mensagem = 'Usuário não encontrado. Verifique o e-mail informado.';
      } else if (e.code == 'wrong-password') {
        mensagem = 'Senha incorreta. Tente novamente.';
      } else if (e.code == 'invalid-email') {
        mensagem = 'E-mail inválido. Verifique o formato.';
      } else if (e.code == 'user-disabled') {
        mensagem = 'Conta desabilitada. Contate o suporte.';
      } else {
        mensagem = 'Erro ao entrar: ${e.message ?? 'tente novamente.'}';
      }

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(mensagem)),
      );
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro inesperado ao entrar: ${error.toString()}')),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Wyvern-Login')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          // scroll evita que o teclado esconda os campos de texto
          child: Form(
            key: _formKey,
            child: Column( // organiza os widgets em coluna
              crossAxisAlignment: CrossAxisAlignment.stretch, // faz os filhos ocuparem toda a largura
              children: [ // lista de widgets filhos
                const SizedBox(height: 24), // espaço vertical
                Image.asset(
                  'assets/images/wyvernlogo.png',
                  height: 100,
                  width: 100,
                  fit: BoxFit.contain,
                ),
                const SizedBox(height: 24), // mais espaço vertical

                // campo de email 
                TextFormField( 
                  controller: _emailController, // conecta o campo de texto com o controller para ler o valor
                  keyboardType: TextInputType.emailAddress, // tipo de teclado específico para email
                  style: const TextStyle(color: Colors.white),
                  cursorColor: Colors.white,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    hintText: 'seu@email.com',
                    prefixIcon: const Icon(Icons.email),
                    border: const OutlineInputBorder(),
                  ), // rótulo do campo
                  validator: (value) {  // função de validação do campo
                    if (value == null || value.isEmpty) { // verifica se o campo está vazio
                      return 'Por favor, insira seu email'; // mensagem de erro se o campo estiver vazio
                    } 
                    if (!value.contains('@')) { // verifica se o email contém '@'
                      return 'Por favor, insira um email válido'; // mensagem de erro se o email for inválido
                    }
                    return null; // retorna null se o campo for válido, ou seja, não vazio
                  },
                ),
                const SizedBox(height: 16),
                

                TextFormField(     //campo de senha
                  controller: _senhaController,
                  style: const TextStyle(color: Colors.white),
                  cursorColor: Colors.white,
                  decoration: const InputDecoration(labelText: 'Senha'),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Por favor, insira sua senha';
                    }
                    if(value.trim().length < 6) {
                      return 'A senha deve conter pelo menos 6 caracteres.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),

                // Botão "Esqueci a senha"
                Align(
                  alignment: Alignment.centerRight, // alinha o botão à direita
                  child: TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, 'recuperar_senha'); // navega para a tela de recuperação de senha
                    },
                    child: const Text('Esqueci a senha'), // texto do botão
                  ),
                ),
                const SizedBox(height: 12),

                 // botão de login
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _isLoading ? null : _fazerLogin,
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : const Text('Entrar'),
                ),
                const SizedBox(height: 16),

                //link pra ir pra tela de cadastro
                TextButton(
                  onPressed: _isLoading
                      ? null
                      : () {
                          Navigator.pushNamed(context, 'cadastro');
                        },
                  child: const Text('Não tem uma conta? Cadastre-se'),
                ),
              ],
            ),
          ),
        ),
      )
    );
  }
}