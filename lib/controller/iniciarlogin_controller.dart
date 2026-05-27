import 'package:flutter/material.dart';

class IniciarloginController extends ChangeNotifier {
  bool _aceitar = false;

  bool get aceitar => _aceitar;

  void atualizarAceitar(bool novoValor) {
    _aceitar = novoValor;
    notifyListeners();
  }

  String? _usuarioLogadoEmail;
  String? _usuarioLogadoNome;

  String get usuarioLogadoEmail => _usuarioLogadoEmail ?? '';
  String get usuarioLogadoNome => _usuarioLogadoNome ?? '';

  void definirUsuarioLogado(String email, [String? nome]) {
    _usuarioLogadoEmail = email.trim().toLowerCase();
    _usuarioLogadoNome = nome?.trim() ?? '';
    notifyListeners();
  }

  void limparUsuarioLogado() {
    _usuarioLogadoEmail = null;
    _usuarioLogadoNome = null;
    notifyListeners();
  }

  bool get estaLogado => _usuarioLogadoEmail != null && _usuarioLogadoEmail!.isNotEmpty;
}