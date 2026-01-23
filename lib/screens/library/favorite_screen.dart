import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../models/song.dart';
import '../home/artist_detail_screen.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({super.key});

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  final _firestore = FirebaseFirestore.instance;
  final _uid = FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    final songs = MusicStore.favoriteSongs;

    return Scaffold(
      backgroundColor: const Color(0xFF4A0000),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text("Mục yêu thích"),
      ),
      body: songs.isEmpty
          ? const Center(
        child: Text(
          "Chưa có bài hát yêu thích",
          style: TextStyle(color: Colors.white70),
        ),
      )
          : ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: songs.length,
        itemBuilder: (context, index) {
          final song = songs[index];
          return _songItem(context, song, index);
        },
      ),
    );
  }

  Widget _songItem(BuildContext context, Song song, int index) {
    return InkWell(
      onTap: () async {
        // ===== GIỮ LOGIC CŨ =====
        MusicStore.addRecent(song);

        // ===== LƯU RECENT LÊN FIREBASE =====
        await _firestore.collection('users').doc(_uid).update({
          'recent': FieldValue.arrayUnion([_songToMap(song)])
        });

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ArtistDetailScreen(
              artistName: song.artist,
              artistImage: "assets/images/artist_placeholder.png",
            ),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Row(
          children: [
            const CircleAvatar(
              radius: 22,
              backgroundColor: Colors.white24,
              child: Icon(Icons.favorite, color: Colors.pink),
            ),
            const SizedBox(width: 12),

            // ===== TEXT =====
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    song.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                    ),
                  ),
                  Text(
                    song.artist,
                    style: const TextStyle(
                      color: Colors.white54,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),

            // 💔 XOÁ YÊU THÍCH (LOCAL + FIREBASE)
            IconButton(
              icon: const Icon(
                Icons.heart_broken,
                color: Colors.redAccent,
              ),
              onPressed: () async {
                setState(() {
                  MusicStore.favoriteSongs.removeAt(index);
                });

                await _firestore.collection('users').doc(_uid).update({
                  'favorites': FieldValue.arrayRemove([_songToMap(song)])
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  // ===== SONG → MAP =====
  Map<String, dynamic> _songToMap(Song song) {
    return {
      'title': song.title,
      'artist': song.artist,
      'filePath': song.filePath,
      'duration': song.duration,
      'artistImage': song.artistImage,
    };
  }
}
