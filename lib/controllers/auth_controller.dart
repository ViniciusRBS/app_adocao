import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthController {
  static ValueNotifier<bool> isLoggedIn = ValueNotifier(false);
  static String? userName;

  static Future<String?> login(String email, String senha) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: senha,
      );
      await _loadUserData();
      isLoggedIn.value = true;
      return null;
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  static Future<String?> register(String nome, String email, String senha) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: senha);

      String uid = userCredential.user!.uid;

      await FirebaseFirestore.instance.collection('usuarios').doc(uid).set({
        'nome': nome,
        'email': email,
        'criadoEm': FieldValue.serverTimestamp(),
      });

      // Não fazer login automaticamente após o cadastro
      return null;
    } on FirebaseAuthException catch (e) {
      print('Erro de autenticação: ${e.message}');
      return e.message;
    }
  }

  static Future<void> _loadUserData() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final doc = await FirebaseFirestore.instance
          .collection('usuarios')
          .doc(user.uid)
          .get();
      userName = doc.data()?['nome'] ?? 'Usuário';
    }
  }

  static void logout() {
    FirebaseAuth.instance.signOut();
    isLoggedIn.value = false;
    userName = null;
  }
}
