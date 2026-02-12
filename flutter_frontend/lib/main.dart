import 'package:flutter/material.dart';
import 'package:flutter_frontend/features/auth/presentation/auth_gate.dart';
// import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'features/auth/presentation/signup_page.dart';
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
      // darkTheme: AppTheme.dark,
      debugShowCheckedModeBanner: false,
      // themeMode: ThemeMode.system,
      home: const AuthGate(),
    );
  }
}


