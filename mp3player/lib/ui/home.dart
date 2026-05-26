// home.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mp3player/ui/widgets/profile_section.dart';
import 'package:mp3player/ui/widgets/song_tile.dart';
import 'package:mp3player/utilities/colors.dart';
import 'package:mp3player/utilities/theme_controller.dart';
import '../controllers/song_controller.dart';
import '../controllers/player_controller.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final SongController songController = Get.find();
    final PlayerController playerController = Get.find();
    final theme = Get.find<ThemeController>();
    final TextEditingController searchCtrl = TextEditingController();

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Column(
          children: [
            const ProfileSection(),
            // Glass search bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Obx(() => Container(
                    decoration: BoxDecoration(
                      color: theme.glassLight,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: theme.glassBorder),
                    ),
                    child: TextField(
                      controller: searchCtrl,
                      onChanged: (v) => songController.searchQuery.value = v,
                      style: TextStyle(color: theme.textPrimary),
                      decoration: InputDecoration(
                        hintText: 'Search songs, artists...',
                        hintStyle: TextStyle(color: theme.textHint),
                        prefixIcon: Icon(Icons.search_rounded,
                            color: AppColors.textHint),
                        border: InputBorder.none,
                        contentPadding:
                            const EdgeInsets.symmetric(vertical: 14),
                      ),
                    ),
                  )),
            ),
            // Section header
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 4, 20, 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('All Songs',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                        color: theme.textPrimary,
                      )),
                  Obx(() => Text(
                        '${songController.filteredSongs.length} tracks',
                        style: TextStyle(fontSize: 12, color: theme.textHint),
                      )),
                ],
              ),
            ),
            // Song list
            Expanded(
              child: Obx(() {
                if (songController.isLoading.value) {
                  return Center(
                    child: CircularProgressIndicator(color: theme.primary),
                  );
                }
                final songs = songController.filteredSongs;
                if (songs.isEmpty) {
                  return Center(
                    child: Text('No songs found',
                        style: TextStyle(color: theme.textSecondary)),
                  );
                }
                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  itemCount: songs.length,
                  itemBuilder: (context, index) {
                    final song = songs[index];
                    final originalIndex = songController.allSongs.indexOf(song);
                    return SongTile(
                      song: song,
                      onTap: () => playerController.playPlaylist(
                        songController.allSongs.toList(),
                        startIndex: originalIndex >= 0 ? originalIndex : 0,
                      ),
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
