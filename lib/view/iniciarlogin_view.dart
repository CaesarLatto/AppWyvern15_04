import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import '../controller/iniciarlogin_controller.dart';

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

  @override
  // função para descartar os controllers quando sai da tela
  void dispose(){
    _emailController.dispose();
    _senhaController.dispose();
    super.dispose();
  }

  void _fazerLogin(){
    // valida todos os campos/validadores do formulário
    if (_formKey.currentState!.validate()) {
      final email = _emailController.text.trim();
      final senha = _senhaController.text.trim();
      final controller = GetIt.instance<IniciarloginController>();

      if (!controller.isEmailCadastrado(email)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('E-mail não cadastrado')),
        );
        return;
      }

      if (!controller.verificarLogin(email, senha)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Credenciais incorretas')),
        );
        return;
      }

      // Login bem-sucedido
      controller.definirUsuarioLogado(email);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Login realizado com sucesso! Bem-vindo, $email')),
      );

      // Navegar para a página principal
      Navigator.pushReplacementNamed(context, 'menuprincipal');
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
                    if(value.trim().length < 8) {
                      return 'A senha deve conter pelo menos 8 caracteres.';
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
                  onPressed: _fazerLogin,
                  child: Text('Entrar'),
                ),
                const SizedBox(height: 16),

                //link pra ir pra tela de cadastro
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, 'cadastro');
                  },
                  child: Text('Não tem uma conta? Cadastre-se')
                ),
              ],
            ),
          ),
        ),
      )
    );
  }
}