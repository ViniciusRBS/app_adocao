import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme_provider.dart';
import 'editar_perfil_page.dart';
import 'alterar_senha_page.dart';

class ConfiguracoesPage extends StatelessWidget {
  const ConfiguracoesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Configurações'),
        backgroundColor: const Color(0xFFFFA726),
      ),
      body: ListView(
        children: [
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text('Conta', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ),
          ListTile(
            leading: const Icon(Icons.edit),
            title: const Text('Editar perfil'),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const EditarPerfilPage()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.lock),
            title: const Text('Alterar senha'),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const AlterarSenhaPage()));
            },
          ),
          const Divider(),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text('Preferências', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ),
          SwitchListTile(
            title: const Text('Tema escuro'),
            value: themeProvider.isDarkMode,
            onChanged: (value) => themeProvider.toggleTheme(value),
            secondary: const Icon(Icons.brightness_6),
          ),
        ],
      ),
    );
  }
}
