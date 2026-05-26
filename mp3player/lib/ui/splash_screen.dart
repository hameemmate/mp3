import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mp3player/controllers/favorite_controller.dart';
import 'package:mp3player/controllers/player_controller.dart';
import 'package:mp3player/controllers/playlist_controller.dart';
import 'package:mp3player/ui/main_wrapper.dart';
import 'package:mp3player/utilities/theme_controller.dart';
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

// Then in the checkPermissionAndLoad() method, add this line where you initialize other controllers:

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
      // Initialize controllers only if they're not already registered
      if (!Get.isRegistered<SongController>()) {
        Get.put(SongController(), permanent: true);
      }
      if (!Get.isRegistered<PlayerController>()) {
        Get.put(PlayerController(), permanent: true);
      }
      if (!Get.isRegistered<PlaylistController>()) {
        Get.put(PlaylistController(), permanent: true);
      }
      // Add this line to initialize FavoritesController
      if (!Get.isRegistered<FavoritesController>()) {
        Get.put(FavoritesController(), permanent: true);
      }

      // Wait a short moment for UI feedback
      await Future.delayed(const Duration(milliseconds: 500));

      if (mounted) {
        Get.offAll(() => const MainWrapper());
      }
    } else {
      // Show permission denied dialog and exit
      if (mounted) {
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
              TextButton(
                  onPressed: () => Get.back(), child: const Text('Exit')),
            ],
          ),
          barrierDismissible: false,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeController = Get.isRegistered<ThemeController>()
        ? Get.find<ThemeController>()
        : null;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: themeController != null
                ? [themeController.background, themeController.surface]
                : [const Color(0xFF010008), const Color(0xFF0D0025)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: const Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.music_note, size: 80, color: Colors.teal),
              SizedBox(height: 24),
              Text('Loading your music...',
                  style: TextStyle(fontSize: 18, color: Colors.white)),
              SizedBox(height: 16),
              CircularProgressIndicator(),
            ],
          ),
        ),
      ),
    );
  }
}
