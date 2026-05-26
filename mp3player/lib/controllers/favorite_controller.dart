// controllers/favorites_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:on_audio_query/on_audio_query.dart';

class FavoritesController extends GetxController {
  static const String _favoritesBoxName = 'favorites_box';
  late Box _favoritesBox;
  final RxSet<int> favoriteIds = <int>{}.obs;

  @override
  void onInit() async {
    super.onInit();
    await _initHive();
    await _loadFavorites();
  }

  Future<void> _initHive() async {
    try {
      if (!Hive.isBoxOpen(_favoritesBoxName)) {
        _favoritesBox = await Hive.openBox(_favoritesBoxName);
      } else {
        _favoritesBox = Hive.box(_favoritesBoxName);
      }
      debugPrint('✅ Favorites box opened successfully');
    } catch (e) {
      debugPrint('❌ Error opening favorites box: $e');
    }
  }

  Future<void> _loadFavorites() async {
    try {
      final List<int>? saved = _favoritesBox.get('favorite_songs');
      if (saved != null) {
        favoriteIds.addAll(saved);
        debugPrint('✅ Loaded ${favoriteIds.length} favorites');
      } else {
        debugPrint('📱 No saved favorites found');
      }
    } catch (e) {
      debugPrint('❌ Error loading favorites: $e');
    }
  }

  Future<void> saveFavorites() async {
    try {
      await _favoritesBox.put('favorite_songs', favoriteIds.toList());
      debugPrint('💾 Saved ${favoriteIds.length} favorites');
    } catch (e) {
      debugPrint('❌ Error saving favorites: $e');
    }
  }

  bool isFavorite(int songId) {
    return favoriteIds.contains(songId);
  }

  Future<void> toggleFavorite(int songId) async {
    if (favoriteIds.contains(songId)) {
      favoriteIds.remove(songId);
      debugPrint('⭐ Removed song $songId from favorites');
    } else {
      favoriteIds.add(songId);
      debugPrint('⭐ Added song $songId to favorites');
    }
    await saveFavorites();
  }

  List<SongModel> getFavoriteSongs(List<SongModel> allSongs) {
    return allSongs.where((song) => favoriteIds.contains(song.id)).toList();
  }

  int get favoriteCount => favoriteIds.length;

  @override
  void onClose() {
    _favoritesBox.close();
    super.onClose();
  }
}
