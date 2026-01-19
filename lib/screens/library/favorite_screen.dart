import 'package:flutter/material.dart';
import '../../models/song.dart';
import '../home/artist_detail_screen.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({super.key});

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
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

  // 🔹 THÊM index để xoá
  Widget _songItem(BuildContext context, Song song, int index) {
    return InkWell(
      onTap: () {
        MusicStore.addRecent(song);

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

            // 🔥 NÚT XOÁ YÊU THÍCH (💔)
            IconButton(
              icon: const Icon(
                Icons.heart_broken,
                color: Colors.redAccent,
              ),
              onPressed: () {
                setState(() {
                  MusicStore.favoriteSongs.removeAt(index);
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
