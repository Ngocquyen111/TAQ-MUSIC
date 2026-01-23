import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../models/song.dart';
import '../home/artist_detail_screen.dart';

class DownloadScreen extends StatefulWidget {
  const DownloadScreen({super.key});

  @override
  State<DownloadScreen> createState() => _DownloadScreenState();
}

class _DownloadScreenState extends State<DownloadScreen> {
  final _firestore = FirebaseFirestore.instance;
  final _uid = FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    final songs = MusicStore.downloadedSongs;

    return Scaffold(
      backgroundColor: const Color(0xFF4A0000),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text("Đã tải xuống"),
      ),
      body: songs.isEmpty
          ? const Center(
        child: Text(
          "Chưa có bài hát đã tải",
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

  // ================= ITEM =================
  Widget _songItem(BuildContext context, Song song, int index) {
    return InkWell(
      onTap: () async {
        // ===== GIỮ NGUYÊN LOGIC CŨ =====
        MusicStore.addRecent(song);

        // ===== THÊM LƯU RECENT LÊN FIREBASE =====
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
              child: Icon(Icons.download_done, color: Colors.greenAccent),
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

            // 🔥 XOÁ DOWNLOAD (LOCAL + FIREBASE)
            IconButton(
              icon: const Icon(
                Icons.delete_outline,
                color: Colors.redAccent,
              ),
              onPressed: () async {
                setState(() {
                  MusicStore.downloadedSongs.removeAt(index);
                });

                await _firestore.collection('users').doc(_uid).update({
                  'downloads': FieldValue.arrayRemove([_songToMap(song)])
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  // ===== CHUYỂN SONG → MAP =====
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
