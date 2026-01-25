import 'package:flutter/material.dart';
import '../services/music_service.dart';
import '../models/song.dart';
import '../data/local_music_store.dart';
import 'package:audioplayers/audioplayers.dart';

class MiniPlayerBar extends StatefulWidget {
  const MiniPlayerBar({super.key});

  @override
  State<MiniPlayerBar> createState() => _MiniPlayerBarState();
}

class _MiniPlayerBarState extends State<MiniPlayerBar> {
  final MusicService _musicService = MusicService();

  bool isFavorite = false;
  bool isDownloaded = false;

  @override
  void initState() {
    super.initState();


    _musicService.audioPlayer.onPlayerStateChanged.listen((state) {
      if (!mounted) return;

      final song = _musicService.currentSong;
      if (song != null) {
        isFavorite = LocalMusicStore.favoriteSongs
            .any((s) => s.filePath == song.filePath);

        isDownloaded = LocalMusicStore.downloadedSongs
            .any((s) => s.filePath == song.filePath);
      }

      setState(() {});
    });
  }

  void _togglePlayPause() async {
    if (_musicService.isPlaying) {
      await _musicService.pause();
    } else {
      await _musicService.resume();
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final Song? song = _musicService.currentSong;

    if (song == null) return const SizedBox.shrink();

    final isPlaying = _musicService.isPlaying;

    return Container(
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: const BoxDecoration(
        color: Color(0xFF7A0019),
        borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
      ),
      child: Row(
        children: [
          const Icon(Icons.music_note, color: Colors.white),
          const SizedBox(width: 8),

          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  song.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  song.artist,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.grey[300],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),

          IconButton(
            icon: Icon(
              isFavorite ? Icons.favorite : Icons.favorite_border,
              color: isFavorite ? Colors.pink : Colors.white,
            ),
            onPressed: () {
              setState(() {
                if (isFavorite) {
                  LocalMusicStore.removeFavorite(song);
                } else {
                  LocalMusicStore.addFavorite(song);
                }
                isFavorite = !isFavorite;
              });
            },
          ),

          IconButton(
            icon: Icon(
              isDownloaded ? Icons.download_done : Icons.download,
              color: isDownloaded ? Colors.green : Colors.white,
            ),
            onPressed: () {
              setState(() {
                if (isDownloaded) {
                  LocalMusicStore.removeDownload(song);
                } else {
                  LocalMusicStore.addDownload(song);
                }
                isDownloaded = !isDownloaded;
              });
            },
          ),

          IconButton(
            icon: Icon(
              isPlaying ? Icons.pause : Icons.play_arrow,
              color: Colors.pinkAccent,
              size: 28,
            ),
            onPressed: _togglePlayPause,
          ),
        ],
      ),
    );
  }
}
