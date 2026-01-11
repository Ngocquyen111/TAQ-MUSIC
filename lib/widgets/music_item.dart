import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class MusicItem extends StatelessWidget {
  final String title;
  final String artist;

  const MusicItem({
    super.key,
    required this.title,
    required this.artist,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Icon(Icons.music_note, color: Colors.white),
      ),
      title: Text(title, style: const TextStyle(color: Colors.white)),
      subtitle:
      Text(artist, style: const TextStyle(color: AppColors.textSub)),
      trailing:
      const Icon(Icons.play_arrow, color: Colors.white),
    );
  }
}
