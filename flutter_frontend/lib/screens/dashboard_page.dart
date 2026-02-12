import 'package:flutter/material.dart';
import 'package:flutter_frontend/features/auth/providers/auth_provider.dart';
import 'package:flutter_frontend/theme/app_theme.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart' as intl;

class DashboardPage extends ConsumerWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the profile to get the name
    final profileAsync = ref.watch(userProfileProvider);

    return Scaffold(
      backgroundColor: Palette.iceWhite,
      persistentFooterAlignment: AlignmentDirectional(0.5, 0.5),
      persistentFooterDecoration: BoxDecoration(
        gradient: AppGradients.glassGradient,
        boxShadow: [BoxShadow(
          color: Palette.indigoPrimary.withValues(alpha: .2),
          blurRadius: 10,
          offset: const Offset(0, -5),
        )]
      ),
      persistentFooterButtons: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,

          children: [
            IconButton.outlined(onPressed: () {}, icon: const Icon(Icons.settings)),
            IconButton.outlined(onPressed: () {}, icon: const Icon(Icons.settings)),
            IconButton.outlined(onPressed: () {}, icon: const Icon(Icons.settings)),
            IconButton.outlined(onPressed: () {}, icon: const Icon(Icons.settings)),
            IconButton.outlined(onPressed: () {}, icon: const Icon(Icons.settings)),
          ],
        ),

      ],
      appBar: AppBar(
        leading: IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {},
            // onPressed: () => ref.read(authProvider.notifier).logout(),
          ),
        title: Text("Today ${intl.DateFormat("MMMM d").format(DateTime.now())}"),
        // actions: [
        //   IconButton(
        //     icon: const Icon(Icons.logout),
        //     onPressed: () => ref.read(authProvider.notifier).logout(),
        //   )
        // ],
        
      ),
      body: profileAsync.when(
        data: (profile) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Hello, ${profile.fullName}! \nEmail : ${profile.email}", 
                   textAlign: TextAlign.center,
                   style: TextStyle(
                    color: Palette.indigoPrimary,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                   )),
              const SizedBox(height: 10),
              const Text("Ready to track your mood today?"),
            ],
          ),
        ),
        loading: () => const CircularProgressIndicator(),
        error: (err, _) => Text("Error loading profile: $err"),
      ),
    );
  }
}