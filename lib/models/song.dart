class Song {
  final String title;
  final String artist;
  final String filePath;
  final String duration;
  final String artistImage;

  Song({
    required this.title,
    required this.artist,
    required this.filePath,
    required this.duration,
    required this.artistImage,
  });

  /// ================= FIREBASE MAP =================
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'artist': artist,
      'filePath': filePath,
      'duration': duration,
      'artistImage': artistImage,
    };
  }

  factory Song.fromMap(Map<String, dynamic> map) {
    return Song(
      title: map['title'] ?? '',
      artist: map['artist'] ?? '',
      filePath: map['filePath'] ?? '',
      duration: map['duration'] ?? '',
      artistImage: map['artistImage'] ?? '',
    );
  }
}
