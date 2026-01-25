import 'package:audioplayers/audioplayers.dart';
import '../models/song.dart';

class MusicService {
  static final MusicService _instance = MusicService._internal();
  factory MusicService() => _instance;

  MusicService._internal() {
    _listenPlayerState();
  }

  final AudioPlayer _audioPlayer = AudioPlayer();

  String? _currentSongPath;
  Song? _currentSong; // 🔥 THÊM
  bool _isPlaying = false;

  AudioPlayer get audioPlayer => _audioPlayer;
  bool get isPlaying => _isPlaying;
  String? get currentSongPath => _currentSongPath;
  Song? get currentSong => _currentSong; // 🔥 THÊM

  // ================== FAVORITE & DOWNLOAD (GIỮ NGUYÊN) ==================

  final List<Song> _favoriteSongs = [];
  final List<Song> _downloadedSongs = [];

  List<Song> get favoriteSongs => _favoriteSongs;
  List<Song> get downloadedSongs => _downloadedSongs;

  bool isFavorite(Song song) =>
      _favoriteSongs.any((s) => s.filePath == song.filePath);

  bool isDownloaded(Song song) =>
      _downloadedSongs.any((s) => s.filePath == song.filePath);

  void toggleFavorite(Song song) {
    if (isFavorite(song)) {
      _favoriteSongs.removeWhere(
            (s) => s.filePath == song.filePath,
      );
    } else {
      _favoriteSongs.add(song);
    }
  }

  void downloadSong(Song song) {
    if (!isDownloaded(song)) {
      _downloadedSongs.add(song);
    }
  }

  // ================== 🔥 PLAY BẰNG SONG (THÊM) ==================
  Future<void> playSong(Song song) async {
    _currentSong = song;
    await play(song.filePath);
  }

  // ================== PLAY (GIỮ NGUYÊN) ==================
  Future<void> play(String songPath) async {
    try {
      // 🔁 cùng bài
      if (_currentSongPath == songPath) {
        if (_isPlaying) {
          await pause();
        } else {
          await resume();
        }
        return;
      }

      // ▶️ khác bài
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

  // ================== PAUSE (GIỮ NGUYÊN) ==================
  Future<void> pause() async {
    await _audioPlayer.pause();
    _isPlaying = false;
  }

  // ================== RESUME (GIỮ NGUYÊN) ==================
  Future<void> resume() async {
    await _audioPlayer.resume();
    _isPlaying = true;
  }

  // ================== STOP (GIỮ NGUYÊN) ==================
  Future<void> stop() async {
    await _audioPlayer.stop();
    _currentSongPath = null;
    _currentSong = null; // 🔥 THÊM
    _isPlaying = false;
  }

  // ================== LISTEN (GIỮ NGUYÊN) ==================
  void _listenPlayerState() {
    _audioPlayer.onPlayerStateChanged.listen((state) {
      _isPlaying = state == PlayerState.playing;
    });
  }

  // ================== STREAM (GIỮ NGUYÊN) ==================
  Stream<Duration> get onPositionChanged =>
      _audioPlayer.onPositionChanged;

  Stream<Duration?> get onDurationChanged =>
      _audioPlayer.onDurationChanged;

  Stream<PlayerState> get onPlayerStateChanged =>
      _audioPlayer.onPlayerStateChanged;
}
