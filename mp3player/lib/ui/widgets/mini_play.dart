// mini_play.dart
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mp3player/controllers/player_controller.dart';
import 'package:mp3player/ui/now_playing.dart';
import 'package:mp3player/utilities/colors.dart';
import 'package:mp3player/utilities/theme_controller.dart';

class MiniPlayer extends StatelessWidget {
  const MiniPlayer({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<PlayerController>();
    final theme = Get.find<ThemeController>();

    return Obx(() {
      if (controller.currentSong.value == null) return const SizedBox.shrink();
      final song = controller.currentSong.value!;
      final progress = controller.duration.value.inMilliseconds > 0
          ? controller.position.value.inMilliseconds /
              controller.duration.value.inMilliseconds
          : 0.0;

      return GestureDetector(
        onTap: () => Get.to(() => const NowPlayingPage(),
            transition: Transition.downToUp),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(22),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      theme.primary.withOpacity(0.12),
                      theme.aurora1.withOpacity(0.12),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(color: theme.glassBorder),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(12, 10, 8, 6),
                      child: Row(
                        children: [
                          // Mini album art
                          Container(
                            width: 42,
                            height: 42,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [theme.primary, theme.aurora1],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  color: theme.primary.withOpacity(0.35),
                                  blurRadius: 10,
                                  spreadRadius: 1,
                                ),
                              ],
                            ),
                            child: const Icon(Icons.music_note_rounded,
                                color: Colors.white, size: 20),
                          ),
                          const SizedBox(width: 12),
                          // Song info
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(song.displayNameWOExt,
                                    style: TextStyle(
                                      color: theme.textPrimary,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis),
                                Text(song.artist ?? 'Unknown',
                                    style: TextStyle(
                                        color: theme.textHint, fontSize: 12),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis),
                              ],
                            ),
                          ),
                          // Controls
                          Obx(() => IconButton(
                                icon: Icon(Icons.shuffle_rounded,
                                    color: controller.isShuffleOn.value
                                        ? theme.primary
                                        : theme.textHint,
                                    size: 20),
                                onPressed: controller.toggleShuffle,
                              )),
                          IconButton(
                            icon: Icon(Icons.skip_previous_rounded,
                                color: theme.textSecondary, size: 22),
                            onPressed: controller.previous,
                          ),
                          Obx(() => _PlayPauseBtn(
                                isPlaying: controller.isPlaying.value,
                                onTap: controller.playPause,
                                theme: theme.current,
                              )),
                          IconButton(
                            icon: Icon(Icons.skip_next_rounded,
                                color: theme.textSecondary, size: 22),
                            onPressed: controller.next,
                          ),
                        ],
                      ),
                    ),
                    // Progress bar
                    Padding(
                      padding: const EdgeInsets.fromLTRB(12, 0, 12, 10),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(2),
                        child: LinearProgressIndicator(
                          value: progress.clamp(0.0, 1.0),
                          minHeight: 3,
                          backgroundColor: theme.glassBorder,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(AppColors.primary),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    });
  }
}

class _PlayPauseBtn extends StatelessWidget {
  final bool isPlaying;
  final VoidCallback onTap;
  final AppTheme theme;

  const _PlayPauseBtn({
    required this.isPlaying,
    required this.onTap,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: theme.primary,
          boxShadow: [
            BoxShadow(
              color: theme.primary.withOpacity(0.4),
              blurRadius: 12,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Icon(
          isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
          color: Colors.black,
          size: 20,
        ),
      ),
    );
  }
}
