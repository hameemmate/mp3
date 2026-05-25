import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mp3player/ui/play_list_details.dart';
import 'package:mp3player/utilities/colors.dart';
import '../controllers/playlist_controller.dart';

class PlaylistsPage extends StatelessWidget {
  const PlaylistsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final PlaylistController controller = Get.find();

    return Scaffold(
      backgroundColor: Colors.transparent, // Make transparent
      appBar: AppBar(
        backgroundColor: Colors.transparent, // Make transparent
        elevation: 0,
        title: const Text('Playlists',
            style: TextStyle(color: AppColors.textPrimary)),
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: AppColors.textPrimary),
            onPressed: () => _showCreatePlaylistDialog(context, controller),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.playlists.isEmpty) {
          return const Center(
            child: Text('No playlists yet. Tap + to create one.',
                style: TextStyle(color: AppColors.textSecondary)),
          );
        }
        return ListView.builder(
          itemCount: controller.playlists.length,
          itemBuilder: (context, index) {
            final playlist = controller.playlists[index];
            return ListTile(
              leading:
                  const Icon(Icons.playlist_play, color: AppColors.primary),
              title: Text(playlist.name,
                  style: const TextStyle(color: AppColors.textPrimary)),
              subtitle: Text('${playlist.songPaths.length} songs',
                  style: const TextStyle(color: AppColors.textHint)),
              onTap: () => Get.to(() => PlaylistDetailPage(playlist: playlist)),
              trailing: PopupMenuButton<String>(
                color: const Color(0xFF1A0A30),
                onSelected: (value) {
                  if (value == 'delete') {
                    controller.deletePlaylist(playlist.id);
                  }
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'delete',
                    child: Text('Delete',
                        style: TextStyle(color: AppColors.textPrimary)),
                  ),
                ],
              ),
            );
          },
        );
      }),
    );
  }

  void _showCreatePlaylistDialog(
    BuildContext context,
    PlaylistController controller,
  ) {
    final TextEditingController nameController = TextEditingController();
    Get.dialog(
      AlertDialog(
        title: const Text('Create Playlist'),
        content: TextField(
          controller: nameController,
          decoration: const InputDecoration(hintText: 'Playlist name'),
          autofocus: true,
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              if (nameController.text.trim().isNotEmpty) {
                controller.createPlaylist(nameController.text.trim());
                Get.back();
              }
            },
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }
}
