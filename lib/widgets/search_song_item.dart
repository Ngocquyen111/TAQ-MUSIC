import 'package:flutter/material.dart';
import '../models/song.dart';

class SearchSongItem extends StatelessWidget {
  final Song song;
  final ValueChanged<Song> onTap;

  const SearchSongItem({
    super.key,
    required this.song,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.music_note, color: Colors.white),
      title: Text(song.title, style: const TextStyle(color: Colors.white)),
      subtitle:
      Text(song.artist, style: const TextStyle(color: Colors.white70)),
      trailing: const Icon(Icons.play_arrow, color: Colors.pink),
      onTap: () => onTap(song),
    );
  }
}

