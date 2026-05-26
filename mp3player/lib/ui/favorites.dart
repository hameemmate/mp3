// ui/favorites_page.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mp3player/controllers/favorite_controller.dart';

import 'package:mp3player/controllers/player_controller.dart';
import 'package:mp3player/controllers/song_controller.dart';
import 'package:mp3player/ui/widgets/song_tile.dart';
import 'package:mp3player/utilities/theme_controller.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final songController = Get.find<SongController>();
    final playerController = Get.find<PlayerController>();
    final favoritesController = Get.find<FavoritesController>();
    final theme = Get.find<ThemeController>();

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Favorite Songs',
          style: TextStyle(
            color: theme.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: Obx(() {
        final bool isSongPlaying = playerController.currentSong.value != null;
        final favoriteSongs = favoritesController.getFavoriteSongs(
          songController.allSongs,
        );

        if (favoriteSongs.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.favorite_border,
                  size: 80,
                  color: theme.textHint.withOpacity(0.5),
                ),
                const SizedBox(height: 16),
                Text(
                  'No favorite songs yet',
                  style: TextStyle(
                    color: theme.textSecondary,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Tap the heart icon on any song to add it here',
                  style: TextStyle(
                    color: theme.textHint,
                    fontSize: 12,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: EdgeInsets.only(
            left: 12,
            right: 12,
            top: 8,
            bottom: isSongPlaying ? 180 : 100,
          ),
          itemCount: favoriteSongs.length,
          itemBuilder: (context, index) {
            final song = favoriteSongs[index];
            return SongTile(
              song: song,
              onTap: () => playerController.playPlaylist(
                favoriteSongs,
                startIndex: index,
              ),
              showFavoriteButton: true,
            );
          },
        );
      }),
    );
  }
}
