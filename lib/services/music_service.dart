import 'package:audioplayers/audioplayers.dart';

class MusicService {
  /// SINGLETON
  static final MusicService _instance = MusicService._internal();
  factory MusicService() => _instance;
  MusicService._internal() {
    _listenPlayerState();
  }

  final AudioPlayer _audioPlayer = AudioPlayer();

  String? _currentSongPath;
  bool _isPlaying = false;

  /// GETTERS
  AudioPlayer get audioPlayer => _audioPlayer;
  bool get isPlaying => _isPlaying;
  String? get currentSongPath => _currentSongPath;

  /// ===============================
  /// PLAY SONG
  /// ===============================
  Future<void> play(String songPath) async {
    try {
      // Nếu đang phát đúng bài → pause
      if (_currentSongPath == songPath && _isPlaying) {
        await pause();
        return;
      }

      // Nếu đổi bài khác
      if (_currentSongPath != songPath) {
        await _audioPlayer.stop();
        _currentSongPath = songPath;

        if (songPath.startsWith('http')) {
          // STREAM / URL
          await _audioPlayer.play(UrlSource(songPath));
        } else {
          // ASSET LOCAL
          await _audioPlayer.play(AssetSource(songPath));
        }
      } else {
        // Resume bài cũ
        await _audioPlayer.resume();
      }
    } catch (e) {
      _isPlaying = false;
      print('Play error: $e');
    }
  }

  /// ===============================
  /// PAUSE
  /// ===============================
  Future<void> pause() async {
    await _audioPlayer.pause();
  }

  /// ===============================
  /// STOP
  /// ===============================
  Future<void> stop() async {
    await _audioPlayer.stop();
    _currentSongPath = null;
  }

  /// ===============================
  /// LISTEN PLAYER STATE
  /// ===============================
  void _listenPlayerState() {
    _audioPlayer.onPlayerStateChanged.listen((state) {
      _isPlaying = state == PlayerState.playing;
    });
  }

  /// ===============================
  /// STREAMS (CHO MINI PLAYER)
  /// ===============================
  Stream<Duration> get onPositionChanged =>
      _audioPlayer.onPositionChanged;

  Stream<Duration?> get onDurationChanged =>
      _audioPlayer.onDurationChanged;

  Stream<PlayerState> get onPlayerStateChanged =>
      _audioPlayer.onPlayerStateChanged;
}
