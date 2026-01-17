import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../services/music_service.dart';
import '../../models/song.dart';
import 'artist_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final MusicService _musicService = MusicService();

  // Danh sách bài hát mẫu
  final List<Song> _songs = [
    Song(
      title: "Cause I Love You",
      artist: "Noo Phước Thịnh",
      filePath: "songs/cause_i_love_you.mp3",
      duration: "3:45",
    ),
    Song(
      title: "Bài hát 2",
      artist: "Hà Anh Tuấn",
      filePath: "songs/song2.mp3",
      duration: "4:20",
    ),
    Song(
      title: "Bài hát 3",
      artist: "Hồng Nhan J97",
      filePath: "songs/song3.mp3",
      duration: "3:30",
    ),
  ];

  String? _currentPlayingSong;

  @override
  void initState() {
    super.initState();
    _musicService.onPlayerStateChanged.listen((state) {
      if (mounted) {
        setState(() {
        });
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _playSong(Song song) async {
    await _musicService.play(song.filePath);
    setState(() {
      _currentPlayingSong = song.filePath;
    });
  }

  bool _isCurrentlyPlaying(String filePath) {
    return _musicService.currentSongPath == filePath && _musicService.isPlaying;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Row(
            children: [
              const CircleAvatar(
                radius: 18,
                backgroundColor: Colors.orange,
                child: Icon(Icons.music_note, color: Colors.white),
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
          GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 3.2,
            ),
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _songs.length > 4 ? 4 : _songs.length,
            itemBuilder: (context, index) {
              final song = _songs[index];
              return _miniItem(song);
            },
          ),
          const SizedBox(height: 24),

          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ArtistDetailScreen(
                    artistName: "Noo Phước Thịnh",
                    artistImage: "",
                  ),
                ),
              );
            },
            child: Container(
              height: 240,
              decoration: BoxDecoration(
                color: AppColors.card,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.pinkAccent.withOpacity(0.2),
                        borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(24)),
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.person,
                          size: 80,
                          color: Colors.pinkAccent,
                        ),
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(12),
                    child: Text(
                      "Noo Phước Thịnh",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

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
              final song = _songs[index];
              return _songItem(song, index + 1);
            },
          ),

          const SizedBox(height: 24),

          const Text(
            "Nghệ sĩ",
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          _artistItem(context, "Noo Phước Thịnh", "assets/artist.jpg", _songs[0]),
          _artistItem(context, "Hà Anh Tuấn", "assets/artist.jpg", _songs.length > 1 ? _songs[1] : _songs[0]),
          _artistItem(context, "Hồng Nhan J97", "assets/artist.jpg", _songs.length > 2 ? _songs[2] : _songs[0]),
        ],
      ),
    );
  }

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
    final isPlaying = _isCurrentlyPlaying(song.filePath);

    return InkWell(
      onTap: () => _playSong(song),
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isPlaying ? Colors.pinkAccent.withOpacity(0.2) : AppColors.card,
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
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    song.artist,
                    style: const TextStyle(
                      color: Colors.white54,
                      fontSize: 11,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _songItem(Song song, int index) {
    final isPlaying = _isCurrentlyPlaying(song.filePath);

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () => _playSong(song),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: isPlaying ? Colors.pinkAccent.withOpacity(0.1) : Colors.transparent,
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
                      ? const Icon(Icons.pause, color: Colors.white, size: 20)
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
                isPlaying ? Icons.pause_circle_filled : Icons.play_circle_filled,
                color: Colors.pinkAccent,
                size: 32,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _artistItem(BuildContext context, String name, String imagePath, Song song) {
    final isPlaying = _isCurrentlyPlaying(song.filePath);

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: Colors.pinkAccent.withOpacity(0.3),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.person,
              color: Colors.white,
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ArtistDetailScreen(
                      artistName: name,
                      artistImage: imagePath,
                    ),
                  ),
                );
              },
              child: Text(
                name,
                style: const TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          ),
          IconButton(
            icon: Icon(
              isPlaying ? Icons.pause_circle_filled : Icons.play_circle_filled,
              color: isPlaying ? Colors.pinkAccent : Colors.white,
              size: 28,
            ),
            onPressed: () => _playSong(song),
          ),
        ],
      ),
    );
  }
}