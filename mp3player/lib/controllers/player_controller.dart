import 'package:get/get.dart';
import 'package:audio_service/audio_service.dart';
import 'package:just_audio/just_audio.dart';
import 'package:mp3player/service/audio_handler.dart';
import 'package:on_audio_query/on_audio_query.dart';
import '../main.dart';

class PlayerController extends GetxController {
  MyAudioHandler get _handler => audioHandler as MyAudioHandler;
  AudioPlayer get _player => _handler.player;

  final Rx<SongModel?> currentSong = Rx<SongModel?>(null);
  final RxBool isPlaying = false.obs;
  final Rx<Duration> position = Duration.zero.obs;
  final Rx<Duration> duration = Duration.zero.obs;
  final RxList<SongModel> queue = <SongModel>[].obs;
  final RxBool isShuffleOn = false.obs;

  @override
  void onInit() {
    super.onInit();
    _player.positionStream.listen((p) => position.value = p);
    _player.durationStream.listen((d) => duration.value = d ?? Duration.zero);
    _player.playingStream.listen((v) => isPlaying.value = v);
    _player.shuffleModeEnabledStream.listen((v) => isShuffleOn.value = v);
    _player.currentIndexStream.listen((index) {
      if (index != null && queue.isNotEmpty && index < queue.length) {
        currentSong.value = queue[index];
      }
    });
  }

  Future<void> playSong(SongModel song) async {
    queue.assignAll([song]);
    currentSong.value = song;
    await _handler.playSongs([song]);
  }

  Future<void> playPlaylist(List<SongModel> songs, {int startIndex = 0}) async {
    queue.assignAll(songs);
    currentSong.value = songs[startIndex];
    await _handler.playSongs(songs, startIndex: startIndex);
  }

  Future<void> addToQueue(SongModel song) async {
    queue.add(song);
    await _handler.addSongToQueue(song);
  }

  void toggleShuffle() async {
    final newMode = !isShuffleOn.value;
    await _handler.setShuffleMode(
      newMode ? AudioServiceShuffleMode.all : AudioServiceShuffleMode.none,
    );
  }

  void playPause() => _player.playing ? _handler.pause() : _handler.play();
  void seekTo(Duration pos) => _handler.seek(pos);
  void next() => _handler.skipToNext();
  void previous() => _handler.skipToPrevious();

  @override
  void onClose() {
    _handler.stop();
    super.onClose();
  }
}
