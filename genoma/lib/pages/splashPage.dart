import 'package:flutter/material.dart';
import 'package:genoma/core/config/dioConfig.dart';
import 'package:genoma/services/auth_facade.dart';

class Splashpage extends StatefulWidget {
  const Splashpage({super.key});

  @override
  State<Splashpage> createState() => _SplashpageState();
}

class _SplashpageState extends State<Splashpage> {
  @override
  void initState() {
    super.initState();
    _checkAuth();
  }

  Future<void> _checkAuth() async {
    await Future.delayed(const Duration(milliseconds: 500));
    if (!mounted) return;

    var route = '/login';
    try {
      final ok = await AuthFacade().initializeFromSavedToken();
      if (ok) {
        if (AuthFacade().isAdmin) {
          route = '/admin';
        } else if (AuthFacade().isMedico) {
          route = '/medico-home';
        } else {
          route = '/home';
        }
      }
    } catch (e, st) {
      debugPrint('Splash _checkAuth error: $e\n$st');
      route = '/login';
    }

    if (!mounted) return;
    Navigator.pushReplacementNamed(context, route);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.science_outlined,
              size: 100,
              color: Theme.of(context).primaryColor,
            ),
            const SizedBox(height: 24),
            const Text(
              'Genoma',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.black,
                letterSpacing: 2,
              ),
            ),
            const SizedBox(height: 60),
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
              strokeWidth: 3,
            ),
          ],
        ),
      ),
    );
  }
}
