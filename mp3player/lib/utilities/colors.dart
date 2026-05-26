// colors.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'theme_controller.dart';

class AppColors {
  static ThemeController? _cachedTheme;

  static ThemeController get _theme {
    if (_cachedTheme == null && Get.isRegistered<ThemeController>()) {
      _cachedTheme = Get.find<ThemeController>();
    }
    return _cachedTheme!;
  }

  static bool get isThemeAvailable => Get.isRegistered<ThemeController>();

  static Color get background =>
      isThemeAvailable ? _theme.background : const Color(0xFF010008);
  static Color get surface =>
      isThemeAvailable ? _theme.surface : const Color(0xFF0D0025);
  static Color get card =>
      isThemeAvailable ? _theme.card : const Color(0xFF1A0A30);
  static Color get primary =>
      isThemeAvailable ? _theme.primary : const Color(0xFF1DB954);
  static Color get aurora1 =>
      isThemeAvailable ? _theme.aurora1 : const Color(0xFF7C3AED);
  static Color get aurora2 =>
      isThemeAvailable ? _theme.aurora2 : const Color(0xFF06B6D4);
  static Color get aurora3 =>
      isThemeAvailable ? _theme.aurora3 : const Color(0xFFF43F5E);
  static Color get textPrimary =>
      isThemeAvailable ? _theme.textPrimary : const Color(0xF2FFFFFF);
  static Color get textSecondary =>
      isThemeAvailable ? _theme.textSecondary : const Color(0x99FFFFFF);
  static Color get textHint =>
      isThemeAvailable ? _theme.textHint : const Color(0x59FFFFFF);
  static Color get glassLight =>
      isThemeAvailable ? _theme.glassLight : const Color(0x12FFFFFF);
  static Color get glassBorder =>
      isThemeAvailable ? _theme.glassBorder : const Color(0x26FFFFFF);
}
