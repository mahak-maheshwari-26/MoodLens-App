import 'package:flutter/material.dart';
import 'package:flutter_frontend/features/auth/presentation/profile_setup_page.dart';
import 'package:flutter_frontend/features/auth/presentation/signin_page.dart';
import 'package:flutter_frontend/features/dashboard/presentation/dashboard_screen.dart.dart';
import 'package:flutter_frontend/theme/app_theme.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/auth_provider.dart';

class AuthGate extends ConsumerWidget{

  const AuthGate({super.key});

  @override
  Widget build(BuildContext context , WidgetRef ref) {

    // Watch the auth provider
    // When state changes from null to a token , re-run this 
    final authState = ref.watch(authProvider);


    return authState.when(
      data : (token) {
        // remove splash screen
        // FlutterNativeSplash.remove();

        // if (token != null && token.isNotEmpty){
        //   return const ProfileSetupPage();
        // } else{
        //   return const SigninPage(); //Show login page if no token
        // }

        if (token == null || token.isEmpty){
          FlutterNativeSplash.remove();
          return const SigninPage(); //Show login page if no token
        }

        final profileState = ref.watch(userProfileProvider);

        return profileState.when(
          data : (profile){
            FlutterNativeSplash.remove();

            if (profile.fullName == "New User"){
              return const ProfileSetupPage();
            } else{
              return const MainDashboard(); 
            }
          },
          loading: () => const LoadingScreen(),
          error: (error,stack) {
            FlutterNativeSplash.remove();
            final err = error.toString().toLowerCase();
          if (err.contains("404") || err.contains("not found") || err.contains("400")) {
            return const ProfileSetupPage();
          }
            return Scaffold(
              body: Center(child: Text("Error fetching profile : $error"),),);
          }
        );


      },

      loading: () => const LoadingScreen(),
      error: (error, stack) {
        FlutterNativeSplash.remove();
        return authState.maybeWhen(
          data: (token) => const SigninPage(),
          orElse: () => const SigninPage(),
        );
      },
      // skipError : true,
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