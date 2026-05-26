// playlist_page.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mp3player/ui/play_list_details.dart';
import 'package:mp3player/utilities/colors.dart';
import 'package:mp3player/utilities/theme_controller.dart';
import '../controllers/playlist_controller.dart';

class PlaylistsPage extends StatelessWidget {
  const PlaylistsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final PlaylistController controller = Get.find();
    final theme = Get.find<ThemeController>();

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text('Playlists', style: TextStyle(color: theme.textPrimary)),
        actions: [
          IconButton(
            icon: Icon(Icons.add, color: theme.textPrimary),
            onPressed: () =>
                _showCreatePlaylistDialog(context, controller, theme),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.playlists.isEmpty) {
          return Center(
            child: Text('No playlists yet. Tap + to create one.',
                style: TextStyle(color: theme.textSecondary)),
          );
        }
        return ListView.builder(
          itemCount: controller.playlists.length,
          itemBuilder: (context, index) {
            final playlist = controller.playlists[index];
            return ListTile(
              leading: Icon(Icons.playlist_play, color: theme.primary),
              title: Text(playlist.name,
                  style: TextStyle(color: theme.textPrimary)),
              subtitle: Text('${playlist.songPaths.length} songs',
                  style: TextStyle(color: theme.textHint)),
              onTap: () => Get.to(() => PlaylistDetailPage(playlist: playlist)),
              trailing: PopupMenuButton<String>(
                color: theme.card,
                onSelected: (value) {
                  if (value == 'delete') {
                    controller.deletePlaylist(playlist.id);
                  }
                },
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: 'delete',
                    child: Text('Delete',
                        style: TextStyle(color: theme.textPrimary)),
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
    ThemeController theme,
  ) {
    final TextEditingController nameController = TextEditingController();
    Get.dialog(
      AlertDialog(
        backgroundColor: theme.card,
        title:
            Text('Create Playlist', style: TextStyle(color: theme.textPrimary)),
        content: TextField(
          controller: nameController,
          style: TextStyle(color: theme.textPrimary),
          decoration: InputDecoration(
            hintText: 'Playlist name',
            hintStyle: TextStyle(color: theme.textHint),
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('Cancel', style: TextStyle(color: theme.textHint)),
          ),
          TextButton(
            onPressed: () {
              if (nameController.text.trim().isNotEmpty) {
                controller.createPlaylist(nameController.text.trim());
                Get.back();
              }
            },
            child: Text('Create', style: TextStyle(color: theme.primary)),
          ),
        ],
      ),
    );
  }
}
