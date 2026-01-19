import 'package:flutter/material.dart';
import '../models/song.dart';
import '../services/music_service.dart';

class MiniPlayerBar extends StatefulWidget {
  final Song song;

  const MiniPlayerBar({super.key, required this.song});

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
    // ✅ Lắng nghe thay đổi trạng thái player
    _musicService.onPlayerStateChanged.listen((_) {
      if (mounted) setState(() {});
    });
  }

  // ✅ XỬ LÝ PAUSE/RESUME
  void _togglePlayPause() async {
    if (_musicService.currentSongPath == widget.song.filePath) {
      if (_musicService.isPlaying) {
        await _musicService.pause();
      } else {
        await _musicService.resume();
      }
    } else {
      await _musicService.play(widget.song.filePath);
    }
    // ✅ QUAN TRỌNG: Force update UI
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    // ✅ Lấy trạng thái thật từ MusicService
    final isPlaying = _musicService.currentSongPath == widget.song.filePath &&
        _musicService.isPlaying;

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
                  widget.song.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  widget.song.artist,
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
            onPressed: () => setState(() => isFavorite = !isFavorite),
          ),

          IconButton(
            icon: Icon(
              isDownloaded ? Icons.download_done : Icons.download,
              color: isDownloaded ? Colors.green : Colors.white,
            ),
            onPressed: () => setState(() => isDownloaded = true),
          ),

          // ✅ NÚT PLAY/PAUSE ĐỒNG BỘ
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