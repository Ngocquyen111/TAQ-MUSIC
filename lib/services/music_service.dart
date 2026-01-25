import 'package:audioplayers/audioplayers.dart';

class MusicService {
  static final MusicService _instance = MusicService._internal();
  factory MusicService() => _instance;

  MusicService._internal() {
    _listenPlayerState();
  }

  final AudioPlayer _audioPlayer = AudioPlayer();

  String? _currentSongPath;
  bool _isPlaying = false;

  AudioPlayer get audioPlayer => _audioPlayer;
  bool get isPlaying => _isPlaying;
  String? get currentSongPath => _currentSongPath;

  // ================== PLAY (FIX DUY NHẤT Ở ĐÂY) ==================
  Future<void> play(String songPath) async {
    try {
      // 🔥 cùng bài
      if (_currentSongPath == songPath) {
        if (_isPlaying) {
          await pause(); // toggle → pause
        } else {
          await resume(); // toggle → resume
        }
        return;
      }

      // 🔥 khác bài → play mới
      await _audioPlayer.stop();
      _currentSongPath = songPath;

      if (songPath.startsWith('http')) {
        await _audioPlayer.play(UrlSource(songPath));
      } else {
        await _audioPlayer.play(AssetSource(songPath));
      }

      _isPlaying = true;
    } catch (e) {
      _isPlaying = false;
      print('Play error: $e');
    }
  }

  // ================== PAUSE ==================
  Future<void> pause() async {
    await _audioPlayer.pause();
    _isPlaying = false;
  }

  // ================== RESUME ==================
  Future<void> resume() async {
    await _audioPlayer.resume();
    _isPlaying = true;
  }

  // ================== STOP ==================
  Future<void> stop() async {
    await _audioPlayer.stop();
    _currentSongPath = null;
    _isPlaying = false;
  }

  // ================== LISTEN ==================
  void _listenPlayerState() {
    _audioPlayer.onPlayerStateChanged.listen((state) {
      _isPlaying = state == PlayerState.playing;
    });
  }

  // ================== STREAM ==================
  Stream<Duration> get onPositionChanged =>
      _audioPlayer.onPositionChanged;

  Stream<Duration?> get onDurationChanged =>
      _audioPlayer.onDurationChanged;

  Stream<PlayerState> get onPlayerStateChanged =>
      _audioPlayer.onPlayerStateChanged;
}
