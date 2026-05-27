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

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  final OnAudioQuery _audioQuery = OnAudioQuery();

  late AnimationController _logoController;
  late AnimationController _textController;
  late Animation<double> _fadeAnim;
  late Animation<double> _scaleAnim;
  late Animation<double> _textFadeAnim;
  late Animation<Offset> _textSlideAnim;

  @override
  void initState() {
    super.initState();

    // Logo animation: fade + scale
    _logoController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _fadeAnim = CurvedAnimation(parent: _logoController, curve: Curves.easeIn);
    _scaleAnim = Tween<double>(begin: 0.75, end: 1.0).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.elasticOut),
    );

    // Text animation: fade + slide up
    _textController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _textFadeAnim =
        CurvedAnimation(parent: _textController, curve: Curves.easeIn);
    _textSlideAnim = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _textController, curve: Curves.easeOut),
    );

    // Start logo anim, then text anim
    _logoController.forward().then((_) {
      _textController.forward();
    });

    checkPermissionAndLoad();
  }

  @override
  void dispose() {
    _logoController.dispose();
    _textController.dispose();
    super.dispose();
  }

  Future<void> checkPermissionAndLoad() async {
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
      if (!Get.isRegistered<SongController>()) {
        Get.put(SongController(), permanent: true);
      }
      if (!Get.isRegistered<PlayerController>()) {
        Get.put(PlayerController(), permanent: true);
      }
      if (!Get.isRegistered<PlaylistController>()) {
        Get.put(PlaylistController(), permanent: true);
      }
      if (!Get.isRegistered<FavoritesController>()) {
        Get.put(FavoritesController(), permanent: true);
      }

      // Min 2s so animation plays fully
      await Future.delayed(const Duration(milliseconds: 2000));

      if (mounted) {
        Get.offAll(() => const MainWrapper());
      }
    } else {
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
                  checkPermissionAndLoad();
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
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // ── Animated Logo ──────────────────────────
              ScaleTransition(
                scale: _scaleAnim,
                child: FadeTransition(
                  opacity: _fadeAnim,
                  child: Image.asset(
                    'assets/images/logo.png',
                    width: 200,
                    height: 200,
                    fit: BoxFit.contain,
                  ),
                ),
              ),

              const SizedBox(height: 28),

              // ── Animated App Name + tagline ────────────
              FadeTransition(
                opacity: _textFadeAnim,
                child: SlideTransition(
                  position: _textSlideAnim,
                  child: Column(
                    children: [
                      Text(
                        'WATT MUSIC PLAYER',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                          letterSpacing: 3,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Your Music. Your Watt.',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.white54,
                          letterSpacing: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 60),

              // ── Loading indicator ──────────────────────
              FadeTransition(
                opacity: _textFadeAnim,
                child: SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      themeController?.primary ?? Colors.teal,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
