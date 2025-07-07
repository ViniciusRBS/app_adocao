import 'package:flutter/material.dart';
import '../controllers/auth_controller.dart';
import 'home_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _senhaController = TextEditingController();

  bool isLogin = true;
  bool _isLoading = false;
  String message = '';

  void _submit() async {
    String nome = _nomeController.text.trim();
    String email = _emailController.text.trim();
    String senha = _senhaController.text;

    if (email.isEmpty || senha.isEmpty || (!isLogin && nome.isEmpty)) {
      setState(() {
        message = 'Preencha todos os campos.';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      message = '';
    });

    String? resultado;
    if (isLogin) {
      resultado = await AuthController.login(email, senha);
    } else {
      resultado = await AuthController.register(nome, email, senha);
    }

    setState(() {
      _isLoading = false;
    });
    FocusScope.of(context).unfocus();

    if (resultado == null) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const HomePage()),
      );
    } else {
      setState(() {
        message = resultado!;
      });
    }
  }

  void _toggleMode() {
    setState(() {
      isLogin = !isLogin;
      message = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isLogin ? 'Login' : 'Cadastro'),
        backgroundColor: Colors.green,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (!isLogin)
              TextField(
                controller: _nomeController,
                decoration: const InputDecoration(
                  labelText: 'Nome',
                  border: OutlineInputBorder(),
                ),
              ),
            if (!isLogin) const SizedBox(height: 16),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'E-mail',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _senhaController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Senha',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),
            _isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: _submit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                    ),
                    child: Text(isLogin ? 'Entrar' : 'Cadastrar'),
                  ),
            TextButton(
              onPressed: _isLoading ? null : _toggleMode,
              child: Text(isLogin
                  ? 'Não tem conta? Cadastre-se'
                  : 'Já tem conta? Fazer login'),
            ),
            const SizedBox(height: 16),
            Text(
              message,
              style: TextStyle(
                color: message.contains('sucesso') ? Colors.green : Colors.red,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
