// song_tile.dart
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mp3player/controllers/favorite_controller.dart';
import 'package:mp3player/controllers/player_controller.dart';
import 'package:mp3player/controllers/playlist_controller.dart';
import 'package:mp3player/controllers/song_controller.dart';
import 'package:mp3player/models/playlist_model.dart';

import 'package:mp3player/utilities/colors.dart';
import 'package:mp3player/utilities/theme_controller.dart';
import 'package:on_audio_query/on_audio_query.dart';

class SongTile extends StatelessWidget {
  final SongModel song;
  final VoidCallback onTap;
  final Widget? leading;
  final bool showFavoriteButton;

  const SongTile({
    super.key,
    required this.song,
    required this.onTap,
    this.leading,
    this.showFavoriteButton = false,
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
    final FavoritesController favoritesController = Get.find();

    return Obx(() {
      final isActive = playerController.currentSong.value?.id == song.id;
      final isFavorite = favoritesController.isFavorite(song.id);
      final theme = themeController.current;

      return RepaintBoundary(
        child: Padding(
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
                      // Favorite Button
                      if (showFavoriteButton)
                        IconButton(
                          icon: Icon(
                            isFavorite
                                ? Icons.favorite_rounded
                                : Icons.favorite_border_rounded,
                            color: isFavorite ? Colors.red : theme.textHint,
                            size: 20,
                          ),
                          onPressed: () {
                            favoritesController.toggleFavorite(song.id);
                            Get.snackbar(
                              isFavorite ? 'Removed' : 'Added',
                              isFavorite
                                  ? 'Removed from favorites'
                                  : 'Added to favorites',
                              backgroundColor: theme.glassLight,
                              colorText: theme.textPrimary,
                              snackPosition: SnackPosition.BOTTOM,
                              duration: const Duration(seconds: 1),
                            );
                          },
                        ),
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
                          } else if (value == 'favorite') {
                            favoritesController.toggleFavorite(song.id);
                            Get.snackbar(
                              favoritesController.isFavorite(song.id)
                                  ? 'Added'
                                  : 'Removed',
                              favoritesController.isFavorite(song.id)
                                  ? 'Added to favorites'
                                  : 'Removed from favorites',
                              backgroundColor: theme.glassLight,
                              colorText: theme.textPrimary,
                              snackPosition: SnackPosition.BOTTOM,
                              duration: const Duration(seconds: 1),
                            );
                          }
                        },
                        itemBuilder: (_) => [
                          const PopupMenuItem(
                            value: 'queue',
                            child: Row(
                              children: [
                                Icon(Icons.queue_music_rounded, size: 18),
                                SizedBox(width: 8),
                                Text('Add to Queue'),
                              ],
                            ),
                          ),
                          const PopupMenuItem(
                            value: 'playlist',
                            child: Row(
                              children: [
                                Icon(Icons.playlist_add_rounded, size: 18),
                                SizedBox(width: 8),
                                Text('Add to Playlist'),
                              ],
                            ),
                          ),
                          PopupMenuItem(
                            value: 'favorite',
                            child: Row(
                              children: [
                                Icon(
                                  isFavorite
                                      ? Icons.favorite_rounded
                                      : Icons.favorite_border_rounded,
                                  size: 18,
                                  color: isFavorite ? Colors.red : null,
                                ),
                                const SizedBox(width: 8),
                                Text(isFavorite
                                    ? 'Remove from Favorites'
                                    : 'Add to Favorites'),
                              ],
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
                    theme.card.withOpacity(0.95),
                    theme.background.withOpacity(0.95),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(28),
                border: Border.all(color: theme.glassBorder, width: 1),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Header
                  Container(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: theme.glassBorder,
                          width: 1,
                        ),
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              colors: [theme.primary, theme.aurora1],
                            ),
                          ),
                          child: const Icon(
                            Icons.playlist_add_rounded,
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
                                'Add to Playlist',
                                style: TextStyle(
                                  color: theme.textPrimary,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              Text(
                                song.displayNameWOExt,
                                style: TextStyle(
                                  color: theme.textHint,
                                  fontSize: 12,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Playlist List
                  Flexible(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        maxHeight: MediaQuery.of(context).size.height * 0.5,
                      ),
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: playlists.length + 1,
                        itemBuilder: (context, index) {
                          if (index == playlists.length) {
                            return _buildCreateNewTile(
                              context,
                              song,
                              playlistController,
                              themeController,
                            );
                          }
                          final playlist = playlists[index];
                          return _buildPlaylistTile(
                            playlist,
                            song,
                            playlistController,
                            theme,
                          );
                        },
                      ),
                    ),
                  ),
                  // Footer
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: TextButton(
                      onPressed: () => Get.back(),
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                          side: BorderSide(color: theme.glassBorder),
                        ),
                      ),
                      child: Center(
                        child: Text(
                          'Cancel',
                          style: TextStyle(
                            color: theme.textHint,
                            fontSize: 14,
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

  Widget _buildPlaylistTile(
    Playlist playlist,
    SongModel song,
    PlaylistController playlistController,
    AppTheme theme,
  ) {
    return InkWell(
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
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: theme.glassBorder.withOpacity(0.3)),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                gradient: LinearGradient(
                  colors: [theme.aurora1, theme.aurora2],
                ),
              ),
              child: const Icon(
                Icons.playlist_play_rounded,
                color: Colors.white,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    playlist.name,
                    style: TextStyle(
                      color: theme.textPrimary,
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    '${playlist.songPaths.length} songs',
                    style: TextStyle(
                      color: theme.textHint,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.add_circle_outline_rounded,
              color: theme.primary,
              size: 24,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCreateNewTile(
    BuildContext context,
    SongModel song,
    PlaylistController playlistController,
    ThemeController themeController,
  ) {
    final theme = themeController.current;

    return InkWell(
      onTap: () {
        Get.back();
        _showCreatePlaylistDialog(
            context, song, playlistController, themeController);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                gradient: LinearGradient(
                  colors: [theme.primary, theme.aurora1],
                ),
              ),
              child: const Icon(
                Icons.add_rounded,
                color: Colors.white,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Create New Playlist',
                    style: TextStyle(
                      color: theme.textPrimary,
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    'Start a fresh collection',
                    style: TextStyle(
                      color: theme.textHint,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios_rounded,
              color: theme.textHint,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }

  void _showCreatePlaylistDialog(
    BuildContext context,
    SongModel song,
    PlaylistController playlistController,
    ThemeController themeController,
  ) {
    final nameCtrl = TextEditingController();
    final theme = themeController.current;

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
                    theme.card.withOpacity(0.95),
                    theme.background.withOpacity(0.95),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(28),
                border: Border.all(color: theme.glassBorder, width: 1),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Header
                  Container(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: theme.glassBorder,
                          width: 1,
                        ),
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              colors: [theme.primary, theme.aurora1],
                            ),
                          ),
                          child: const Icon(
                            Icons.playlist_add_rounded,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Create New Playlist',
                            style: TextStyle(
                              color: theme.textPrimary,
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Input field
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Playlist Name',
                          style: TextStyle(
                            color: theme.textSecondary,
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: theme.glassBorder),
                          ),
                          child: TextField(
                            controller: nameCtrl,
                            autofocus: true,
                            style: TextStyle(color: theme.textPrimary),
                            decoration: InputDecoration(
                              hintText: 'e.g., My Favorite Songs',
                              hintStyle: TextStyle(color: theme.textHint),
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 14,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Actions
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextButton(
                            onPressed: () => Get.back(),
                            style: TextButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                                side: BorderSide(color: theme.glassBorder),
                              ),
                            ),
                            child: Text(
                              'Cancel',
                              style: TextStyle(
                                color: theme.textHint,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              if (nameCtrl.text.trim().isNotEmpty) {
                                playlistController.createPlaylist(
                                  nameCtrl.text.trim(),
                                );
                                final newPlaylist =
                                    playlistController.playlists.last;
                                playlistController.addSongToPlaylist(
                                  newPlaylist.id,
                                  song.data,
                                );
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
                            style: ElevatedButton.styleFrom(
                              backgroundColor: theme.primary,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            child: Text(
                              'Create',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
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
