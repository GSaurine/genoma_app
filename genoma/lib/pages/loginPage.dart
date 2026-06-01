import 'package:flutter/material.dart';
import 'package:genoma/services/auth_facade.dart';
import 'package:genoma/core/ui/notification_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _checkAlreadyAuthenticated();
  }

  Future<void> _checkAlreadyAuthenticated() async {
    try {
      final initialized = await AuthFacade().initializeFromSavedToken();
      if (initialized && mounted) {
        String target = '/home';
        if (AuthFacade().isAdmin) {
          target = '/admin';
        } else if (AuthFacade().isMedico) {
          target = '/medico-home';
        }
        Navigator.pushReplacementNamed(context, target);
      }
    } catch (_) {}
  }

  Future<void> _login() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      NotificationService().showError('Por favor, preencha todos os campos.');
      return;
    }

    setState(() => _loading = true);
    try {
      await AuthFacade().login(email, password);
      if (!mounted) return;

      final isAdmin = AuthFacade().isAdmin;
      final isMedico = AuthFacade().isMedico;
      
      String target = '/home';
      if (isAdmin) {
        target = '/admin';
      } else if (isMedico) {
        target = '/medico-home';
      }

      debugPrint('Login sucess: target=$target, isMedico=$isMedico, isAdmin=$isAdmin');
      Navigator.pushReplacementNamed(context, target);
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
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 60),
              Image.asset(
                'assets/logo.png',
                height: 120,
                errorBuilder: (context, error, stackTrace) {
                  return Icon(Icons.science_outlined, size: 100, color: Theme.of(context).primaryColor);
                },
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
                  child: _loading
                      ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2))
                      : const Text('Entrar', style: TextStyle(fontSize: 16)),
                ),
              ),
              const SizedBox(height: 16),
              const Text('OU', style: TextStyle(color: Colors.grey)),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: OutlinedButton.icon(
                  onPressed: () => Navigator.pushNamed(context, '/login-paciente'),
                  icon: const Icon(Icons.person_search),
                  label: const Text('Sou Paciente / Consultar Resultados'),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: Theme.of(context).primaryColor),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
