import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mp3player/ui/widgets/profile_section.dart';
import 'package:mp3player/ui/widgets/song_tile.dart';
import 'package:mp3player/utilities/colors.dart';
import '../controllers/song_controller.dart';
import '../controllers/player_controller.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final SongController songController = Get.find();
    final PlayerController playerController = Get.find();
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
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.glassLight,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.glassBorder),
                ),
                child: TextField(
                  controller: searchCtrl,
                  onChanged: (v) => songController.searchQuery.value = v,
                  style: const TextStyle(color: AppColors.textPrimary),
                  decoration: const InputDecoration(
                    hintText: 'Search songs, artists...',
                    hintStyle: TextStyle(color: AppColors.textHint),
                    prefixIcon:
                        Icon(Icons.search_rounded, color: AppColors.textHint),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
              ),
            ),
            // Section header
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 4, 20, 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('All Songs',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      )),
                  Obx(() => Text(
                        '${songController.filteredSongs.length} tracks',
                        style: const TextStyle(
                            fontSize: 12, color: AppColors.textHint),
                      )),
                ],
              ),
            ),
            // Song list
            Expanded(
              child: Obx(() {
                if (songController.isLoading.value) {
                  return const Center(
                    child: CircularProgressIndicator(color: AppColors.primary),
                  );
                }
                final songs = songController.filteredSongs;
                if (songs.isEmpty) {
                  return const Center(
                    child: Text('No songs found',
                        style: TextStyle(color: AppColors.textSecondary)),
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
