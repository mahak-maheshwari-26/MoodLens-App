import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

class AuthTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final IconData icon;
  final bool isPassword;
  final String? Function(String?)? validator;
  final TextInputType keyboardType;

  const AuthTextField({
    super.key,
    required this.controller,
    required this.label,
    required this.icon,
    this.isPassword = false,
    this.validator, 
    this.keyboardType = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {

    // final theme = Theme.of(context);

    return TextFormField( 
      controller: controller,
      obscureText: isPassword,
      validator: validator, 
      keyboardType: keyboardType,
      style: TextStyle(
        fontSize: 18,
        color: Palette.deepSpace,
        fontWeight: FontWeight.w500,
      ),
   
      decoration: InputDecoration(
        filled: true,
        fillColor: Palette.iceWhite.withValues(alpha: 0.9),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        hoverColor: Palette.surfaceGlass.withValues(alpha:1),
        labelText: label,
        labelStyle: TextStyle(
          fontWeight: FontWeight.w500,
        ),
        floatingLabelStyle: TextStyle(
          color: Palette.indigoPrimary,
          fontWeight: FontWeight.bold,
          fontSize: 18
        ),

        prefixIcon: Icon(icon, 
        color: Palette.indigoPrimary
        ),
      ),
    );
  }
}


class AuthButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;

  const AuthButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
      gradient: AppGradients.electricAurora,
      borderRadius: BorderRadius.circular(20),
      boxShadow: [
        BoxShadow(
          color: Palette.indigoPrimary.withValues(alpha: 0.4),
          blurRadius: 12,
          offset: const Offset(0, 6),
        ),
      ],
      ),
      width: double.infinity,
      height: 60,

      child: ElevatedButton(
        
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
            
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            // side : BorderSide(color: Palette.darkGrey)
          ),
          elevation: 5,
        ),
        child: isLoading
            ? const SizedBox(
                height: 24,
                width: 24,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
            : Text(
                text,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 2
                ),
              ),
      ),
    );
  }
}


class GradientText extends StatelessWidget {
  final String text;
  final TextStyle style;
  final Gradient gradient;

  const GradientText(
    this.text, {
    super.key,
    required this.gradient,
    this.style = const TextStyle(),

  });

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      blendMode: BlendMode.srcIn, // This makes the gradient show only inside the text
      shaderCallback: (bounds) => gradient.createShader(
        Rect.fromLTWH(0, 0, bounds.width, bounds.height),
      ),
      child: Text(text, style: style),
    );
  }
}

class GlassCard extends StatelessWidget {
  final Widget child;
  const GlassCard({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Palette.surfaceGlass.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Palette.neutral.withValues(alpha: 0.1)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 30,
            offset: const Offset(0, 15),
          ),
        ],
      ),
      child: child,
    );
  }
/*
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer( 
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,

            decoration: BoxDecoration(
        color: Palette.surfaceGlass.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Palette.neutral.withValues(alpha: 0.1)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 30,
            offset: const Offset(0, 15),
          ),
        ],
      ),

      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: child,
      ),
    );
  }*/
}