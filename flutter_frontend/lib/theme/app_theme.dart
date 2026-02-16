import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';

class Palette {
  // --- CORE VIBRANT TONES ---
  static const Color indigoPrimary = Color(0xFF4F46E5); // Modern Tech Indigo
  static const Color violetAccent = Color(0xFF7C3AED); // Vibrant Purple
  static const Color cyanGlow = Color(0xFF06B6D4);    // Electric Cyan
  
  // --- FUNCTIONAL DASHBOARD COLORS ---
  // Use these for specific sections like "Resources", "Growth", or "Journaling"
  static const Color tealResource = Color(0xFF0D9488); // For Self-improvement cards
  static const Color brownEarth = Color(0xFF92400E);   // For Journaling/Reflection cards
  static const Color slateHeading = Color(0xFF1E293B); // For Headlines (almost black, but softer)
  static const Color bodyGrey = Color(0xFF475569);    // For regular text/body



  // --- BACKGROUNDS (High Contrast) ---
  static const Color iceWhite = Color(0xFFF8FAFC);    // Crisp, cold, clean
  static const Color deepSpace = Color(0xFF0F172A);   // Rich Midnight (Dark Mode)
  static const Color surfaceGlass = Color(0xFFFFFFFF); // Pure white for cards

  // --- SOFT CARD TINTS (Use for "For You" Card Backgrounds) ---
  // These prevent the "Indigo-only" look by providing soft variety
  static const Color cardIndigoTint = Color.fromARGB(255, 216, 225, 254); // Very Pale Indigo
  static const Color cardTealTint = Color.fromARGB(255, 206, 248, 238);   // Very Pale Teal
  static const Color cardBrownTint = Color.fromARGB(255, 234, 233, 214);  // Very Pale Sand/Brown
  static const Color cardGreyTint = Color.fromARGB(255, 210, 218, 227);   // Very Pale Slate
  static const Color cardPinkTint = Color.fromARGB(255, 255, 228, 242);   // Very Pale Slate
  static const Color cardOrangeTint = Color.fromARGB(255, 255, 226, 194);   // Very Pale Slate


  // --- EMOTION POP PALETTE (Vibrant version) ---
  static const Color joy = Color(0xFFFBBF24);      // Electric Amber
  static const Color calm = Color(0xFF34D399);     // Emerald Mint
  static const Color sadness = Color(0xFF60A5FA);  // Bright Blue
  static const Color anger = Color(0xFFFB7185);    // Rose Red
  static const Color fear = Color(0xFFA78BFA);  // Soft Lavender
  static const Color neutral = Color(0xFF94A3B8);  // Slate Grey
  static const Color disgust = Color(0xFF84CC16); // Lime Green
  static const Color shame = Color(0xFFD97706);   // Burnt Orange/Ochre
  static const Color guilt = Color(0xFF475569);   // Heavy Slate Grey

  // Neutral Tones for Borders and Backgrounds
  static const Color lightGrey = Color(0xFFF2F2F2);
  static const Color darkGrey = Color(0xFF2C2C2C);
  static const Color medGrey = Color.fromARGB(255, 143, 143, 143);


  // Semantic Colors
  static const Color success = Color(0xFF52BE80);
  static const Color error = Color(0xFFC0392B);
  static const Color warning = Color(0xFFF39C12);
  static const Color info = Color(0xFF2980B9);

}

class AppGradients {
  // THE MASTER BRAND GRADIENT (Use for Buttons & Logos)
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
  static const LinearGradient etherealBackground2 = LinearGradient(
  colors: [
    Palette.iceWhite,
    // Color(0xFFEEF2FF), // A very faint Indigo tint (Indigo-50)
    // Color(0xFFECFEFF), // A very faint Cyan tint (Cyan-50)

    Color(0xFFE0E7FF), // Indigo 100 (2 shades darker than 50)
    Color(0xFFCFFAFE), // Cyan 100 (2 shades darker than 50)
  ],
  begin: Alignment.topRight,
  end: Alignment.bottomLeft,
);

  static const LinearGradient indigoGradient = LinearGradient(
    colors: [
      Color(0xFF8E2DE2), // Almost white with a purple hint
      Color(0xFF4A00E0), // Subtle lavender gray
    ],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  // GLASS EFFECT GRADIENT (Use for subtle card backgrounds)
  static const LinearGradient glassGradient = LinearGradient(
    colors: [
      Color(0x33FFFFFF), // 20% White
      Color(0x0AFFFFFF), // 4% White
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // VIBRANT TEXT GRADIENT
  static const LinearGradient premiumText = LinearGradient(
    colors: [Palette.indigoPrimary, Palette.violetAccent],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
}

class AppTheme {
  static ThemeData light = FlexThemeData.light(
    scheme: FlexScheme.indigo,
    primary: Palette.indigoPrimary,
    secondary: Palette.cyanGlow,
    tertiary: Palette.violetAccent,
    scaffoldBackground: Palette.iceWhite,
    // surfaceMode: FlexSurfaceMode.levelSurfacesLowScaffold,
    surfaceMode: FlexSurfaceMode.level,

    // blendLevel: 4, // Keeps it clean and white
    // blendLevel: 0, // Set to 0 to keep backgrounds PURE and crisp
    blendLevel: 0,
    subThemesData: const FlexSubThemesData(
      useMaterial3Typography: true,
      blendOnLevel: 2,
      inputDecoratorBorderType: FlexInputBorderType.outline,

      inputDecoratorFocusedHasBorder: true,
      
      inputDecoratorBorderSchemeColor: SchemeColor.primary,
      inputDecoratorPrefixIconSchemeColor: SchemeColor.primary,

      inputDecoratorRadius: 20.0, 
      inputDecoratorFocusedBorderWidth: 2.0,
      elevatedButtonRadius: 16.0,
      elevatedButtonSchemeColor: SchemeColor.primary,
      cardRadius: 24.0,
      cardElevation: 0.5,
      splashType: FlexSplashType.inkSparkle,
    ),
    keyColors: const FlexKeyColors(
      useSecondary: true,
      useTertiary: true,
      keepPrimary: true
    ),
    visualDensity: FlexColorScheme.comfortablePlatformDensity,
    useMaterial3: true,
  );

  static ThemeData dark = FlexThemeData.dark(
    scheme: FlexScheme.indigo,
    primary: Palette.indigoPrimary,
    secondary: Palette.cyanGlow,
    tertiary: Palette.violetAccent,
    scaffoldBackground: Palette.deepSpace,
    surfaceMode: FlexSurfaceMode.levelSurfacesLowScaffold,
    blendLevel: 10,
    subThemesData: const FlexSubThemesData(
      useMaterial3Typography: true,
      inputDecoratorBorderType: FlexInputBorderType.outline,
      inputDecoratorRadius: 20.0,
      elevatedButtonRadius: 16.0,
      cardRadius: 24.0,
    ),
    visualDensity: FlexColorScheme.comfortablePlatformDensity,
    useMaterial3: true,
  );
}