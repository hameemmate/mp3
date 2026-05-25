import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:mp3player/models/playlist_model.dart';

class PlaylistController extends GetxController {
  late Box<Playlist> _playlistBox;
  final RxList<Playlist> playlists = <Playlist>[].obs;

  @override
  void onInit() {
    super.onInit();
    _playlistBox = Hive.box<Playlist>('playlists');
    loadPlaylists();
  }

  void loadPlaylists() {
    playlists.assignAll(_playlistBox.values.toList());
  }

  void createPlaylist(String name) {
    final id = DateTime.now().millisecondsSinceEpoch.toString();
    final playlist = Playlist(id: id, name: name, songPaths: []);
    _playlistBox.put(id, playlist);
    loadPlaylists();
  }

  void deletePlaylist(String id) {
    _playlistBox.delete(id);
    loadPlaylists();
  }

  void renamePlaylist(String id, String newName) {
    final playlist = _playlistBox.get(id);
    if (playlist != null) {
      playlist.name = newName;
      playlist.save();
      loadPlaylists();
    }
  }

  void addSongToPlaylist(String playlistId, String songPath) {
    final playlist = _playlistBox.get(playlistId);
    if (playlist != null && !playlist.songPaths.contains(songPath)) {
      playlist.songPaths.add(songPath);
      playlist.save();
      loadPlaylists(); // Refresh the observable list
    }
  }

  void removeSongFromPlaylist(String playlistId, String songPath) {
    final playlist = _playlistBox.get(playlistId);
    if (playlist != null) {
      playlist.songPaths.remove(songPath);
      playlist.save();
      loadPlaylists();
    }
  }

  Playlist? getPlaylistById(String id) => _playlistBox.get(id);
}
