import 'package:audioplayers/audioplayers.dart';

class MusicService {
  static final MusicService _instance = MusicService._internal();
  factory MusicService() => _instance;
  MusicService._internal() {
    _initAudioPlayer();
  }

  final AudioPlayer _audioPlayer = AudioPlayer();

  String? _currentSongPath;
  bool _isPlaying = false;

  void _initAudioPlayer() {
    _audioPlayer.setPlayerMode(PlayerMode.mediaPlayer);

    _audioPlayer.setReleaseMode(ReleaseMode.stop);

    _audioPlayer.setVolume(0.7);
  }

  AudioPlayer get audioPlayer => _audioPlayer;
  bool get isPlaying => _isPlaying;
  String? get currentSongPath => _currentSongPath;

  // Phát nhạc
  Future<void> play(String songPath) async {
    try {
      print('🎵 Trying to play: $songPath');

      if (_currentSongPath == songPath && _isPlaying) {
        print('⏸️ Pausing current song');
        await pause();
        return;
      }

      if (_currentSongPath != songPath) {
        print('🎶 Playing new song: $songPath');
        await _audioPlayer.stop();
        _currentSongPath = songPath;

        await _audioPlayer.play(
          AssetSource(songPath),
          mode: PlayerMode.mediaPlayer,
        );
        print('✅ Started playing');
      } else {
        print('▶️ Resuming');
        await _audioPlayer.resume();
      }

      _isPlaying = true;
    } catch (e) {
      print('❌ Error playing song: $e');
      _isPlaying = false;
    }
  }

  Future<void> pause() async {
    await _audioPlayer.pause();
    _isPlaying = false;
    print('⏸️ Paused');
  }

  Future<void> stop() async {
    await _audioPlayer.stop();
    _isPlaying = false;
    _currentSongPath = null;
    print('⏹️ Stopped');
  }

  Future<void> seek(Duration position) async {
    await _audioPlayer.seek(position);
  }

  Future<void> setVolume(double volume) async {
    await _audioPlayer.setVolume(volume);
  }

  Stream<Duration> get onPositionChanged => _audioPlayer.onPositionChanged;
  Stream<Duration?> get onDurationChanged => _audioPlayer.onDurationChanged;
  Stream<PlayerState> get onPlayerStateChanged => _audioPlayer.onPlayerStateChanged;

  Future<void> dispose() async {
    await _audioPlayer.dispose();
  }
}