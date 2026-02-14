import 'package:flutter/material.dart';
import 'package:flutter_frontend/features/auth/presentation/auth_gate.dart';
import 'package:flutter_frontend/features/auth/presentation/signin_page.dart';
import 'package:flutter_frontend/features/auth/presentation/signup_page.dart';
import 'package:flutter_frontend/features/dashboard/presentation/dashboard_screen.dart.dart';
import 'package:flutter_frontend/features/dashboard/presentation/stats_page.dart';
import 'package:flutter_frontend/features/journal/presentation/journal_page.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'theme/app_theme2.dart';

void main() {
  // WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();

  // FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: AppTheme.light,      
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => const AuthGate(),
        '/add-journal': (context) => const JournalEntryPage(),
        '/stats': (context) => const StatsPage(), 
        '/login' : (context) => const SigninPage(),
        '/signup' : (context) => const SignupPage(),
        '/dashboard' : (context) => const MainDashboard(),
      },
    );
  }
}


