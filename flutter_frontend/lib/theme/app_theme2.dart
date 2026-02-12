import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';

class Palette {
  // Brand Tones
  static const Color primarySage = Color(0xFF7DA081);
  static const Color accentCoral = Color(0xFFE99787);
  static const Color darkCoral = Color.fromARGB(255, 246, 101, 93);
  static const Color deepTeal = Color(0xFF2C5F5D);
  static const Color lightTeal = Color.fromARGB(255, 67, 145, 142);
  static const Color pastelPurplePrimary = Color(0xFFD1C4E9); // Soft Lavender
  static const Color pastelPurpleSecondary = Color(0xFFB39DDB); // Slightly deeper
  static const Color pastelPurpleAccent = Color(0xFFE1BEE7); // Pinkish Purple
  

  // The "Sweet Spot" Off-White
  static const Color ivoryBackground = Color(0xFFF5F5F3);
  
  // Use pure white for the "Surface" (Cards, Buttons, etc.)
  static const Color surfaceWhite = Color(0xFFFFFFFF);

  
  // Background & Splash Colors
  // Use a "Bone" or "Off-white" for light mode to reduce eye strain
  static const Color lightBackground = Color(0xFFF9F7F2); 
  // Use a "Deep Charcoal Blue" for dark mode (not pure black)
  static const Color darkBackground = Color(0xFF1A1C1E);

  // Neutral Tones for Borders and Backgrounds
  static const Color lightGrey = Color(0xFFF2F2F2);
  static const Color darkGrey = Color(0xFF2C2C2C);
  static const Color medGrey = Color.fromARGB(255, 143, 143, 143);

  // Expanded Emotion Palette
  static const Color joy = Color(0xFFFFD166);      // Warm Yellow
  static const Color calm = Color(0xFFB8E1DD);     // Soft Mint
  static const Color sadness = Color(0xFF5DADE2);  // Sky Blue
  static const Color anger = Color(0xFFE74C3C);    // Soft Red
  static const Color anxiety = Color(0xFFA569BD);  // Muted Purple
  static const Color focus = Color(0xFF2E86C1);    // Deep Ocean Blue
  static const Color neutral = Color(0xFFD5DBDB);  // Soft Grey

  // Semantic Colors
  static const Color success = Color(0xFF52BE80);
  static const Color error = Color(0xFFC0392B);
  static const Color warning = Color(0xFFF39C12);
}

class AppGradients {
  // Use these for background "Mood Auras" or cards
  static const LinearGradient joyGradient = LinearGradient(
    colors: [Color(0xFFFFF9C4), Palette.joy],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient calmGradient = LinearGradient(
    colors: [Color(0xFFE0F2F1), Palette.calm],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // A "Mindful" subtle background gradient
  static const LinearGradient mainBG = LinearGradient(
    colors: [Color(0xFFFDFCFB), Color(0xFFE2D1C3)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient purpleMist = LinearGradient(
    colors: [
      Color(0xFFF3E5F5), // Extremely light lavender
      Color(0xFFD1C4E9), // Classic pastel purple
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient twilightCalm = LinearGradient(
    colors: [
      Color(0xFFE1BEE7), // Soft purple/pink
      Color(0xFFB39DDB), // Deep pastel purple
    ],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient mindfulLavender = LinearGradient(
    colors: [
      Color(0xFFFAFAFE), // Almost white with a purple hint
      Color(0xFFEDE7F6), // Subtle lavender gray
    ],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );


  static const LinearGradient moodLensGradient = LinearGradient(
    colors: [
      Color(0xFFFDFCFB),       // Off-White (Top)
      Color(0xFFD1C4E9),       // pastelPurplePrimary
      Color(0xFF43918E),       // lightTeal
      // Color(0xFF2C5F5D),       // deepTeal (Bottom)
      Color(0xFFD1C4E9),       // pastelPurplePrimary
      Color(0xFFFDFCFB),       // Off-White (Top)

    ],
    stops: [0.0, 0.25, 0.5, 0.75,1.0], // Controls where each color starts
    begin: Alignment.topRight,
    end: Alignment.bottomLeft,
  );

  static const LinearGradient silkAurora = LinearGradient(
    colors: [
      Color(0xFF8E99F3), // Periwinkle (Bridge between purple and teal)
      Color(0xFFD1C4E9), // Your pastelPurplePrimary
      Color(0xFF43918E), // Your lightTeal
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient deepSilkText = LinearGradient(
    colors: [
      Color(0xFF2C5F5D), // Deepened Teal (for sharp edges)
      Color(0xFF5E35B1), // Deepened Purple (for richness)
      Color(0xFF3949AB), // Indigo Blue (to maintain the aurora glow)
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient fusionGradient = LinearGradient(
    colors: [
      Color(0xFFFAF9F6),       // Soft Off-White
      Color(0xFFB39DDB),       // pastelPurpleSecondary
      Color(0xFF2C5F5D),       // deepTeal
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient etherealGradient = LinearGradient(
  colors: [
    Color(0xFFFFFFFF),       // Pure White
    Color(0xFFF3E5F5),       // Very Light Lavender (Purple Tint)
    Color(0xFFE0F2F1),       // Very Light Mint (Teal Tint)
    Color(0xFFB2DFDB),       // Soft Light Teal
  ],
  begin: Alignment.topCenter,
  end: Alignment.bottomCenter,
);

static const LinearGradient softGlowGradient = LinearGradient(
    colors: [
      Color(0xFFFDFCFB),       // Off-White
      Color(0xFFE1BEE7),       // Lightened Purple
      Color(0xFF80CBC4),       // Muted Light Teal
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient buttonSageCoral = LinearGradient(
    colors: [
      Color.fromARGB(255, 168, 210, 173), // primarySage
      Color(0xFFE99787), // accentCoral
    ],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );
}




class AppTheme {
  // I recommend using the "Mandael" or "GreyLaw" built-in Flex schemes 
  // and overriding them with your Palette for a "Zen" look.
  static ThemeData light = FlexThemeData.light(
    scheme: FlexScheme.mandyRed, 
    primary: Palette.primarySage,
    secondary: Palette.accentCoral,
    scaffoldBackground: Palette.lightBackground,
    surfaceMode: FlexSurfaceMode.levelSurfacesLowScaffold,
    blendLevel: 7,
    subThemesData: const FlexSubThemesData(
      blendOnLevel: 10,
      useMaterial3Typography: true,
      inputDecoratorBorderType: FlexInputBorderType.outline,
      inputDecoratorRadius: 16.0, // Softer, rounder feel for mindfulness
      elevatedButtonRadius: 20.0,
      chipRadius: 10.0,
    ),
    visualDensity: FlexColorScheme.comfortablePlatformDensity,
    useMaterial3: true,
  );

  static ThemeData dark = FlexThemeData.dark(
    scheme: FlexScheme.mandyRed,
    primary: Palette.primarySage,
    secondary: Palette.accentCoral,
    scaffoldBackground: Palette.darkBackground,
    surfaceMode: FlexSurfaceMode.levelSurfacesLowScaffold,
    blendLevel: 13,
    subThemesData: const FlexSubThemesData(
      blendOnLevel: 20,
      useMaterial3Typography: true,
      inputDecoratorBorderType: FlexInputBorderType.outline,
      inputDecoratorRadius: 16.0,
      elevatedButtonRadius: 20.0,
    ),
    visualDensity: FlexColorScheme.comfortablePlatformDensity,
    useMaterial3: true,
  );
}




/*

import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';

class Palette {
  // Brand Colors - Earthy, Mindful Tones
  static const Color primarySage = Color(0xFF7DA081);
  static const Color accentCoral = Color(0xFFE99787);
  static const Color deepTeal = Color(0xFF2C5F5D);

  // Emotion Specific Colors (for borders/icons)
  static const Color joy = Color(0xFFFFD166);
  static const Color calm = Color(0xFFB8E1DD);
  static const Color sadness = Color(0xFF5DADE2);
  static const Color anger = Color(0xFFE74C3C);

  // Neutral Tones for Borders and Backgrounds
  static const Color lightGrey = Color(0xFFF2F2F2);
  static const Color darkGrey = Color(0xFF2C2C2C);
}

class AppTheme {
  // Light Theme Definition
  static ThemeData light = FlexThemeData.light(
    colors: const FlexSchemeColor(
      primary: Palette.primarySage,
      primaryContainer: Color(0xFFD4E7D7),
      secondary: Palette.accentCoral,
      secondaryContainer: Color(0xFFFFDAD4),
      tertiary: Palette.deepTeal,
      appBarColor: Palette.accentCoral,
    ),
    surfaceMode: FlexSurfaceMode.levelSurfacesLowScaffold,
    blendLevel: 7,
    subThemesData: const FlexSubThemesData(
      blendOnLevel: 10,
      blendOnColors: false,
      useTextTheme: true,
      useM2StyleDividerInM3: true,
      // Customizing Borders & Buttons
      inputDecoratorRadius: 12.0,
      inputDecoratorUnfocusedBorderIsColored: false,
      inputDecoratorFocusedBorderWidth: 2.0,
      elevatedButtonRadius: 10.0,
    ),
    visualDensity: FlexColorScheme.comfortablePlatformDensity,
    useMaterial3: true,
  );

  // Dark Theme Definition
  static ThemeData dark = FlexThemeData.dark(
    colors: const FlexSchemeColor(
      primary: Palette.primarySage,
      primaryContainer: Color(0xFF3B4D3D),
      secondary: Palette.accentCoral,
      secondaryContainer: Color(0xFF6E3A32),
      tertiary: Palette.deepTeal,
    ),
    surfaceMode: FlexSurfaceMode.levelSurfacesLowScaffold,
    blendLevel: 13,
    subThemesData: const FlexSubThemesData(
      blendOnLevel: 20,
      useTextTheme: true,
      inputDecoratorRadius: 12.0,
      inputDecoratorFocusedBorderWidth: 2.0,
      elevatedButtonRadius: 10.0,
    ),
    visualDensity: FlexColorScheme.comfortablePlatformDensity,
    useMaterial3: true,
  );
}


 */