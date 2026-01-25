import 'package:audioplayers/audioplayers.dart';
import '../models/song.dart';
import '../data/local_music_store.dart';

class MusicService {
  static final MusicService _instance = MusicService._internal();
  factory MusicService() => _instance;

  MusicService._internal() {
    _listenPlayerState();
  }

  final AudioPlayer _audioPlayer = AudioPlayer();

  String? _currentSongPath;
  Song? _currentSong;
  bool _isPlaying = false;

  AudioPlayer get audioPlayer => _audioPlayer;
  bool get isPlaying => _isPlaying;
  String? get currentSongPath => _currentSongPath;
  Song? get currentSong => _currentSong;

  // ================== FAVORITE & DOWNLOAD  ==================

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


  Future<void> playSong(Song song) async {
    _currentSong = song;

    LocalMusicStore.addRecent(song);

    await play(song.filePath);
  }

  // ================== PLAY  ==================
  Future<void> play(String songPath) async {
    try {
      //  cùng bài
      if (_currentSongPath == songPath) {
        if (_isPlaying) {
          await pause();
        } else {
          await resume();
        }
        return;
      }

      // khác bài
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

  // ================== PAUSE  ==================
  Future<void> pause() async {
    await _audioPlayer.pause();
    _isPlaying = false;
  }

  // ================== RESUME ==================
  Future<void> resume() async {
    await _audioPlayer.resume();
    _isPlaying = true;
  }

  // ================== STOP  ==================
  Future<void> stop() async {
    await _audioPlayer.stop();
    _currentSongPath = null;
    _currentSong = null;
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
