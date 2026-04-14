import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'presentation/admin_login.dart';
import 'presentation/admin_dashboard.dart';

void main() async {
  // Ensure Flutter bindings are initialized before calling SharedPreferences
  WidgetsFlutterBinding.ensureInitialized();
  
  final prefs = await SharedPreferences.getInstance();
  final String? token = prefs.getString('admin_token');

  runApp(ProviderScope(
    child : MoodlensAdminApp(isLoggedIn: token != null))
  );
}

class MoodlensAdminApp extends StatelessWidget {
  final bool isLoggedIn;
  
  const MoodlensAdminApp({super.key, required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Moodlens Admin Portal',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
        // Card and Table styling for a clean Web Look
        cardTheme: const CardThemeData(elevation: 2),
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(),
          filled: true,
          fillColor: Colors.white,
        ),
      ),
      // If token exists, go to Dashboard, else go to Login
      home: isLoggedIn ? const AdminDashboardPage() : const AdminLogin(),
    );
  }
}