// now_playing.dart
import 'dart:ui';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mp3player/utilities/colors.dart';
import 'package:mp3player/utilities/theme_controller.dart';
import 'package:on_audio_query/on_audio_query.dart';
import '../controllers/player_controller.dart';

class NowPlayingPage extends StatefulWidget {
  const NowPlayingPage({super.key});

  @override
  State<NowPlayingPage> createState() => _NowPlayingPageState();
}

class _NowPlayingPageState extends State<NowPlayingPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _spinController;

  @override
  void initState() {
    super.initState();
    _spinController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    );

    final player = Get.find<PlayerController>();
    if (player.isPlaying.value) _spinController.repeat();

    // sync spin with play/pause
    ever(player.isPlaying, (bool playing) {
      if (playing) {
        _spinController.repeat();
      } else {
        _spinController.stop();
      }
    });
  }

  @override
  void dispose() {
    _spinController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final player = Get.find<PlayerController>();
    final theme = Get.find<ThemeController>();

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Obx(() {
          if (player.currentSong.value == null) {
            return Center(
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
                      icon: Icon(Icons.keyboard_arrow_down_rounded,
                          color: AppColors.textSecondary, size: 30),
                      onPressed: () => Get.back(),
                    ),
                    Expanded(
                      child: Text('Now Playing',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: theme.textSecondary,
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

              // Vinyl Disk with Album Art
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: AspectRatio(
                  aspectRatio: 1,
                  child: AnimatedBuilder(
                    animation: _spinController,
                    builder: (context, child) {
                      return Transform.rotate(
                        angle: _spinController.value * 2 * math.pi,
                        child: child,
                      );
                    },
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // Vinyl outer ring
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: RadialGradient(
                              colors: [
                                const Color(0xFF1a1a1a),
                                const Color(0xFF111111),
                                const Color(0xFF2a2a2a),
                                const Color(0xFF111111),
                              ],
                              stops: const [0.0, 0.3, 0.6, 1.0],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: theme.primary.withOpacity(0.4),
                                blurRadius: 40,
                                spreadRadius: 4,
                              ),
                              BoxShadow(
                                color: theme.aurora1.withOpacity(0.2),
                                blurRadius: 60,
                                spreadRadius: 8,
                                offset: const Offset(10, 10),
                              ),
                            ],
                          ),
                        ),

                        // Vinyl grooves (concentric rings)
                        ..._buildGrooves(),

                        // Center label (album art circle)
                        ClipOval(
                          child: SizedBox(
                            width: 180, // ~55% of typical album art size
                            height: 180,
                            child: QueryArtworkWidget(
                              id: song.id,
                              type: ArtworkType.AUDIO,
                              keepOldArtwork: true,
                              artworkFit: BoxFit.cover,
                              artworkQuality: FilterQuality.high,
                              artworkBorder: BorderRadius.circular(999),
                              nullArtworkWidget: Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: LinearGradient(
                                    colors: [
                                      theme.primary,
                                      theme.aurora1,
                                      theme.aurora2
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                ),
                                child: const Icon(Icons.music_note_rounded,
                                    size: 72, color: Colors.white54),
                              ),
                            ),
                          ),
                        ),

                        // Center spindle hole
                        Container(
                          width: 14,
                          height: 14,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: const Color(0xFF111111),
                            border: Border.all(color: Colors.white12, width: 1),
                          ),
                        ),
                      ],
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
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          color: theme.textPrimary,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis),
                    const SizedBox(height: 6),
                    Text(song.artist ?? 'Unknown artist',
                        style: TextStyle(
                            fontSize: 15, color: theme.textSecondary)),
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
                        activeTrackColor: theme.primary,
                        inactiveTrackColor: theme.glassLight,
                        thumbColor: Colors.white,
                        overlayColor: theme.primary.withOpacity(0.2),
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
                              style: TextStyle(
                                  color: theme.textHint, fontSize: 12)),
                          Text(_fmt(duration),
                              style: TextStyle(
                                  color: theme.textHint, fontSize: 12)),
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
                        color: theme.glassLight,
                        borderRadius: BorderRadius.circular(32),
                        border: Border.all(color: theme.glassBorder),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Obx(() => IconButton(
                                icon: Icon(Icons.shuffle_rounded,
                                    color: player.isShuffleOn.value
                                        ? theme.primary
                                        : theme.textHint),
                                iconSize: 26,
                                onPressed: player.toggleShuffle,
                              )),
                          IconButton(
                            icon: Icon(Icons.skip_previous_rounded,
                                color: theme.textPrimary),
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
                                    gradient: LinearGradient(
                                      colors: [theme.primary, theme.aurora2],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: theme.primary.withOpacity(0.5),
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
                            icon: Icon(Icons.skip_next_rounded,
                                color: theme.textPrimary),
                            iconSize: 36,
                            onPressed: player.next,
                          ),
                          IconButton(
                            icon: Icon(Icons.repeat_rounded,
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

  /// Build subtle vinyl groove rings
  List<Widget> _buildGrooves() {
    const grooveRadii = [0.48, 0.44, 0.40, 0.36, 0.32];
    return grooveRadii
        .map((r) => FractionallySizedBox(
              widthFactor: r * 2,
              heightFactor: r * 2,
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white.withOpacity(0.04),
                    width: 1.2,
                  ),
                ),
              ),
            ))
        .toList();
  }

  String _fmt(Duration d) {
    final m = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$m:$s';
  }
}
