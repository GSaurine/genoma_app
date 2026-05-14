import 'package:flutter/material.dart';
import '../pages/homePage.dart';
import '../pages/loginPage.dart';
import '../pages/loginPacientePage.dart';
import '../pages/splashPage.dart';
import '../pages/admin_home.dart';
import '../pages/medico_home.dart';
import '../pages/pacientes_page.dart';
import '../pages/paciente_portal_page.dart';

class AppRouter {
  static const String splashRoute = '/';
  static const String loginRoute = '/login';
  static const String loginPacienteRoute = '/login-paciente';
  static const String homeRoute = '/home';
  static const String adminRoute = '/admin';
  static const String medicoRoute = '/medico-home';
  static const String pacientesRoute = '/pacientes';
  static const String pacientePortalRoute = '/paciente-portal';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splashRoute:
        return MaterialPageRoute(builder: (_) => const Splashpage());
      case loginRoute:
        return MaterialPageRoute(builder: (_) => const LoginPage());
      case loginPacienteRoute:
        return MaterialPageRoute(builder: (_) => const LoginPacientePage());
      case homeRoute:
        return MaterialPageRoute(builder: (_) => const Homepage());
      case adminRoute:
        return MaterialPageRoute(builder: (_) => const AdminHome());
      case medicoRoute:
        return MaterialPageRoute(builder: (_) => const MedicoHome());
      case pacientesRoute:
        return MaterialPageRoute(builder: (_) => const PacientesPage());
      case pacientePortalRoute:
        return MaterialPageRoute(builder: (_) => const PacientePortalPage());
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('Nenhuma rota definida para ${settings.name}')),
          ),
        );
    }
  }
}
