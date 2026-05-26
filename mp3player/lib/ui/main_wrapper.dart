// main_wrapper.dart
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mp3player/ui/home.dart';
import 'package:mp3player/ui/playlist_page.dart';
import 'package:mp3player/ui/profile_page.dart';
import 'package:mp3player/ui/queue.dart';
import 'package:mp3player/ui/widgets/mini_play.dart';
import 'package:mp3player/ui/widgets/galaxy_widgets.dart';
import 'package:mp3player/utilities/colors.dart';
import 'package:mp3player/utilities/theme_controller.dart';

class MainWrapper extends StatelessWidget {
  const MainWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Get.find<ThemeController>();
    final RxInt currentIndex = 0.obs;
    final pages = const [
      HomePage(),
      PlaylistsPage(),
      QueuePage(),
      ProfilePage(),
    ];

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        clipBehavior: Clip.none,
        children: [
          GalaxyBackground(
            child: Column(
              children: [
                Expanded(
                  child: Obx(
                    () => IndexedStack(
                      index: currentIndex.value,
                      children: pages,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Obx(() => buttonAndMiniPlayer(currentIndex, theme)),
          ),
        ],
      ),
    );
  }

  Widget buttonAndMiniPlayer(RxInt currentIndex, ThemeController theme) {
    return Column(
      children: [
        const MiniPlayer(),
        SizedBox(
          height: Get.width * .01,
        ),
        _GlassBottomNav(
          currentIndex: currentIndex.value,
          onTap: (i) => currentIndex.value = i,
          theme: theme.current,
        ),
      ],
    );
  }
}

class _GlassBottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  final AppTheme theme;

  const _GlassBottomNav({
    required this.currentIndex,
    required this.onTap,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    final items = const [
      _NavItem(icon: Icons.home_rounded, label: 'Home'),
      _NavItem(icon: Icons.library_music_rounded, label: 'Playlists'),
      _NavItem(icon: Icons.queue_music_rounded, label: 'Queue'),
      _NavItem(icon: Icons.person_rounded, label: 'Profile'),
    ];

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
          child: Container(
            decoration: BoxDecoration(
              color: theme.glassLight,
              borderRadius: BorderRadius.circular(28),
              border: Border.all(color: theme.glassBorder),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(items.length, (i) {
                final active = i == currentIndex;
                return GestureDetector(
                  onTap: () => onTap(i),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    curve: Curves.easeInOut,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: active
                          ? theme.primary.withOpacity(0.15)
                          : Colors.transparent,
                      border: active
                          ? Border.all(color: theme.primary.withOpacity(0.3))
                          : null,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          items[i].icon,
                          size: 22,
                          color: active ? theme.primary : theme.textHint,
                        ),
                        const SizedBox(height: 3),
                        Text(
                          items[i].label,
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight:
                                active ? FontWeight.w600 : FontWeight.w400,
                            color: active ? theme.primary : theme.textHint,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}

class _NavItem {
  final IconData icon;
  final String label;
  const _NavItem({required this.icon, required this.label});
}
