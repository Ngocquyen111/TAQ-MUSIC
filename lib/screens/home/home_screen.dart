import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../services/music_service.dart';
import '../../models/song.dart';
import 'artist_detail_screen.dart';
import 'profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final MusicService _musicService = MusicService();

  // ================== DATA ==================

  final List<Song> _songs = [
    Song(
      title: "Cause I Love You",
      artist: "Noo Phước Thịnh",
      filePath: "songs/cause_i_love_you.mp3",
      duration: "3:45",
    ),
    Song(
      title: "Nhà Tôi Có Treo Một Lá Cờ",
      artist: "Hà Anh Tuấn",
      filePath: "songs/Nhà Tôi Có Treo Một Lá Cờ.mp3",
      duration: "4:20",
    ),
    Song(
      title: "Hoa và Váy",
      artist: "Quốc Thiên",
      filePath: "songs/Hoa và Váy (RnB ver).mp3",
      duration: "3:30",
    ),
  ];

  final List<Map<String, String>> _artists = [
    {"name": "Noo Phước Thịnh", "image": ""},
    {"name": "Hà Anh Tuấn", "image": ""},
    {"name": "Quốc Thiên", "image": ""},
  ];

  // ================== PLAYER ==================

  @override
  void initState() {
    super.initState();
    _musicService.onPlayerStateChanged.listen((_) {
      if (mounted) setState(() {});
    });
  }

  void _playSong(Song song) async {
    await _musicService.play(song.filePath);
    setState(() {});
  }

  bool _isPlaying(String filePath) {
    return _musicService.currentSongPath == filePath &&
        _musicService.isPlaying;
  }

  // ================== UI ==================

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // ================= HEADER =================
          Row(
            children: [
              InkWell(
                borderRadius: BorderRadius.circular(20),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const ProfileScreen(),
                    ),
                  );
                },
                child: const CircleAvatar(
                  radius: 18,
                  backgroundColor: Colors.orange,
                  child: Icon(Icons.music_note, color: Colors.white),
                ),
              ),
              const SizedBox(width: 12),
              _chip("Tất cả", active: true),
            ],
          ),

          const SizedBox(height: 20),

          const Text(
            "Dành cho bạn",
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 12),

          // ================= MINI SONGS =================
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _songs.length > 4 ? 4 : _songs.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 3.2,
            ),
            itemBuilder: (context, index) {
              return _miniItem(_songs[index]);
            },
          ),

          const SizedBox(height: 28),

          // ================= ARTISTS =================
          const Text(
            "Nghệ sĩ nổi bật",
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 12),

          SizedBox(
            height: 230,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: _artists.length,
              separatorBuilder: (_, __) => const SizedBox(width: 16),
              itemBuilder: (context, index) {
                final artist = _artists[index];

                return InkWell(
                  borderRadius: BorderRadius.circular(24),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ArtistDetailScreen(
                          artistName: artist["name"]!,
                          artistImage: artist["image"]!,
                        ),
                      ),
                    );
                  },
                  child: Container(
                    width: 170,
                    decoration: BoxDecoration(
                      color: AppColors.card,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Column(
                      children: [
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Colors.pinkAccent.withOpacity(0.35),
                                  Colors.pinkAccent.withOpacity(0.1),
                                ],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                              ),
                              borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(24),
                              ),
                            ),
                            child: const Center(
                              child: Icon(
                                Icons.person,
                                size: 72,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(12),
                          child: Text(
                            artist["name"]!,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 28),

          // ================= RANKING =================
          const Text(
            "Bảng xếp hạng",
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 12),

          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _songs.length,
            itemBuilder: (context, index) {
              return _songItem(_songs[index], index + 1);
            },
          ),
        ],
      ),
    );
  }

  // ================= COMPONENTS =================

  Widget _chip(String text, {bool active = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: active ? Colors.pinkAccent : AppColors.card,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: const TextStyle(color: Colors.white, fontSize: 13),
      ),
    );
  }

  Widget _miniItem(Song song) {
    final isPlaying = _isPlaying(song.filePath);

    return InkWell(
      onTap: () => _playSong(song),
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isPlaying
              ? Colors.pinkAccent.withOpacity(0.2)
              : AppColors.card,
          borderRadius: BorderRadius.circular(14),
          border: isPlaying
              ? Border.all(color: Colors.pinkAccent, width: 1.5)
              : null,
        ),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: Colors.pinkAccent.withOpacity(0.3),
                shape: BoxShape.circle,
              ),
              child: Icon(
                isPlaying ? Icons.pause : Icons.music_note,
                color: Colors.white,
                size: 20,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    song.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    song.artist,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white54,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _songItem(Song song, int index) {
    final isPlaying = _isPlaying(song.filePath);

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () => _playSong(song),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: isPlaying
                ? Colors.pinkAccent.withOpacity(0.1)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: isPlaying ? Colors.pinkAccent : AppColors.card,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: isPlaying
                      ? const Icon(Icons.pause,
                      color: Colors.white, size: 20)
                      : Text(
                    '$index',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      song.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      song.artist,
                      style: const TextStyle(
                        color: Colors.white54,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                song.duration,
                style: const TextStyle(
                  color: Colors.white54,
                  fontSize: 14,
                ),
              ),
              const SizedBox(width: 12),
              Icon(
                isPlaying
                    ? Icons.pause_circle_filled
                    : Icons.play_circle_filled,
                color: Colors.pinkAccent,
                size: 32,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
