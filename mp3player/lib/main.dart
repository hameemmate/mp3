import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mp3player/models/playlist_model.dart';
import 'package:mp3player/service/audio_handler.dart';
import 'package:mp3player/ui/splash_screen.dart';
import 'package:mp3player/utilities/theme_controller.dart';

late AudioHandler audioHandler;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(PlaylistAdapter());
  await Hive.openBox<Playlist>('playlists');

  // Also open theme box
  if (!Hive.isBoxOpen('theme_box')) {
    await Hive.openBox('theme_box');
  }
  audioHandler = await initAudioService();
  // Initialize ThemeController
  await Get.putAsync(() async => ThemeController());

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'MP3 Player',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: Colors.transparent,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: Colors.transparent,
      ),
      themeMode: ThemeMode.dark,
      home: SplashScreen(),
    );
  }
}
