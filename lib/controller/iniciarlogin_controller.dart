import 'package:flutter/material.dart';

class IniciarloginController extends ChangeNotifier {
  // Aqui você pode adicionar a lógica de negócios para o login
  
  final txtEmail = TextEditingController();
  final txtSenha = TextEditingController();

  bool _aceitar = false;

  bool get aceitar => _aceitar;

  void atualizarAceitar(bool novoValor) {
    _aceitar = novoValor;
    notifyListeners();
  }

  static final Set<String> _emailsCadastrados = {
    'usuario@exemplo.com',
    'usuario2@dominio.com',
  };

  static final Map<String, String> _credenciais = {
    'usuario@exemplo.com': '123456',
    'usuario2@dominio.com': 'senha123',
  };

  static final Map<String, String> _nomesPorEmail = {
    'usuario@exemplo.com': 'Usuário Exemplo',
    'usuario2@dominio.com': 'Outro Usuário',
  };

  String? _usuarioLogadoEmail;

  String get usuarioLogadoEmail => _usuarioLogadoEmail ?? '';
  String get usuarioLogadoNome =>
      _usuarioLogadoEmail == null ? '' : _nomesPorEmail[_usuarioLogadoEmail] ?? '';

  bool registrarCredenciais(String email, String senha, String nome) {
    final normalized = email.trim().toLowerCase();
    if (normalized.isEmpty || senha.trim().isEmpty || nome.trim().isEmpty) {
      return false;
    }
    _emailsCadastrados.add(normalized);
    _credenciais[normalized] = senha.trim();
    _nomesPorEmail[normalized] = nome.trim();
    return true;
  }

  bool isEmailCadastrado(String email) {
    final normalized = email.trim().toLowerCase();
    return _emailsCadastrados.contains(normalized);
  }

  bool verificarLogin(String email, String senha) {
    final normalized = email.trim().toLowerCase();
    return _credenciais[normalized] == senha.trim();
  }

  void definirUsuarioLogado(String email) {
    _usuarioLogadoEmail = email.trim().toLowerCase();
    notifyListeners();
  }
}