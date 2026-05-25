// now_playing.dart - NO GalaxyBackground wrapper here
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mp3player/utilities/colors.dart';
import 'package:on_audio_query/on_audio_query.dart';
import '../controllers/player_controller.dart';

class NowPlayingPage extends StatelessWidget {
  const NowPlayingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final player = Get.find<PlayerController>();

    return Scaffold(
      backgroundColor: Colors.transparent, // Transparent to show root galaxy
      body: SafeArea(
        child: Obx(() {
          if (player.currentSong.value == null) {
            return const Center(
              child: Text('No track selected',
                  style: TextStyle(color: AppColors.textSecondary)),
            );
          }
          final song = player.currentSong.value!;
          final position = player.position.value;
          final duration = player.duration.value;

          return Column(
            children: [
              // App bar
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 8, 16, 0),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.keyboard_arrow_down_rounded,
                          color: AppColors.textSecondary, size: 30),
                      onPressed: () => Get.back(),
                    ),
                    const Expanded(
                      child: Text('Now Playing',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0.5,
                          )),
                    ),
                    const SizedBox(width: 48),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Album Art
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: AspectRatio(
                  aspectRatio: 1,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(28),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withOpacity(0.35),
                          blurRadius: 40,
                          spreadRadius: 4,
                        ),
                        BoxShadow(
                          color: AppColors.aurora1.withOpacity(0.2),
                          blurRadius: 60,
                          spreadRadius: 8,
                          offset: const Offset(10, 10),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(28),
                      child: QueryArtworkWidget(
                        id: song.id,
                        type: ArtworkType.AUDIO,
                        keepOldArtwork: true,
                        artworkFit: BoxFit.cover,
                        nullArtworkWidget: Container(
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                AppColors.primary,
                                AppColors.aurora1,
                                AppColors.aurora2
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                          ),
                          child: const Icon(Icons.music_note_rounded,
                              size: 100, color: Colors.white54),
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 36),

              // Song info
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 28),
                child: Column(
                  children: [
                    Text(song.displayNameWOExt,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis),
                    const SizedBox(height: 6),
                    Text(song.artist ?? 'Unknown artist',
                        style: const TextStyle(
                            fontSize: 15, color: AppColors.textSecondary)),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // Progress
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 28),
                child: Column(
                  children: [
                    SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        activeTrackColor: AppColors.primary,
                        inactiveTrackColor: AppColors.glassLight,
                        thumbColor: Colors.white,
                        overlayColor: AppColors.primary.withOpacity(0.2),
                        trackHeight: 3.5,
                        thumbShape:
                            const RoundSliderThumbShape(enabledThumbRadius: 6),
                      ),
                      child: Slider(
                        value: duration.inMilliseconds > 0
                            ? position.inMilliseconds
                                .toDouble()
                                .clamp(0, duration.inMilliseconds.toDouble())
                            : 0,
                        max: duration.inMilliseconds > 0
                            ? duration.inMilliseconds.toDouble()
                            : 1.0,
                        onChanged: (v) =>
                            player.seekTo(Duration(milliseconds: v.toInt())),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(_fmt(position),
                              style: const TextStyle(
                                  color: AppColors.textHint, fontSize: 12)),
                          Text(_fmt(duration),
                              style: const TextStyle(
                                  color: AppColors.textHint, fontSize: 12)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Controls row
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(32),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 12),
                      decoration: BoxDecoration(
                        color: AppColors.glassLight,
                        borderRadius: BorderRadius.circular(32),
                        border: Border.all(color: AppColors.glassBorder),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Obx(() => IconButton(
                                icon: Icon(Icons.shuffle_rounded,
                                    color: player.isShuffleOn.value
                                        ? AppColors.primary
                                        : AppColors.textHint),
                                iconSize: 26,
                                onPressed: player.toggleShuffle,
                              )),
                          IconButton(
                            icon: const Icon(Icons.skip_previous_rounded,
                                color: AppColors.textPrimary),
                            iconSize: 36,
                            onPressed: player.previous,
                          ),
                          Obx(() => GestureDetector(
                                onTap: player.playPause,
                                child: Container(
                                  width: 64,
                                  height: 64,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    gradient: const LinearGradient(
                                      colors: [
                                        AppColors.primary,
                                        AppColors.aurora2
                                      ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color:
                                            AppColors.primary.withOpacity(0.5),
                                        blurRadius: 20,
                                        spreadRadius: 2,
                                      ),
                                    ],
                                  ),
                                  child: Icon(
                                    player.isPlaying.value
                                        ? Icons.pause_rounded
                                        : Icons.play_arrow_rounded,
                                    color: Colors.black,
                                    size: 34,
                                  ),
                                ),
                              )),
                          IconButton(
                            icon: const Icon(Icons.skip_next_rounded,
                                color: AppColors.textPrimary),
                            iconSize: 36,
                            onPressed: player.next,
                          ),
                          IconButton(
                            icon: const Icon(Icons.repeat_rounded,
                                color: AppColors.textHint),
                            iconSize: 26,
                            onPressed: () {},
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          );
        }),
      ),
    );
  }

  String _fmt(Duration d) {
    final m = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$m:$s';
  }
}
