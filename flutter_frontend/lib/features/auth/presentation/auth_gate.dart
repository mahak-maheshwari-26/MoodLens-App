import 'package:flutter/material.dart';
import 'package:flutter_frontend/features/auth/presentation/profile_setup_page.dart';
import 'package:flutter_frontend/features/auth/presentation/signin_page.dart';
import 'package:flutter_frontend/features/auth/providers/auth_provider.dart';
import 'package:flutter_frontend/features/dashboard/presentation/dashboard_screen.dart';
import 'package:flutter_frontend/theme/app_theme.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthGate extends ConsumerWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    debugPrint("AUTH GATE: Current State is $authState");

    return authState.when(
      data: (token) {
        // 1. If no token, user MUST sign in
        if (token == null || token.isEmpty) {
          FlutterNativeSplash.remove();
          return const SigninPage();
        }

        // 2. User has token, now check profile
        final profileState = ref.watch(userProfileProvider);

        return profileState.when(
          loading: () => const LoadingScreen(),
          error: (error, stack) {
            FlutterNativeSplash.remove();
            // If profile is not found (404/400), it's a new user
            final err = error.toString().toLowerCase();
            if (err.contains("404") || err.contains("400") || err.contains("not found")) {
              return const ProfileSetupPage();
            }
            // Generic error: show a button to retry or logout
            return Scaffold(
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Error loading profile: $error"),
                    TextButton(onPressed: () => ref.read(authProvider.notifier).logout(), child: const Text("Logout"))
                  ],
                ),
              ),
            );
          },
          data: (profile) {
            FlutterNativeSplash.remove();
            // 3. Logic: Does the profile indicate a new user?
            if (profile.fullName == "New User" ||profile.fullName.isEmpty) {
              debugPrint("If condition in auth Gate (data: profile) Current Profile: ${profile.fullName}");
              return const ProfileSetupPage();
            } else {
              debugPrint("Else condition in auth Gate (data: profile) Current Profile: ${profile.fullName}");
              return const MainDashboard();
            }
          },
        );
      },
      loading: () => const LoadingScreen(),
      error: (error, stack) => const SigninPage(), // Fallback on error
    );
  }
}

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Palette.iceWhite,
      body: Center(
        child: CircularProgressIndicator(color: Palette.indigoPrimary),
      ),
    );
  }
}