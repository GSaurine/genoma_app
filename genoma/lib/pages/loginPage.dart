import 'package:flutter/material.dart';
import 'package:genoma/services/auth_facade.dart';
import 'package:genoma/core/config/dioConfig.dart';

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
    debugPrint('LoginPage.initState');
    _checkAlreadyAuthenticated();
  }

  Future<void> _checkAlreadyAuthenticated() async {
    try {
      final initialized = await AuthFacade().initializeFromSavedToken();
      if (initialized && mounted) {
        final target = AuthFacade().isAdmin ? '/admin' : '/home';
        Navigator.pushReplacementNamed(context, target);
      }
    } catch (_) {}
  }

  Future<void> _login() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, preencha todos os campos.')),
      );
      return;
    }

    setState(() => _loading = true);
    try {
      await AuthFacade().login(email, password);
      if (!mounted) return;

      // Debug: log token, user and role to help diagnose post-login black screen
      final token = APIService().token;
      debugPrint('Auth login successful — token: $token');
      debugPrint('Auth currentUser: ${AuthFacade().currentUser}');
      debugPrint('Auth isAdmin: ${AuthFacade().isAdmin}');

      final isAdmin = AuthFacade().isAdmin;
      // Use microtask to avoid navigator during an unstable frame and catch navigation errors
      try {
        if (mounted) {
          if (isAdmin) {
            Future.microtask(() => Navigator.pushReplacementNamed(context, '/admin'));
          } else {
            Future.microtask(() => Navigator.pushReplacementNamed(context, '/home'));
          }
        }
      } catch (navErr, navSt) {
        debugPrint('Navigation error after login: $navErr\n$navSt');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Erro na navegação: ${navErr.toString()}')),
          );
        }
      }
    } catch (e, st) {
      debugPrint('Login error: $e\n$st');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao efetuar login: ${e.toString()}')),
        );
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('LoginPage.build');
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('LOGIN PAGE (debug)', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            // Logo da empresa (fallback para evitar crash se o asset não existir)
            Image.asset(
              'assets/logo.png',
              height: 100,
              errorBuilder: (context, error, stackTrace) {
                return Icon(Icons.science_outlined, size: 100, color: Theme.of(context).primaryColor);
              },
            ),
            const SizedBox(height: 20),

            // Campos de e-mail e senha
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'E-mail'),
            ),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Senha'),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _loading ? null : _login,
              child: _loading
                  ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                  : const Text('Entrar'),
            ),
          ],
        ),
      ),
    );
  }
}
