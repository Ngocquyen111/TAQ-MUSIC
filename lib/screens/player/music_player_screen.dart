import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';

class MusicPlayerScreen extends StatelessWidget {
  const MusicPlayerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 240,
            height: 240,
            decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Icon(Icons.music_note,
                size: 100, color: Colors.white),
          ),
          const SizedBox(height: 30),
          const Text("Hồng Nhan",
              style: TextStyle(fontSize: 22, color: Colors.white)),
          const Text("Jack",
              style: TextStyle(color: Colors.white70)),
          const SizedBox(height: 30),
          const Icon(Icons.play_circle,
              size: 80, color: Colors.pink),
        ],
      ),
    );
  }
}
