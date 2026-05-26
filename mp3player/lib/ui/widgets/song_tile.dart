// song_tile.dart
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mp3player/controllers/player_controller.dart';
import 'package:mp3player/controllers/playlist_controller.dart';
import 'package:mp3player/controllers/song_controller.dart';
import 'package:mp3player/utilities/colors.dart';
import 'package:mp3player/utilities/theme_controller.dart';
import 'package:on_audio_query/on_audio_query.dart';

class SongTile extends StatelessWidget {
  final SongModel song;
  final VoidCallback onTap;
  final Widget? leading;

  const SongTile({
    super.key,
    required this.song,
    required this.onTap,
    this.leading,
  });

  // Deterministic gradient per song id
  static LinearGradient _gradientFor(int id, AppTheme theme) {
    final gradients = [
      [theme.primary, theme.aurora1],
      [theme.aurora3, theme.aurora1],
      [theme.aurora2, theme.primary],
      [theme.aurora2, theme.aurora3],
      [theme.aurora1, theme.aurora2],
      [const Color(0xFF10B981), const Color(0xFF3B82F6)],
    ];
    final g = gradients[id % gradients.length];
    return LinearGradient(
        colors: g, begin: Alignment.topLeft, end: Alignment.bottomRight);
  }

  @override
  Widget build(BuildContext context) {
    final PlayerController playerController = Get.find();
    final PlaylistController playlistController = Get.find();
    final SongController songController = Get.find();
    final ThemeController themeController = Get.find();

    return Obx(() {
      final isActive = playerController.currentSong.value?.id == song.id;
      final theme = themeController.current;

      return Padding(
        padding: const EdgeInsets.only(bottom: 6),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(18),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              decoration: BoxDecoration(
                gradient: isActive
                    ? LinearGradient(
                        colors: [
                          theme.primary.withOpacity(0.18),
                          theme.aurora1.withOpacity(0.12),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      )
                    : null,
                color: isActive ? null : theme.glassLight,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: isActive
                      ? theme.primary.withOpacity(0.4)
                      : theme.glassBorder,
                ),
              ),
              child: ListTile(
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                leading: leading ??
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: QueryArtworkWidget(
                        id: song.id,
                        type: ArtworkType.AUDIO,
                        keepOldArtwork: true,
                        artworkWidth: 48,
                        artworkHeight: 48,
                        artworkFit: BoxFit.cover,
                        nullArtworkWidget: Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            gradient: _gradientFor(song.id, theme),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(Icons.music_note_rounded,
                              color: Colors.white70, size: 22),
                        ),
                      ),
                    ),
                title: Text(
                  song.displayNameWOExt,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: isActive ? theme.primary : theme.textPrimary,
                    fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                    fontSize: 14,
                  ),
                ),
                subtitle: Text(
                  song.artist ?? 'Unknown artist',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: theme.textHint, fontSize: 12),
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (isActive) const _EqAnimation(),
                    PopupMenuButton<String>(
                      icon: Icon(Icons.more_vert_rounded,
                          color: theme.textHint, size: 20),
                      color: theme.card,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14)),
                      onSelected: (value) {
                        if (value == 'queue') {
                          playerController.addToQueue(song);
                          Get.snackbar(
                            'Queue',
                            'Added to queue',
                            backgroundColor: theme.glassLight,
                            colorText: theme.textPrimary,
                            snackPosition: SnackPosition.BOTTOM,
                            duration: const Duration(seconds: 2),
                          );
                        } else if (value == 'playlist') {
                          _showAddToPlaylistDialog(
                            context,
                            song,
                            playlistController,
                            songController,
                            themeController,
                          );
                        }
                      },
                      itemBuilder: (_) => [
                        PopupMenuItem(
                          value: 'queue',
                          child: Text(
                            'Add to Queue',
                            style: TextStyle(color: theme.textPrimary),
                          ),
                        ),
                        PopupMenuItem(
                          value: 'playlist',
                          child: Text(
                            'Add to Playlist',
                            style: TextStyle(color: theme.textPrimary),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                onTap: onTap,
              ),
            ),
          ),
        ),
      );
    });
  }

  void _showAddToPlaylistDialog(
    BuildContext context,
    SongModel song,
    PlaylistController playlistController,
    SongController songController,
    ThemeController themeController,
  ) {
    final playlists = playlistController.playlists;
    final theme = themeController.current;

    Get.dialog(
      AlertDialog(
        backgroundColor: theme.card,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          'Add to Playlist',
          style: TextStyle(color: theme.textPrimary),
        ),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: playlists.length + 1,
            itemBuilder: (context, index) {
              if (index == playlists.length) {
                return ListTile(
                  leading: Icon(
                    Icons.add_circle_outline,
                    color: theme.primary,
                  ),
                  title: Text(
                    'Create new playlist',
                    style: TextStyle(color: theme.textPrimary),
                  ),
                  onTap: () {
                    Get.back();
                    _createNewPlaylistAndAdd(
                      context,
                      song,
                      playlistController,
                      themeController,
                    );
                  },
                );
              }
              final playlist = playlists[index];
              return ListTile(
                leading: Icon(
                  Icons.library_music_rounded,
                  color: theme.aurora1,
                ),
                title: Text(
                  playlist.name,
                  style: TextStyle(color: theme.textPrimary),
                ),
                onTap: () {
                  playlistController.addSongToPlaylist(playlist.id, song.data);
                  Get.back();
                  Get.snackbar(
                    'Added',
                    'Song added to ${playlist.name}',
                    backgroundColor: theme.glassLight,
                    colorText: theme.textPrimary,
                    snackPosition: SnackPosition.BOTTOM,
                    duration: const Duration(seconds: 2),
                  );
                },
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(
              'Cancel',
              style: TextStyle(color: theme.textHint),
            ),
          ),
        ],
      ),
    );
  }

  void _createNewPlaylistAndAdd(
    BuildContext context,
    SongModel song,
    PlaylistController playlistController,
    ThemeController themeController,
  ) {
    final nameCtrl = TextEditingController();
    final theme = themeController.current;

    Get.dialog(
      AlertDialog(
        backgroundColor: theme.card,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          'New Playlist',
          style: TextStyle(color: theme.textPrimary),
        ),
        content: TextField(
          controller: nameCtrl,
          autofocus: true,
          style: TextStyle(color: theme.textPrimary),
          decoration: InputDecoration(
            hintText: 'Playlist name',
            hintStyle: TextStyle(color: theme.textHint),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: theme.glassBorder),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: theme.primary),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(
              'Cancel',
              style: TextStyle(color: theme.textHint),
            ),
          ),
          TextButton(
            onPressed: () {
              if (nameCtrl.text.trim().isNotEmpty) {
                playlistController.createPlaylist(nameCtrl.text.trim());
                final newPlaylist = playlistController.playlists.last;
                playlistController.addSongToPlaylist(newPlaylist.id, song.data);
                Get.back();
                Get.back();
                Get.snackbar(
                  'Created',
                  'Playlist "${newPlaylist.name}" created',
                  backgroundColor: theme.glassLight,
                  colorText: theme.textPrimary,
                  snackPosition: SnackPosition.BOTTOM,
                  duration: const Duration(seconds: 2),
                );
              }
            },
            child: Text(
              'Create',
              style: TextStyle(
                color: theme.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Animated EQ bars shown on active song
class _EqAnimation extends StatefulWidget {
  const _EqAnimation();

  @override
  State<_EqAnimation> createState() => _EqAnimationState();
}

class _EqAnimationState extends State<_EqAnimation>
    with TickerProviderStateMixin {
  late final List<AnimationController> _controllers;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(4, (i) {
      final c = AnimationController(
        vsync: this,
        duration: Duration(milliseconds: 400 + i * 80),
      )..repeat(reverse: true);
      return c;
    });
  }

  @override
  void dispose() {
    for (final c in _controllers) c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Get.find<ThemeController>();

    return Padding(
      padding: const EdgeInsets.only(right: 4),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: List.generate(4, (i) {
          return AnimatedBuilder(
            animation: _controllers[i],
            builder: (_, __) => Container(
              width: 3,
              height: 6 + _controllers[i].value * 10,
              margin: const EdgeInsets.symmetric(horizontal: 1),
              decoration: BoxDecoration(
                color: theme.primary,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          );
        }),
      ),
    );
  }
}
