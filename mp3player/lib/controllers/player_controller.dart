import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:on_audio_query/on_audio_query.dart';

class PlayerController extends GetxController {
  final AudioPlayer _player = AudioPlayer();
  final Rx<SongModel?> currentSong = Rx<SongModel?>(null);
  final RxBool isPlaying = false.obs;
  final Rx<Duration> position = Duration.zero.obs;
  final Rx<Duration> duration = Duration.zero.obs;
  final RxList<SongModel> queue = <SongModel>[].obs;
  final RxBool isShuffleOn = false.obs;
  ConcatenatingAudioSource? _audioSource;

  @override
  void onInit() {
    super.onInit();
    _player.positionStream.listen((p) => position.value = p);
    _player.durationStream.listen((d) => duration.value = d ?? Duration.zero);
    _player.playingStream.listen((playing) => isPlaying.value = playing);
    _player.currentIndexStream.listen((index) {
      if (index != null && queue.isNotEmpty && index < queue.length) {
        currentSong.value = queue[index];
      }
    });
    // Sync shuffle state from the player
    _player.shuffleModeEnabledStream.listen((enabled) {
      isShuffleOn.value = enabled;
    });
  }

  Future<void> playSong(SongModel song) async {
    queue.clear();
    queue.add(song);
    await _setAudioSource([song]);
    _player.play();
  }

  Future<void> playPlaylist(List<SongModel> songs, {int startIndex = 0}) async {
    queue.assignAll(songs);
    await _setAudioSource(songs, initialIndex: startIndex);
    _player.play();
  }

  Future<void> _setAudioSource(List<SongModel> songs,
      {int initialIndex = 0}) async {
    final audioSources = songs.map((s) => AudioSource.file(s.data)).toList();
    _audioSource = ConcatenatingAudioSource(children: audioSources);
    await _player.setAudioSource(_audioSource!, initialIndex: initialIndex);
  }

  Future<void> addToQueue(SongModel song) async {
    if (_audioSource == null) {
      await playSong(song);
      return;
    }
    queue.add(song);
    await _audioSource!.add(AudioSource.file(song.data));
  }

  void toggleShuffle() async {
    final newMode = !isShuffleOn.value;
    await _player.setShuffleModeEnabled(newMode);
    // isShuffleOn is automatically updated via the stream
  }

  void playPause() {
    if (_player.playing) {
      _player.pause();
    } else {
      _player.play();
    }
  }

  void seekTo(Duration position) {
    _player.seek(position);
  }

  void next() {
    if (_player.hasNext) {
      _player.seekToNext();
    }
  }

  void previous() {
    if (_player.hasPrevious) {
      _player.seekToPrevious();
    }
  }

  @override
  void onClose() {
    _player.dispose();
    super.onClose();
  }
}
