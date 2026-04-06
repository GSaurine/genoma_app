import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'pages/splashPage.dart';
import 'pages/loginPage.dart';
import 'pages/homePage.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Carrega variáveis de ambiente do arquivo .env (se existir)
  await dotenv.load(fileName: '.env');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Genoma App',
      theme: ThemeData(primarySwatch: Colors.blue),
      debugShowCheckedModeBanner: false,
      locale: const Locale('pt', 'BR'),
      initialRoute: '/',
      routes: {
        '/': (context) => const Splashpage(),
        '/login': (context) => const LoginPage(),
        '/home': (context) => const Homepage(),
      },
    );
  }
}