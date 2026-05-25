import 'package:flutter/material.dart';

class AppColors {
  // Galaxy backgrounds
  static const Color background = Color(0xFF050010);
  static const Color surface = Color(0xFF0D0025);
  static const Color card = Color(0xFF1A0A30);

  // Glass overlay colors
  static const Color glassLight = Color(0x12FFFFFF);
  static const Color glassBorder = Color(0x26FFFFFF);
  static const Color glassHover = Color(0x1FFFFFFF);

  // Aurora / Primary
  static const Color primary = Color(0xFF1DB954); // aurora green
  static const Color primaryDark = Color(0xFF1AA34A);
  static const Color aurora1 = Color(0xFF7C3AED); // violet
  static const Color aurora2 = Color(0xFF06B6D4); // cyan
  static const Color aurora3 = Color(0xFFF43F5E); // rose
  static const Color aurora4 = Color(0xFFF59E0B); // amber

  // Nebula tints (for background blobs)
  static const Color nebulaViolet = Color(0x407C3AED);
  static const Color nebulaCyan = Color(0x4006B6D4);
  static const Color nebulaGreen = Color(0x401DB954);
  static const Color nebulaRose = Color(0x40F43F5E);

  // Text
  static const Color textPrimary = Color(0xF2FFFFFF);
  static const Color textSecondary = Color(0x99FFFFFF);
  static const Color textHint = Color(0x59FFFFFF);

  // Mini Player
  static const Color miniPlayerBg = Color(0xCC0D0025);
  static const Color iconColor = Colors.white;

  // Gradient helpers
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primary, aurora1],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient galaxyGradient = LinearGradient(
    colors: [Color(0xFF0D0025), Color(0xFF00152B), Color(0xFF1A0030)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
