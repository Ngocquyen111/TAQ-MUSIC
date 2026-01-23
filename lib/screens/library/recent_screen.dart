import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../models/song.dart';
import '../home/artist_detail_screen.dart';

class RecentScreen extends StatelessWidget {
  const RecentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final songs = MusicStore.recentSongs;

    return Scaffold(
      backgroundColor: const Color(0xFF4A0000),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text("Gần đây"),
      ),
      body: songs.isEmpty
          ? const Center(
        child: Text(
          "Chưa nghe bài hát nào",
          style: TextStyle(color: Colors.white70),
        ),
      )
          : ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: songs.length,
        itemBuilder: (context, index) {
          final song = songs[index];
          return _songItem(context, song);
        },
      ),
    );
  }

  Widget _songItem(BuildContext context, Song song) {
    return InkWell(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Row(
          children: [
            const CircleAvatar(
              radius: 22,
              backgroundColor: Colors.white24,
              child: Icon(Icons.history, color: Colors.white),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    song.title,
                    style: const TextStyle(
                        color: Colors.white, fontSize: 16),
                  ),
                  Text(
                    song.artist,
                    style: const TextStyle(
                        color: Colors.white54, fontSize: 13),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }


}
