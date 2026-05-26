// profile_section.dart
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mp3player/controllers/song_controller.dart';
import 'package:mp3player/utilities/colors.dart';
import 'package:mp3player/utilities/theme_controller.dart';

class ProfileSection extends StatelessWidget {
  const ProfileSection({super.key});

  @override
  Widget build(BuildContext context) {
    final SongController songController = Get.find();
    final theme = Get.find<ThemeController>();

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: theme.glassLight,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: theme.glassBorder),
            ),
            child: Row(
              children: [
                // Avatar with aurora ring
                Container(
                  width: 46,
                  height: 46,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [theme.aurora1, theme.aurora2],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: theme.aurora1.withOpacity(0.4),
                        blurRadius: 12,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  child: const Icon(Icons.person_rounded,
                      color: Colors.white, size: 24),
                ),
                const SizedBox(width: 14),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Music Lover',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: theme.textPrimary,
                        )),
                    const SizedBox(height: 2),
                    Obx(() => Text(
                          '${songController.allSongs.length} songs on device',
                          style: TextStyle(color: theme.textHint, fontSize: 12),
                        )),
                  ],
                ),
                const Spacer(),
                // Decorative music note
                Icon(Icons.graphic_eq_rounded,
                    color: theme.primary.withOpacity(0.7), size: 28),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
