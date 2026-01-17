import 'package:flutter/material.dart';
import '../models/song.dart';

class MiniPlayerBar extends StatefulWidget {
  final Song song;

  const MiniPlayerBar({super.key, required this.song});

  @override
  State<MiniPlayerBar> createState() => _MiniPlayerBarState();
}

class _MiniPlayerBarState extends State<MiniPlayerBar> {
  bool isPlaying = true;
  bool isFavorite = false;
  bool isDownloaded = false;

  @override
  Widget build(BuildContext context) {
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
            child: Text(
              widget.song.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: Colors.white),
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

          IconButton(
            icon: Icon(
              isPlaying ? Icons.pause : Icons.play_arrow,
              color: Colors.pinkAccent,
            ),
            onPressed: () => setState(() => isPlaying = !isPlaying),
          ),
        ],
      ),
    );
  }
}
