import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
                Text('Music Lover',
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
                      _Stat('Favorites', '—', t.aurora3),
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
                        onTap: () {},
                      ),
                      _divider(t.glassBorder),
                      _MenuItem(
                        icon: Icons.storage_rounded,
                        label: 'Storage & Cache',
                        color: t.aurora1,
                        textColor: t.textPrimary,
                        hintColor: t.textHint,
                        onTap: () {},
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // ── Follow me section ─────────────────────────
                _SectionLabel('Follow Me', t.textHint),
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
                        subtitle: '@yourusername',
                        color: const Color(0xFFE1306C),
                        textColor: t.textPrimary,
                        hintColor: t.textHint,
                        onTap: () =>
                            _launch('https://instagram.com/yourusername'),
                      ),
                      _divider(t.glassBorder),
                      _MenuItem(
                        icon: Icons.facebook_rounded,
                        label: 'Facebook',
                        subtitle: 'fb.com/yourpage',
                        color: const Color(0xFF1877F2),
                        textColor: t.textPrimary,
                        hintColor: t.textHint,
                        onTap: () => _launch('https://facebook.com/yourpage'),
                      ),
                      _divider(t.glassBorder),
                      _MenuItem(
                        icon: Icons.language_rounded,
                        label: 'Website',
                        subtitle: 'yourwebsite.com',
                        color: t.aurora2,
                        textColor: t.textPrimary,
                        hintColor: t.textHint,
                        onTap: () => _launch('https://yourwebsite.com'),
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
                        onTap: () => _showAbout(context, t),
                      ),
                      _divider(t.glassBorder),
                      _MenuItem(
                        icon: Icons.shield_rounded,
                        label: 'Privacy & Policy',
                        color: t.primary,
                        textColor: t.textPrimary,
                        hintColor: t.textHint,
                        onTap: () => _launch('https://yourwebsite.com/privacy'),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),

                // Version
                Text('v1.0.0  •  Made with ♥',
                    style: TextStyle(color: t.textHint, fontSize: 11)),
                const SizedBox(height: 8),
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
  void _showAbout(BuildContext context, AppTheme t) {
    Get.dialog(
      AlertDialog(
        backgroundColor: t.card,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text('About App',
            style:
                TextStyle(color: t.textPrimary, fontWeight: FontWeight.w700)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [t.primary, t.aurora1],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: const Icon(Icons.music_note_rounded,
                  color: Colors.white, size: 36),
            ),
            const SizedBox(height: 12),
            Text('Galaxy Music Player',
                style: TextStyle(
                    color: t.textPrimary,
                    fontSize: 16,
                    fontWeight: FontWeight.w600)),
            const SizedBox(height: 4),
            Text('Version 1.0.0',
                style: TextStyle(color: t.textHint, fontSize: 12)),
            const SizedBox(height: 10),
            Text(
              'A beautiful offline music player with galaxy-inspired design. Play your local music in style.',
              style: TextStyle(color: t.textSecondary, fontSize: 13),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('Close', style: TextStyle(color: t.primary)),
          ),
        ],
      ),
    );
  }

  Future<void> _launch(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri))
      launchUrl(uri, mode: LaunchMode.externalApplication);
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
