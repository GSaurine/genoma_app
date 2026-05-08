import 'package:flutter/material.dart';
import 'package:genoma/services/auth_facade.dart';
import 'package:genoma/core/ui/notification_service.dart';

class LoginPacientePage extends StatefulWidget {
  const LoginPacientePage({super.key});

  @override
  State<LoginPacientePage> createState() => _LoginPacientePageState();
}

class _LoginPacientePageState extends State<LoginPacientePage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _loading = false;

  Future<void> _login() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      NotificationService().showError('Por favor, preencha todos os campos.');
      return;
    }

    setState(() => _loading = true);
    try {
      await AuthFacade().loginPaciente(email, password);
      if (!mounted) return;

      // Pacientes vão para a home por enquanto ou uma página específica de resultados
      Navigator.pushReplacementNamed(context, '/home');
    } catch (e) {
      if (mounted) {
        NotificationService().showError('Erro ao efetuar login: ${e.toString()}');
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: const Text('Login do Paciente')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 60),
              Icon(Icons.person_outline, size: 100, color: Theme.of(context).primaryColor),
              const SizedBox(height: 20),
              const Text(
                'Acesso para Pacientes',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 40),
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'E-mail',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.email),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _passwordController,
                decoration: const InputDecoration(
                  labelText: 'Senha',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.lock),
                ),
                obscureText: true,
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _loading ? null : _login,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green[700],
                    foregroundColor: Colors.white,
                  ),
                  child: _loading
                      ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                      : const Text('Entrar como Paciente', style: TextStyle(fontSize: 16)),
                ),
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Voltar para Login Geral'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
