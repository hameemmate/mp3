// profile_section.dart
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mp3player/controllers/song_controller.dart';
import 'package:mp3player/utilities/theme_controller.dart';

class ProfileSection extends StatelessWidget {
  const ProfileSection({super.key});

  @override
  Widget build(BuildContext context) {
    final SongController songController = Get.find();
    final theme = Get.find<ThemeController>();

    return Obx(() => Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color: theme.glassLight,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: theme.glassBorder),
                ),
                child: Row(
                  children: [
                    // ── WATT Logo ──────────────────────────────
                    Container(
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.black.withOpacity(0.3),
                        boxShadow: [
                          BoxShadow(
                            color: theme.primary.withOpacity(0.35),
                            blurRadius: 14,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: Image.asset(
                        'assets/images/logo.png',
                        fit: BoxFit.cover,
                      ),
                    ),

                    const SizedBox(width: 14),

                    // ── Name + song count ──────────────────────
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'WATT MUSIC PLAYER',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w800,
                              color: theme.textPrimary,
                              letterSpacing: 1.2,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Obx(() => Text(
                                '${songController.allSongs.length} songs on device',
                                style: TextStyle(
                                    color: theme.textHint, fontSize: 12),
                              )),
                        ],
                      ),
                    ),

                    // ── EQ icon ────────────────────────────────
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: theme.primary.withOpacity(0.12),
                      ),
                      child: Icon(
                        Icons.graphic_eq_rounded,
                        color: theme.primary,
                        size: 20,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}
