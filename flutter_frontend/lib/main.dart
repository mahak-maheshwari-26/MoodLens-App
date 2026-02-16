import 'package:flutter/material.dart';
import 'package:flutter_frontend/features/auth/presentation/auth_gate.dart';
import 'package:flutter_frontend/features/auth/providers/auth_provider.dart';
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
      home: Consumer(
        builder: (context,ref,child){
          final authKey = ref.watch(authProvider).value ?? 'logged-out';
          return AuthGate(key: ValueKey(authKey));
        }
        ),
      routes: {
        '/add-journal': (context) => const JournalEntryPage(),
        '/stats': (context) => const StatsPage(), 
      },
    );
  }
}


