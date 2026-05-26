import 'package:audio_service/audio_service.dart';
import 'package:just_audio/just_audio.dart';
import 'package:on_audio_query/on_audio_query.dart';

Future<AudioHandler> initAudioService() {
  return AudioService.init(
    builder: () => MyAudioHandler(),
    config: const AudioServiceConfig(
      androidNotificationChannelId: 'com.yourapp.mp3player.channel',
      androidNotificationChannelName: 'Music Playback',
      androidNotificationOngoing: true,
      androidStopForegroundOnPause: true,
    ),
  );
}

class MyAudioHandler extends BaseAudioHandler with QueueHandler, SeekHandler {
  final _player = AudioPlayer();
  ConcatenatingAudioSource? _playlist;

  MyAudioHandler() {
    _player.playbackEventStream.map(_transformEvent).pipe(playbackState);

    _player.currentIndexStream.listen((index) {
      if (index != null &&
          queue.value.isNotEmpty &&
          index < queue.value.length) {
        mediaItem.add(queue.value[index]);
        final d = _player.duration;
        if (d != null && d > Duration.zero) {
          mediaItem.add(queue.value[index].copyWith(duration: d));
        }
      }
    });

    _player.durationStream.listen((d) {
      if (d == null || d == Duration.zero) return;
      final current = mediaItem.value;
      if (current != null) {
        final updated = current.copyWith(duration: d);
        mediaItem.add(updated);
        final idx = queue.value.indexWhere((m) => m.id == current.id);
        if (idx != -1) {
          final newQueue = [...queue.value];
          newQueue[idx] = updated;
          queue.add(newQueue);
        }
      }
    });
  }

  Future<void> playSongs(List<SongModel> songs, {int startIndex = 0}) async {
    final _audioQuery = OnAudioQuery();

    // Build MediaItems WITHOUT waiting for artwork (non-blocking)
    final items = songs
        .map((s) => MediaItem(
              id: s.data,
              title: s.displayNameWOExt,
              artist: s.artist ?? 'Unknown',
              album: s.album ?? '',
              extras: {'songId': s.id},
            ))
        .toList();

    queue.add(items);
    mediaItem.add(items[startIndex]);

    final sources = songs.map((s) => AudioSource.file(s.data)).toList();
    _playlist = ConcatenatingAudioSource(children: sources);
    await _player.setAudioSource(_playlist!, initialIndex: startIndex);
    play();

    // Fetch artwork AFTER playback starts (background, no await)
    _updateArtwork(songs, items, _audioQuery);
  }

  Future<void> _updateArtwork(
    List<SongModel> songs,
    List<MediaItem> items,
    OnAudioQuery audioQuery,
  ) async {
    await Future.delayed(const Duration(milliseconds: 800)); // let DB settle
    for (int i = 0; i < songs.length; i++) {
      try {
        final artBytes =
            await audioQuery.queryArtwork(songs[i].id, ArtworkType.AUDIO);
        if (artBytes != null) {
          final updated = items[i].copyWith(
            artUri: Uri.dataFromBytes(artBytes, mimeType: 'image/jpeg'),
          );
          final newQueue = [...queue.value];
          newQueue[i] = updated;
          queue.add(newQueue);
          if (mediaItem.value?.id == items[i].id) {
            mediaItem.add(updated);
          }
        }
      } catch (_) {}
      await Future.delayed(const Duration(milliseconds: 50)); // throttle
    }
  }

  Future<void> addSongToQueue(SongModel song) async {
    final item = MediaItem(
      id: song.data,
      title: song.displayNameWOExt,
      artist: song.artist ?? 'Unknown',
    );
    final newQueue = [...queue.value, item];
    queue.add(newQueue);
    await _playlist?.add(AudioSource.file(song.data));
  }

  AudioPlayer get player => _player;

  PlaybackState _transformEvent(PlaybackEvent event) {
    return PlaybackState(
      controls: [
        MediaControl.skipToPrevious,
        if (_player.playing) MediaControl.pause else MediaControl.play,
        MediaControl.skipToNext,
      ],
      systemActions: {
        MediaAction.seek,
        MediaAction.seekForward,
        MediaAction.seekBackward,
      },
      androidCompactActionIndices: const [0, 1, 2],
      processingState: {
        ProcessingState.idle: AudioProcessingState.idle,
        ProcessingState.loading: AudioProcessingState.loading,
        ProcessingState.buffering: AudioProcessingState.buffering,
        ProcessingState.ready: AudioProcessingState.ready,
        ProcessingState.completed: AudioProcessingState.completed,
      }[_player.processingState]!,
      playing: _player.playing,
      updatePosition: _player.position,
      bufferedPosition: _player.bufferedPosition,
      speed: _player.speed,
      updateTime: DateTime.now(), // ← add this
    );
  }

  @override
  Future<void> play() => _player.play();
  @override
  Future<void> pause() => _player.pause();
  @override
  Future<void> seek(Duration pos) => _player.seek(pos);
  @override
  Future<void> skipToNext() => _player.seekToNext();
  @override
  Future<void> skipToPrevious() => _player.seekToPrevious();
  @override
  Future<void> setShuffleMode(AudioServiceShuffleMode mode) async {
    await _player.setShuffleModeEnabled(mode == AudioServiceShuffleMode.all);
  }

  @override
  Future<void> stop() async {
    await _player.stop();
    return super.stop();
  }
}
