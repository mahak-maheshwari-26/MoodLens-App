import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';

class Palette {
  static const Color indigoPrimary = Color(0xFF4F46E5);
  static const Color violetAccent = Color(0xFF7C3AED);
  static const Color cyanGlow = Color(0xFF06B6D4);
  static const Color iceWhite = Color(0xFFF8FAFC);
  static const Color deepSpace = Color(0xFF0F172A);
  static const Color surfaceGlass = Color(0xFFFFFFFF);
  static const Color slateHeading = Color(0xFF1E293B);
  static const Color bodyGrey = Color(0xFF475569);

  // Emotion Palette for Charts/Stats
  static const Color joy = Color(0xFFFBBF24);
  static const Color calm = Color(0xFF34D399);
  static const Color sadness = Color(0xFF60A5FA);
  static const Color anger = Color(0xFFFB7185);

  static const Color error = Colors.red;

}

class AppGradients {
  static const LinearGradient electricAurora = LinearGradient(
    colors: [Palette.indigoPrimary, Palette.violetAccent, Palette.cyanGlow],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient etherealBackground = LinearGradient(
  colors: [
    Palette.iceWhite,
    Color.fromARGB(255, 239, 239, 223),
    Color.fromARGB(255, 199, 211, 249),
    Color.fromARGB(255, 245, 212, 233),
    Color.fromARGB(255, 136, 218, 224), 
  ],
  begin: Alignment.topRight,
  end: Alignment.bottomLeft,
);

}

class AppTheme {
  static ThemeData light = FlexThemeData.light(
    scheme: FlexScheme.indigo,
    primary: Palette.indigoPrimary,
    secondary: Palette.cyanGlow,
    tertiary: Palette.violetAccent,
    scaffoldBackground: Palette.iceWhite,
    surfaceMode: FlexSurfaceMode.level,
    blendLevel: 0,
    subThemesData: const FlexSubThemesData(
      inputDecoratorBorderType: FlexInputBorderType.outline,
      inputDecoratorRadius: 12.0,
      elevatedButtonRadius: 12.0,
      cardRadius: 20.0,
      cardElevation: 2.0,
    ),
    useMaterial3: true,
  );
}