import '../models/song.dart';

class LocalMusicStore {
  static final List<Song> downloadedSongs = [];
  static final List<Song> favoriteSongs = [];
  static final List<Song> recentSongs = [];

  // ===== DOWNLOAD =====
  static void addDownload(Song song) {
    if (!downloadedSongs.any((s) => s.filePath == song.filePath)) {
      downloadedSongs.add(song);
    }
  }

  // ===== FAVORITE =====
  static void addFavorite(Song song) {
    if (!favoriteSongs.any((s) => s.filePath == song.filePath)) {
      favoriteSongs.add(song);
    }
  }

  static void removeFavorite(Song song) {
    favoriteSongs.removeWhere((s) => s.filePath == song.filePath);
  }

  // ===== RECENT =====
  static void addRecent(Song song) {
    recentSongs.removeWhere((s) => s.filePath == song.filePath);
    recentSongs.insert(0, song);

    if (recentSongs.length > 20) {
      recentSongs.removeLast();
    }
  }
}
