import 'package:controle_estoque/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'presentation/pages/dashboard.dart';
import 'presentation/pages/login_page.dart';
import 'presentation/pages/produto_page.dart';
import 'presentation/pages/register_page.dart';
import 'presentation/pages/solicitacao_page.dart';
import 'presentation/pages/usuario_page.dart';

void main() async {
  // Inicialize o FFI para o SQLite
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;

  // Inicialize o Firebase
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Controle de Estoque',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const LoginPage(),
        '/dashboard': (context) => const DashboardPage(),
        '/solicitacoes': (context) => const SolicitacaoPage(),
        '/usuarios': (context) => const UsuarioPage(),
        '/registro': (context) => const RegisterPage(),
        '/produtos': (context) => const ProdutoPage(),
      },
    );
  }
}
