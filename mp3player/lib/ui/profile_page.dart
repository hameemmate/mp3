// profile_page.dart
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mp3player/controllers/favorite_controller.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:mp3player/utilities/theme_controller.dart';
import '../controllers/song_controller.dart';
import '../controllers/playlist_controller.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final song = Get.find<SongController>();
    final playlist = Get.find<PlaylistController>();
    final favorites = Get.find<FavoritesController>();
    final theme = Get.find<ThemeController>();

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          child: Obx(() {
            final t = theme.current;
            return Column(
              children: [
                // ── Header ──────────────────────────────────
                const SizedBox(height: 12),
                _Avatar(primary: t.primary, aurora1: t.aurora1),
                const SizedBox(height: 14),
                Text('Ahamed Hameem',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: t.textPrimary,
                    )),
                const SizedBox(height: 4),
                Text('Your personal music universe',
                    style: TextStyle(color: t.textHint, fontSize: 13)),
                const SizedBox(height: 20),

                // ── Stats ────────────────────────────────────
                _GlassCard(
                  glassLight: t.glassLight,
                  glassBorder: t.glassBorder,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _Stat('Songs', '${song.allSongs.length}', t.primary),
                      _vDivider(t.glassBorder),
                      _Stat('Playlists', '${playlist.playlists.length}',
                          t.aurora1),
                      _vDivider(t.glassBorder),
                      _Stat(
                          'Favorites', '${favorites.favoriteCount}', t.aurora3),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // ── Settings section ─────────────────────────
                _SectionLabel('Settings', t.textHint),
                const SizedBox(height: 8),
                _GlassCard(
                  glassLight: t.glassLight,
                  glassBorder: t.glassBorder,
                  padding: EdgeInsets.zero,
                  child: Column(
                    children: [
                      _MenuItem(
                        icon: Icons.palette_rounded,
                        label: 'Theme & Colors',
                        color: t.primary,
                        textColor: t.textPrimary,
                        hintColor: t.textHint,
                        onTap: () => _showThemePicker(context, theme),
                      ),
                      _divider(t.glassBorder),
                      _MenuItem(
                        icon: Icons.notifications_rounded,
                        label: 'Notifications',
                        color: t.aurora2,
                        textColor: t.textPrimary,
                        hintColor: t.textHint,
                        onTap: () {
                          Get.snackbar(
                            'Coming Soon',
                            'Notifications feature will be available soon',
                            backgroundColor: t.glassLight,
                            colorText: t.textPrimary,
                            snackPosition: SnackPosition.BOTTOM,
                          );
                        },
                      ),
                      _divider(t.glassBorder),
                      _MenuItem(
                        icon: Icons.storage_rounded,
                        label: 'Storage & Cache',
                        color: t.aurora1,
                        textColor: t.textPrimary,
                        hintColor: t.textHint,
                        onTap: () {
                          Get.snackbar(
                            'Coming Soon',
                            'Storage management will be available soon',
                            backgroundColor: t.glassLight,
                            colorText: t.textPrimary,
                            snackPosition: SnackPosition.BOTTOM,
                          );
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // ── Connect with Me section ─────────────────────────
                _SectionLabel('Connect with Me', t.textHint),
                const SizedBox(height: 8),
                _GlassCard(
                  glassLight: t.glassLight,
                  glassBorder: t.glassBorder,
                  padding: EdgeInsets.zero,
                  child: Column(
                    children: [
                      _MenuItem(
                        icon: Icons.camera_alt_rounded,
                        label: 'Instagram',
                        subtitle: '@hameem.ahamed',
                        color: const Color(0xFFE1306C),
                        textColor: t.textPrimary,
                        hintColor: t.textHint,
                        onTap: () => _launchInstagram(),
                      ),
                      _divider(t.glassBorder),
                      _MenuItem(
                        icon: Icons.code_rounded,
                        label: 'GitHub',
                        subtitle: 'github.com/ahamed-hameem',
                        color: t.aurora2,
                        textColor: t.textPrimary,
                        hintColor: t.textHint,
                        onTap: () => _launchGitHub(),
                      ),
                      _divider(t.glassBorder),
                      _MenuItem(
                        icon: Icons.language_rounded,
                        label: 'Portfolio',
                        subtitle: 'ahamed-dev.netlify.app',
                        color: t.aurora1,
                        textColor: t.textPrimary,
                        hintColor: t.textHint,
                        onTap: () => _launchPortfolio(),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // ── Info section ─────────────────────────────
                _SectionLabel('Info', t.textHint),
                const SizedBox(height: 8),
                _GlassCard(
                  glassLight: t.glassLight,
                  glassBorder: t.glassBorder,
                  padding: EdgeInsets.zero,
                  child: Column(
                    children: [
                      _MenuItem(
                        icon: Icons.info_rounded,
                        label: 'About App',
                        color: t.aurora1,
                        textColor: t.textPrimary,
                        hintColor: t.textHint,
                        onTap: () => _showAboutDialog(context, theme),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),

                // Version
                Text('v1.0.0  •  Made with ♥ by Ahamed',
                    style: TextStyle(color: t.textHint, fontSize: 11)),
                const SizedBox(height: 40),
              ],
            );
          }),
        ),
      ),
    );
  }

  // ── Theme picker bottom sheet ──────────────────
  void _showThemePicker(BuildContext context, ThemeController ctrl) {
    Get.bottomSheet(
      _ThemePickerSheet(ctrl: ctrl),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }

  // ── About dialog ──────────────────────────────
  void _showAboutDialog(BuildContext context, ThemeController themeController) {
    final t = themeController.current;

    Get.dialog(
      Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 20),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(28),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    t.card.withOpacity(0.95),
                    t.background.withOpacity(0.95),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(28),
                border: Border.all(color: t.glassBorder, width: 1),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Header with icon
                  Container(
                    padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: t.glassBorder,
                          width: 1,
                        ),
                      ),
                    ),
                    child: Column(
                      children: [
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              colors: [t.primary, t.aurora1, t.aurora2],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: t.primary.withOpacity(0.4),
                                blurRadius: 20,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.music_note_rounded,
                            color: Colors.white,
                            size: 44,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Galaxy Music Player',
                          style: TextStyle(
                            color: t.textPrimary,
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Version 1.0.0',
                          style: TextStyle(
                            color: t.textHint,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Content
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        Text(
                          'A beautiful offline music player with galaxy-inspired design. Play your local music in style with a stunning cosmic experience.',
                          style: TextStyle(
                            color: t.textSecondary,
                            fontSize: 14,
                            height: 1.5,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 20),

                        // Features
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            color: t.glassLight,
                            border: Border.all(color: t.glassBorder),
                          ),
                          child: Column(
                            children: [
                              _buildFeatureRow(
                                Icons.music_note_rounded,
                                'Play Local Music',
                                t,
                              ),
                              const SizedBox(height: 12),
                              _buildFeatureRow(
                                Icons.playlist_play_rounded,
                                'Create Playlists',
                                t,
                              ),
                              const SizedBox(height: 12),
                              _buildFeatureRow(
                                Icons.favorite_rounded,
                                'Favorite Songs',
                                t,
                              ),
                              const SizedBox(height: 12),
                              _buildFeatureRow(
                                Icons.palette_rounded,
                                'Multiple Themes',
                                t,
                              ),
                              const SizedBox(height: 12),
                              _buildFeatureRow(
                                Icons.queue_music_rounded,
                                'Queue Management',
                                t,
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 20),

                        // Developer info
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: t.primary.withOpacity(0.1),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: LinearGradient(
                                    colors: [t.primary, t.aurora1],
                                  ),
                                ),
                                child: const Icon(
                                  Icons.person_rounded,
                                  color: Colors.white,
                                  size: 22,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Developed by',
                                      style: TextStyle(
                                        color: t.textHint,
                                        fontSize: 11,
                                      ),
                                    ),
                                    Text(
                                      'Ahamed Hameem',
                                      style: TextStyle(
                                        color: t.textPrimary,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              IconButton(
                                icon: Icon(
                                  Icons.code_rounded,
                                  color: t.primary,
                                  size: 22,
                                ),
                                onPressed: () => _launchGitHub(),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Close button
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => Get.back(),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: t.primary,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: Text(
                          'Close',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      barrierDismissible: true,
    );
  }

  Widget _buildFeatureRow(IconData icon, String text, AppTheme theme) {
    return Row(
      children: [
        Icon(icon, color: theme.primary, size: 20),
        const SizedBox(width: 12),
        Text(
          text,
          style: TextStyle(
            color: theme.textPrimary,
            fontSize: 13,
          ),
        ),
        const Spacer(),
        Icon(Icons.check_circle_rounded, color: theme.primary, size: 16),
      ],
    );
  }

  // ── URL Launchers with proper handling ──────────────────────────────
  Future<void> _launchInstagram() async {
    final Uri uri = Uri.parse('https://www.instagram.com/hameem.ahamed');
    await _launchUrl(uri);
  }

  Future<void> _launchGitHub() async {
    final Uri uri = Uri.parse('https://github.com/ahamed-hameem');
    await _launchUrl(uri);
  }

  Future<void> _launchPortfolio() async {
    final Uri uri = Uri.parse('https://ahamed-dev.netlify.app');
    await _launchUrl(uri);
  }

  // Update the _launchUrl method in profile_page.dart
  Future<void> _launchUrl(Uri uri) async {
    try {
      // For Instagram, try to open the app first
      if (uri.toString().contains('instagram.com')) {
        final instagramUri =
            Uri.parse(uri.toString().replaceFirst('https://www.', 'https://'));
        // Try to open in Instagram app
        if (await canLaunchUrl(instagramUri)) {
          await launchUrl(
            instagramUri,
            mode: LaunchMode.externalApplication,
          );
          return;
        }
      }

      // For all other URLs, open in browser
      if (await canLaunchUrl(uri)) {
        await launchUrl(
          uri,
          mode: LaunchMode.externalApplication,
          webViewConfiguration: const WebViewConfiguration(
            enableJavaScript: true,
            enableDomStorage: true,
          ),
        );
      } else {
        throw 'Could not launch $uri';
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Could not open link. Please check your internet connection.',
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 3),
      );
    }
  }
}

// ─────────────────────────────────────────────
//  Theme picker bottom sheet
// ─────────────────────────────────────────────
class _ThemePickerSheet extends StatelessWidget {
  final ThemeController ctrl;
  const _ThemePickerSheet({required this.ctrl});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final t = ctrl.current;
      return ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
          child: Container(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
            decoration: BoxDecoration(
              color: t.card.withOpacity(0.95),
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(28)),
              border: Border.all(color: t.glassBorder),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Handle bar
                Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: t.glassBorder,
                      borderRadius: BorderRadius.circular(2),
                    )),
                const SizedBox(height: 16),
                Text('Choose Theme',
                    style: TextStyle(
                      color: t.textPrimary,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    )),
                const SizedBox(height: 20),
                GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 1.55,
                  children: AppThemes.all.map((theme) {
                    final selected = ctrl.current.id == theme.id;
                    return GestureDetector(
                      onTap: () => ctrl.setTheme(theme),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          gradient: LinearGradient(
                            colors: [
                              theme.background,
                              theme.aurora1.withOpacity(0.6),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          border: Border.all(
                            color: selected ? theme.primary : theme.glassBorder,
                            width: selected ? 2.5 : 1,
                          ),
                          boxShadow: selected
                              ? [
                                  BoxShadow(
                                    color: theme.primary.withOpacity(0.4),
                                    blurRadius: 12,
                                    spreadRadius: 1,
                                  )
                                ]
                              : [],
                        ),
                        child: Stack(
                          children: [
                            // Color dots
                            Positioned(
                              bottom: 10,
                              left: 12,
                              child: Row(children: [
                                _dot(theme.primary),
                                const SizedBox(width: 5),
                                _dot(theme.aurora1),
                                const SizedBox(width: 5),
                                _dot(theme.aurora2),
                              ]),
                            ),
                            // Name
                            Positioned(
                              top: 10,
                              left: 12,
                              child: Text(
                                '${theme.emoji} ${theme.name}',
                                style: TextStyle(
                                  color: theme.textPrimary,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            // Checkmark
                            if (selected)
                              Positioned(
                                top: 8,
                                right: 8,
                                child: Container(
                                  width: 20,
                                  height: 20,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: theme.primary,
                                  ),
                                  child: const Icon(Icons.check_rounded,
                                      color: Colors.black, size: 14),
                                ),
                              ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget _dot(Color c) => Container(
        width: 12,
        height: 12,
        decoration: BoxDecoration(shape: BoxShape.circle, color: c),
      );
}

// ─────────────────────────────────────────────
//  Helpers
// ─────────────────────────────────────────────
class _Avatar extends StatelessWidget {
  final Color primary, aurora1;
  const _Avatar({required this.primary, required this.aurora1});
  @override
  Widget build(BuildContext context) => Container(
        width: 90,
        height: 90,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            colors: [aurora1, primary],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
                color: aurora1.withOpacity(0.45),
                blurRadius: 28,
                spreadRadius: 3),
          ],
        ),
        child: const Icon(Icons.person_rounded, size: 48, color: Colors.white),
      );
}

class _GlassCard extends StatelessWidget {
  final Widget child;
  final Color glassLight, glassBorder;
  final EdgeInsetsGeometry? padding;
  const _GlassCard(
      {required this.child,
      required this.glassLight,
      required this.glassBorder,
      this.padding});

  @override
  Widget build(BuildContext context) => ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
          child: Container(
            padding: padding ?? const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: glassLight,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: glassBorder),
            ),
            child: child,
          ),
        ),
      );
}

class _MenuItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String? subtitle;
  final Color color, textColor, hintColor;
  final VoidCallback onTap;

  const _MenuItem({
    required this.icon,
    required this.label,
    required this.color,
    required this.textColor,
    required this.hintColor,
    required this.onTap,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) => ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
        leading: Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color.withOpacity(0.15),
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        title: Text(label,
            style: TextStyle(
                color: textColor, fontSize: 14, fontWeight: FontWeight.w500)),
        subtitle: subtitle != null
            ? Text(subtitle!, style: TextStyle(color: hintColor, fontSize: 12))
            : null,
        trailing: Icon(Icons.chevron_right_rounded, color: hintColor, size: 20),
      );
}

class _Stat extends StatelessWidget {
  final String label, value;
  final Color color;
  const _Stat(this.label, this.value, this.color);
  @override
  Widget build(BuildContext context) => Column(children: [
        Text(value,
            style: TextStyle(
                fontSize: 22, fontWeight: FontWeight.w700, color: color)),
        const SizedBox(height: 3),
        Text(label,
            style: TextStyle(color: color.withOpacity(0.6), fontSize: 11)),
      ]);
}

class _SectionLabel extends StatelessWidget {
  final String text;
  final Color color;
  const _SectionLabel(this.text, this.color);
  @override
  Widget build(BuildContext context) => Align(
        alignment: Alignment.centerLeft,
        child: Text(text.toUpperCase(),
            style: TextStyle(
                color: color,
                fontSize: 11,
                fontWeight: FontWeight.w600,
                letterSpacing: 1.2)),
      );
}

Widget _divider(Color c) =>
    Divider(height: 1, thickness: 1, indent: 16, endIndent: 16, color: c);
Widget _vDivider(Color c) => Container(width: 1, height: 36, color: c);
