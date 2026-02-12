import 'package:flutter/material.dart';
import 'package:flutter_frontend/core/transitions.dart';
import 'package:flutter_frontend/features/auth/presentation/signup_page.dart';
// import 'demo.dart'; 


class MoodLensSplashScreen extends StatefulWidget {
  const MoodLensSplashScreen({super.key});

  @override
  State<MoodLensSplashScreen> createState() => _MoodLensSplashScreenState();
}
class _MoodLensSplashScreenState extends State<MoodLensSplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200), // Timing for the bounce
    );

    // Using bounceOut makes it drop/spring and then stay at 1.0
    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.bounceOut, // This creates the "Bounce and Stay" effect
      ),
    );

    _controller.forward().then((_) {
      // Stay on screen for 3 seconds after bouncing before moving to Home
      Future.delayed(const Duration(milliseconds: 3000), () {
        if (mounted) {
          Navigator.of(context).pushReplacement(
            SlideUpRoute(page: const SignupPage())
            // MaterialPageRoute(builder: (context) => const MoodLensDemo()),
          );
        }
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      backgroundColor: const Color.fromARGB(255, 179, 251, 251),
      body: Center(
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                'assets/images/moodlens_logo.png',
                width: 300,
                height: 300,
              ),
            ],
          ),
        ),
      ),
    );
  }
}