import 'dart:typed_data';
import 'package:get/get.dart';
import 'package:on_audio_query/on_audio_query.dart';

class SongController extends GetxController {
  final OnAudioQuery _audioQuery = OnAudioQuery();
  final RxList<SongModel> allSongs = <SongModel>[].obs;
  final RxBool isLoading = true.obs;
  final RxString searchQuery = ''.obs; // <-- reactive search query

  @override
  void onInit() {
    super.onInit();
    loadSongs();
  }

  // Filtered songs that react to searchQuery
  List<SongModel> get filteredSongs {
    final query = searchQuery.value.toLowerCase().trim();
    if (query.isEmpty) return allSongs;
    return allSongs.where((song) {
      return song.displayNameWOExt.toLowerCase().contains(query) ||
          (song.artist ?? '').toLowerCase().contains(query);
    }).toList();
  }

  Future<void> loadSongs() async {
    isLoading.value = true;
    try {
      final songs = await _audioQuery.querySongs(
        sortType: SongSortType.DISPLAY_NAME,
        orderType: OrderType.ASC_OR_SMALLER,
        uriType: UriType.EXTERNAL,
        ignoreCase: true,
      );
      allSongs.assignAll(songs);
    } catch (e) {
      print('Error loading songs: $e');
    }
    isLoading.value = false;
  }

  SongModel? getSongByPath(String path) {
    try {
      return allSongs.firstWhere((s) => s.data == path);
    } catch (_) {
      return null;
    }
  }

  // Corrected: accepts the song's integer ID, returns raw image bytes.
  Future<Uint8List?> getAlbumArt(int id) async {
    try {
      return await _audioQuery.queryArtwork(
        id, // integer song ID
        ArtworkType.AUDIO,
      );
    } catch (_) {
      return null;
    }
  }
}
