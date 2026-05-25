import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mp3player/controllers/player_controller.dart';
import 'package:mp3player/controllers/playlist_controller.dart';
import 'package:mp3player/ui/main_wrapper.dart';
import 'package:on_audio_query/on_audio_query.dart';
import '../controllers/song_controller.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final OnAudioQuery _audioQuery = OnAudioQuery();

  @override
  void initState() {
    super.initState();
    checkPermissionAndLoad();
  }

  Future<void> checkPermissionAndLoad() async {
    // Check and request storage permissions
    bool hasPermission = false;
    try {
      hasPermission = await _audioQuery.permissionsStatus() ?? false;
      if (!hasPermission) {
        hasPermission = await _audioQuery.permissionsRequest() ?? false;
      }
    } catch (e) {
      hasPermission = false;
    }

    if (hasPermission) {
      // Initialize SongController (will load songs automatically)
      Get.put(SongController(), permanent: true);
      Get.put(PlayerController(), permanent: true);
      Get.put(PlaylistController(), permanent: true);
      // Wait a short moment for UI feedback
      await Future.delayed(const Duration(milliseconds: 500));
      Get.offAll(() => const MainWrapper());
    } else {
      // Show permission denied dialog and exit
      Get.dialog(
        AlertDialog(
          title: const Text('Permission Required'),
          content: const Text(
            'This app needs storage permission to access your MP3 files.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Get.back();
                checkPermissionAndLoad(); // retry
              },
              child: const Text('Retry'),
            ),
            TextButton(onPressed: () => Get.back(), child: const Text('Exit')),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.music_note, size: 80, color: Colors.teal),
            SizedBox(height: 24),
            Text('Loading your music...', style: TextStyle(fontSize: 18)),
            SizedBox(height: 16),
            CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
