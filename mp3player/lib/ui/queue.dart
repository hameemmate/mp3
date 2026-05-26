// queue.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mp3player/ui/widgets/song_tile.dart';
import 'package:mp3player/utilities/colors.dart';
import 'package:mp3player/utilities/theme_controller.dart';
import '../controllers/player_controller.dart';

class QueuePage extends StatelessWidget {
  const QueuePage({super.key});

  @override
  Widget build(BuildContext context) {
    final PlayerController controller = Get.find();
    final theme = Get.find<ThemeController>();

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title:
            Text('Current Queue', style: TextStyle(color: theme.textPrimary)),
      ),
      body: Obx(() {
        if (controller.queue.isEmpty) {
          return Center(
            child: Text('Queue is empty',
                style: TextStyle(color: theme.textSecondary)),
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
                    ? Icon(Icons.play_arrow, color: theme.primary)
                    : const SizedBox.shrink(),
              ),
            );
          },
        );
      }),
    );
  }
}
