import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mp3player/ui/widgets/song_tile.dart';
import 'package:mp3player/utilities/colors.dart';
import '../controllers/player_controller.dart';

class QueuePage extends StatelessWidget {
  const QueuePage({super.key});

  // queue.dart - update Scaffold
  @override
  Widget build(BuildContext context) {
    final PlayerController controller = Get.find();

    return Scaffold(
      backgroundColor: Colors.transparent, // Make transparent
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Current Queue',
            style: TextStyle(color: AppColors.textPrimary)),
      ),
      body: Obx(() {
        if (controller.queue.isEmpty) {
          return const Center(
            child: Text('Queue is empty',
                style: TextStyle(color: AppColors.textSecondary)),
          );
        }
        return ListView.builder(
          itemCount: controller.queue.length,
          itemBuilder: (context, index) {
            final song = controller.queue[index];
            return SongTile(
              song: song,
              onTap: () {
                controller.playPlaylist(
                  controller.queue.toList(),
                  startIndex: index,
                );
              },
              leading: Obx(
                () => controller.currentSong.value?.id == song.id
                    ? const Icon(Icons.play_arrow, color: AppColors.primary)
                    : const SizedBox.shrink(),
              ),
            );
          },
        );
      }),
    );
  }
}
