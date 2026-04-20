import 'package:flutter/material.dart';
import '../pages/homePage.dart';
import '../pages/loginPage.dart';
import '../pages/splashPage.dart';
import '../pages/admin_home.dart';

class AppRouter {
  static const String splashRoute = '/';
  static const String loginRoute = '/login';
  static const String homeRoute = '/home';
  static const String adminRoute = '/admin';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splashRoute:
        return MaterialPageRoute(builder: (_) => const Splashpage());
      case loginRoute:
        return MaterialPageRoute(builder: (_) => const LoginPage());
      case homeRoute:
        return MaterialPageRoute(builder: (_) => const Homepage());
      case adminRoute:
        return MaterialPageRoute(builder: (_) => const AdminHome());
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('Nenhuma rota definida para ${settings.name}')),
          ),
        );
    }
  }
}
