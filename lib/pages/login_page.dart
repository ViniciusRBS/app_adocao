import 'package:flutter/material.dart';
import '../controllers/auth_controller.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool isLogin = true; // alterna entre login e cadastro
  String message = '';

  // Dados mockados para simulação
  final Map<String, String> mockUsers = {
    'usuario': '123456',
  };

  void _loginOrRegister() {
    String username = _usernameController.text.trim();
    String password = _passwordController.text;

    if (username.isEmpty || password.isEmpty) {
      setState(() {
        message = 'Preencha todos os campos';
      });
      return;
    }

    if (isLogin) {
      // LOGIN
      if (mockUsers.containsKey(username) && mockUsers[username] == password) {
        setState(() {
          message = 'Login bem-sucedido!';
          AuthController.login(username: username);
          Navigator.pop(context); // Fecha a tela de login
        });
      } else {
        setState(() {
          message = 'Usuário ou senha inválidos';
        });
      }
    } else {
      // REGISTRO
      if (mockUsers.containsKey(username)) {
        setState(() {
          message = 'Usuário já existe';
        });
      } else {
        setState(() {
          mockUsers[username] = password;
          message = 'Cadastro realizado com sucesso!';
          isLogin = true;
        });
      }
    }
  }

  void _toggleMode() {
    setState(() {
      isLogin = !isLogin;
      message = '';
      _usernameController.clear();
      _passwordController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          isLogin 
            ? 'Login' 
            : 'Cadastro',
          style: const TextStyle(color: Colors.white, fontSize: 24),
        ),
        centerTitle: true,
        backgroundColor: Colors.green[400],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(
                labelText: 'Usuário',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Senha',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green[400],
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              onPressed: _loginOrRegister,
              child: Text(
                isLogin 
                  ? 'Entrar' 
                  : 'Cadastrar',
                style: const TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
            const SizedBox(height: 8),
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Colors.green[400],
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              onPressed: _toggleMode,
              child: Text(
                isLogin
                    ? 'Não tem conta? Cadastre-se'
                    : 'Já tem conta? Faça login',
                style: const TextStyle(fontSize: 16, color: Colors.green),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              message,
              style: TextStyle(
                color: message.contains('sucesso') ? Colors.green : Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}