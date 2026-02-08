import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class splashScreen extends StatelessWidget {
  const splashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child : Animate(
          delay: Duration(seconds: 2),
          effects: [
            
          ],
          child: Image.asset("images/moodlens_logo.png"),

          ),
      ),
    );
  }
}