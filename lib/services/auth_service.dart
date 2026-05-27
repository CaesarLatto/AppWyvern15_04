import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static const String _userCollection = 'usuarios';

  Future<UserCredential> signIn({required String email, required String password}) {
    // Firebase RF 001, Autenticação de Usuários: realiza signInWithEmailAndPassword no Firebase Auth
    return _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<UserCredential> signUp({
    required String nome,
    required String email,
    required String password,
  }) async {
    // Firebase RF 002, Registro de Usuários: cria credencial no Auth, atualiza displayName e salva perfil no Firestore
    final credential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    final user = credential.user;
    if (user == null) {
      throw FirebaseAuthException(
        code: 'user-not-created',
        message: 'Não foi possível criar o usuário.',
      );
    }

    await user.updateDisplayName(nome);
    await _saveUserProfile(user.uid, nome, email);
    return credential;
  }

  Future<void> sendPasswordResetEmail(String email) {
    return _auth.sendPasswordResetEmail(email: email);
  }

  Future<String?> fetchUserName(String uid) async {
    final snapshot = await _firestore.collection(_userCollection).doc(uid).get();
    if (!snapshot.exists) {
      return null;
    }
    return snapshot.data()?['nome'] as String?;
  }

  Future<void> _saveUserProfile(String uid, String nome, String email) {
    // Firebase RF 002, Registro de Usuários: grava documento em 'usuarios' com fields para busca e auditoria
    return _firestore.collection(_userCollection).doc(uid).set({
      'nome': nome,
      'email': email,
      'telefone': '',
      'criadoEm': FieldValue.serverTimestamp(),
    });
  }
}
