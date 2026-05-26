// play_list_details.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mp3player/models/playlist_model.dart';
import 'package:mp3player/ui/widgets/mini_play.dart';
import 'package:mp3player/ui/widgets/song_tile.dart';
import 'package:mp3player/utilities/colors.dart';
import 'package:mp3player/utilities/theme_controller.dart';
import 'package:on_audio_query/on_audio_query.dart';
import '../controllers/song_controller.dart';
import '../controllers/player_controller.dart';

class PlaylistDetailPage extends StatelessWidget {
  final Playlist playlist;
  const PlaylistDetailPage({super.key, required this.playlist});

  @override
  Widget build(BuildContext context) {
    final SongController songController = Get.find();
    final PlayerController playerController = Get.find();
    final theme = Get.find<ThemeController>();

    final songs = playlist.songPaths
        .map((path) => songController.getSongByPath(path))
        .where((song) => song != null)
        .cast<SongModel>()
        .toList();

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(playlist.name, style: TextStyle(color: theme.textPrimary)),
      ),
      body: SafeArea(
        bottom: true,
        top: false,
        child: Column(
          children: [
            Expanded(
              child: songs.isEmpty
                  ? Center(
                      child: Text('Playlist is empty',
                          style: TextStyle(color: theme.textSecondary)))
                  : ListView.builder(
                      itemCount: songs.length,
                      itemBuilder: (context, index) {
                        final song = songs[index];
                        return SongTile(
                          song: song,
                          onTap: () => playerController.playPlaylist(
                            songs,
                            startIndex: index,
                          ),
                        );
                      },
                    ),
            ),
            const MiniPlayer(),
          ],
        ),
      ),
    );
  }
}
