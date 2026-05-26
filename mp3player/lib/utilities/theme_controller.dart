// theme_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';

// ─────────────────────────────────────────────
//  Theme definitions
// ─────────────────────────────────────────────
class AppTheme {
  final String id;
  final String name;
  final String emoji;
  final Color background;
  final Color surface;
  final Color card;
  final Color primary;
  final Color aurora1;
  final Color aurora2;
  final Color aurora3;
  final Color aurora4;
  final Color textPrimary;
  final Color textSecondary;
  final Color textHint;
  final Color glassLight;
  final Color glassBorder;
  final Color nebula1;
  final Color nebula2;
  final Color nebula3;
  final Color nebula4;
  final List<List<Color>> auroraRibbons;

  const AppTheme({
    required this.id,
    required this.name,
    required this.emoji,
    required this.background,
    required this.surface,
    required this.card,
    required this.primary,
    required this.aurora1,
    required this.aurora2,
    required this.aurora3,
    required this.aurora4,
    required this.textPrimary,
    required this.textSecondary,
    required this.textHint,
    required this.glassLight,
    required this.glassBorder,
    required this.nebula1,
    required this.nebula2,
    required this.nebula3,
    required this.nebula4,
    required this.auroraRibbons,
  });
}

// ─────────────────────────────────────────────
//  All themes
// ─────────────────────────────────────────────
class AppThemes {
  static const galaxy = AppTheme(
    id: 'galaxy',
    name: 'Galaxy',
    emoji: '🌌',
    background: Color(0xFF010008),
    surface: Color(0xFF0D0025),
    card: Color(0xFF1A0A30),
    primary: Color(0xFF1DB954),
    aurora1: Color(0xFF7C3AED),
    aurora2: Color(0xFF06B6D4),
    aurora3: Color(0xFFF43F5E),
    aurora4: Color(0xFFF59E0B),
    textPrimary: Color(0xF2FFFFFF),
    textSecondary: Color(0x99FFFFFF),
    textHint: Color(0x59FFFFFF),
    glassLight: Color(0x12FFFFFF),
    glassBorder: Color(0x26FFFFFF),
    nebula1: Color(0x407C3AED),
    nebula2: Color(0x4006B6D4),
    nebula3: Color(0x401DB954),
    nebula4: Color(0x40F43F5E),
    auroraRibbons: [
      [Color(0xFF1DB954), Color(0xFF06B6D4)],
      [Color(0xFF7C3AED), Color(0xFF1DB954)],
      [Color(0xFF06B6D4), Color(0xFF7C3AED)],
      [Color(0xFFF43F5E), Color(0xFF7C3AED)],
      [Color(0xFF1DB954), Color(0xFFF43F5E)],
    ],
  );

  static const midnight = AppTheme(
    id: 'midnight',
    name: 'Midnight Blue',
    emoji: '🌊',
    background: Color(0xFF000814),
    surface: Color(0xFF001233),
    card: Color(0xFF023E8A),
    primary: Color(0xFF48CAE4),
    aurora1: Color(0xFF0096C7),
    aurora2: Color(0xFF00B4D8),
    aurora3: Color(0xFF90E0EF),
    aurora4: Color(0xFF00B4D8),
    textPrimary: Color(0xF2FFFFFF),
    textSecondary: Color(0x99FFFFFF),
    textHint: Color(0x59FFFFFF),
    glassLight: Color(0x1200B4D8),
    glassBorder: Color(0x3000B4D8),
    nebula1: Color(0x400096C7),
    nebula2: Color(0x4048CAE4),
    nebula3: Color(0x400077B6),
    nebula4: Color(0x4090E0EF),
    auroraRibbons: [
      [Color(0xFF48CAE4), Color(0xFF0096C7)],
      [Color(0xFF00B4D8), Color(0xFF48CAE4)],
      [Color(0xFF90E0EF), Color(0xFF0096C7)],
      [Color(0xFF023E8A), Color(0xFF00B4D8)],
      [Color(0xFF48CAE4), Color(0xFF90E0EF)],
    ],
  );

  static const crimson = AppTheme(
    id: 'crimson',
    name: 'Crimson Night',
    emoji: '🔴',
    background: Color(0xFF0D0000),
    surface: Color(0xFF1A0000),
    card: Color(0xFF2D0011),
    primary: Color(0xFFE63946),
    aurora1: Color(0xFFFF006E),
    aurora2: Color(0xFFFF4D6D),
    aurora3: Color(0xFFFFB3C1),
    aurora4: Color(0xFFFF4D6D),
    textPrimary: Color(0xF2FFFFFF),
    textSecondary: Color(0x99FFFFFF),
    textHint: Color(0x59FFFFFF),
    glassLight: Color(0x12FF006E),
    glassBorder: Color(0x30FF006E),
    nebula1: Color(0x40E63946),
    nebula2: Color(0x40FF006E),
    nebula3: Color(0x40C1121F),
    nebula4: Color(0x40FF4D6D),
    auroraRibbons: [
      [Color(0xFFE63946), Color(0xFFFF006E)],
      [Color(0xFFFF4D6D), Color(0xFFE63946)],
      [Color(0xFFFF006E), Color(0xFFFFB3C1)],
      [Color(0xFFC1121F), Color(0xFFFF4D6D)],
      [Color(0xFFFFB3C1), Color(0xFFFF006E)],
    ],
  );

  static const forest = AppTheme(
    id: 'forest',
    name: 'Deep Forest',
    emoji: '🌿',
    background: Color(0xFF000D04),
    surface: Color(0xFF001A0A),
    card: Color(0xFF003314),
    primary: Color(0xFF52B788),
    aurora1: Color(0xFF40916C),
    aurora2: Color(0xFF74C69D),
    aurora3: Color(0xFFB7E4C7),
    aurora4: Color(0xFF74C69D),
    textPrimary: Color(0xF2FFFFFF),
    textSecondary: Color(0x99FFFFFF),
    textHint: Color(0x59FFFFFF),
    glassLight: Color(0x1252B788),
    glassBorder: Color(0x3052B788),
    nebula1: Color(0x4040916C),
    nebula2: Color(0x4052B788),
    nebula3: Color(0x4074C69D),
    nebula4: Color(0x401B4332),
    auroraRibbons: [
      [Color(0xFF52B788), Color(0xFF40916C)],
      [Color(0xFF74C69D), Color(0xFF52B788)],
      [Color(0xFF40916C), Color(0xFFB7E4C7)],
      [Color(0xFF1B4332), Color(0xFF74C69D)],
      [Color(0xFFB7E4C7), Color(0xFF52B788)],
    ],
  );

  static const amber = AppTheme(
    id: 'amber',
    name: 'Amber Dusk',
    emoji: '🔥',
    background: Color(0xFF0D0500),
    surface: Color(0xFF1A0A00),
    card: Color(0xFF2D1500),
    primary: Color(0xFFFFB703),
    aurora1: Color(0xFFFB8500),
    aurora2: Color(0xFFFF9F1C),
    aurora3: Color(0xFFFFCB47),
    aurora4: Color(0xFFFF9F1C),
    textPrimary: Color(0xF2FFFFFF),
    textSecondary: Color(0x99FFFFFF),
    textHint: Color(0x59FFFFFF),
    glassLight: Color(0x12FFB703),
    glassBorder: Color(0x30FFB703),
    nebula1: Color(0x40FFB703),
    nebula2: Color(0x40FB8500),
    nebula3: Color(0x40FF9F1C),
    nebula4: Color(0x40E85D04),
    auroraRibbons: [
      [Color(0xFFFFB703), Color(0xFFFB8500)],
      [Color(0xFFFF9F1C), Color(0xFFFFB703)],
      [Color(0xFFFB8500), Color(0xFFFFCB47)],
      [Color(0xFFE85D04), Color(0xFFFF9F1C)],
      [Color(0xFFFFCB47), Color(0xFFFB8500)],
    ],
  );

  static const cyber = AppTheme(
    id: 'cyber',
    name: 'Cyberpunk',
    emoji: '⚡',
    background: Color(0xFF04000F),
    surface: Color(0xFF0A0020),
    card: Color(0xFF150040),
    primary: Color(0xFFE040FB),
    aurora1: Color(0xFF00E5FF),
    aurora2: Color(0xFFE040FB),
    aurora3: Color(0xFFFFEA00),
    aurora4: Color(0xFF00E5FF),
    textPrimary: Color(0xF2FFFFFF),
    textSecondary: Color(0x99FFFFFF),
    textHint: Color(0x59FFFFFF),
    glassLight: Color(0x12E040FB),
    glassBorder: Color(0x30E040FB),
    nebula1: Color(0x40E040FB),
    nebula2: Color(0x4000E5FF),
    nebula3: Color(0x407B00FF),
    nebula4: Color(0x40FFEA00),
    auroraRibbons: [
      [Color(0xFFE040FB), Color(0xFF00E5FF)],
      [Color(0xFF00E5FF), Color(0xFFE040FB)],
      [Color(0xFF7B00FF), Color(0xFF00E5FF)],
      [Color(0xFFFFEA00), Color(0xFFE040FB)],
      [Color(0xFFE040FB), Color(0xFF7B00FF)],
    ],
  );

  static const pearl = AppTheme(
    id: 'pearl',
    name: 'Pearl White',
    emoji: '🤍',
    background: Color(0xFFF8F9FF),
    surface: Color(0xFFEEF0FF),
    card: Color(0xFFE0E4FF),
    primary: Color(0xFF5C6BC0),
    aurora1: Color(0xFF7986CB),
    aurora2: Color(0xFF4DD0E1),
    aurora3: Color(0xFFEC407A),
    aurora4: Color(0xFF4DD0E1),
    textPrimary: Color(0xFF1A1A2E),
    textSecondary: Color(0x991A1A2E),
    textHint: Color(0x591A1A2E),
    glassLight: Color(0x1A5C6BC0),
    glassBorder: Color(0x305C6BC0),
    nebula1: Color(0x307986CB),
    nebula2: Color(0x304DD0E1),
    nebula3: Color(0x305C6BC0),
    nebula4: Color(0x30EC407A),
    auroraRibbons: [
      [Color(0xFF7986CB), Color(0xFF4DD0E1)],
      [Color(0xFF5C6BC0), Color(0xFF7986CB)],
      [Color(0xFF4DD0E1), Color(0xFF5C6BC0)],
      [Color(0xFFEC407A), Color(0xFF7986CB)],
      [Color(0xFF7986CB), Color(0xFFEC407A)],
    ],
  );

  static const List<AppTheme> all = [
    galaxy,
    midnight,
    crimson,
    forest,
    amber,
    cyber,
    pearl,
  ];

  static AppTheme getThemeById(String id) {
    return all.firstWhere(
      (theme) => theme.id == id,
      orElse: () => galaxy,
    );
  }
}

// ─────────────────────────────────────────────
//  Controller — persists with Hive
// ─────────────────────────────────────────────
class ThemeController extends GetxController {
  static const String _themeBoxName = 'theme_box';
  static const String _savedThemeKey = 'saved_theme_id';

  final Rx<AppTheme> _currentTheme = AppThemes.galaxy.obs;

  AppTheme get current => _currentTheme.value;

  late Box _themeBox;

  @override
  void onInit() async {
    super.onInit();
    await _initHive();
    await _loadSavedTheme();
  }

  Future<void> _initHive() async {
    if (!Hive.isBoxOpen(_themeBoxName)) {
      _themeBox = await Hive.openBox(_themeBoxName);
    } else {
      _themeBox = Hive.box(_themeBoxName);
    }
  }

  Future<void> _loadSavedTheme() async {
    try {
      final savedThemeId = _themeBox.get(_savedThemeKey);

      if (savedThemeId != null && savedThemeId is String) {
        final theme = AppThemes.getThemeById(savedThemeId);
        _currentTheme.value = theme;
        debugPrint('✅ Loaded saved theme: ${theme.name} (${theme.id})');
      } else {
        debugPrint('📱 No saved theme, using default: Galaxy');
      }
    } catch (e) {
      debugPrint('❌ Error loading theme: $e');
    }
  }

  Future<void> setTheme(AppTheme theme) async {
    try {
      _currentTheme.value = theme;
      await _themeBox.put(_savedThemeKey, theme.id);
      debugPrint('💾 Saved theme: ${theme.name} (${theme.id})');
    } catch (e) {
      debugPrint('❌ Error saving theme: $e');
    }
  }

  // Convenience getters
  Color get background => current.background;
  Color get surface => current.surface;
  Color get card => current.card;
  Color get primary => current.primary;
  Color get aurora1 => current.aurora1;
  Color get aurora2 => current.aurora2;
  Color get aurora3 => current.aurora3;
  Color get aurora4 => current.aurora4;
  Color get textPrimary => current.textPrimary;
  Color get textSecondary => current.textSecondary;
  Color get textHint => current.textHint;
  Color get glassLight => current.glassLight;
  Color get glassBorder => current.glassBorder;
  Color get nebula1 => current.nebula1;
  Color get nebula2 => current.nebula2;
  Color get nebula3 => current.nebula3;
  Color get nebula4 => current.nebula4;
  List<List<Color>> get auroraRibbons => current.auroraRibbons;
}
