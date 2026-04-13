import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'pages/admin_home.dart';
import 'pages/homePage.dart';
import 'pages/loginPage.dart';
import 'pages/splashPage.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Não bloqueia o app se o arquivo .env não existir no artefato final.
  try {
    await dotenv.load(fileName: '.env');
  } catch (e) {
    debugPrint('Falha ao carregar .env: $e');
  }

  if (kDebugMode) {
    ErrorWidget.builder = (FlutterErrorDetails details) {
      return MaterialApp(
        home: Scaffold(
          appBar: AppBar(title: const Text('Erro em tempo de execução')),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Text(
              details.exceptionAsString(),
              style: const TextStyle(color: Colors.red),
            ),
          ),
        ),
      );
    };
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final startupRoute = WidgetsBinding.instance.platformDispatcher.defaultRouteName;
    final initialRoute = startupRoute.isNotEmpty ? startupRoute : '/';

    return MaterialApp(
      title: 'Genoma App',
      theme: ThemeData(primarySwatch: Colors.blue),
      debugShowCheckedModeBanner: false,
      locale: const Locale('pt', 'BR'),
      initialRoute: initialRoute,
      routes: {
        '/': (context) => const Splashpage(),
        '/login': (context) => const LoginPage(),
        '/home': (context) => const Homepage(),
        '/admin': (context) => const AdminHome(),
      },
    );
  }
}
