import 'dart:async';
import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../services/music_service.dart';
import '../../models/song.dart';
import '../../data/local_music_store.dart';
import '../../app_state.dart'; // ✅ thêm
import 'artist_detail_screen.dart';
import 'profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final MusicService _musicService = MusicService();

  bool _isLoading = true;

  // ================== DATA ==================

  final List<Song> _songs = [
    Song(
      title: "Cause I Love You",
      artist: "Noo Phước Thịnh",
      filePath: "songs/Cause I Love You (Xuân Phát Tài 8).mp3",
      duration: "3:45",
      artistImage: "assets/images/artists/noo.jpg",
    ),
    Song(
      title: "Nhà Tôi Có Treo Một Lá Cờ",
      artist: "Hà Anh Tuấn",
      filePath: "songs/Nhà Tôi Có Treo Một Lá Cờ.mp3",
      duration: "4:20",
      artistImage: "assets/images/artists/ha_anh_tuan.jpg",
    ),
    Song(
      title: "Hoa và Váy",
      artist: "Quốc Thiên",
      filePath: "songs/Hoa và Váy (Rock ver).mp3",
      duration: "3:30",
      artistImage: "assets/images/artists/quoc_thien.jpg",
    ),
  ];

  final List<Map<String, String>> _artists = [
    {
      "name": "Noo Phước Thịnh",
      "image": "assets/images/artists/noo.jpg",
    },
    {
      "name": "Hà Anh Tuấn",
      "image": "assets/images/artists/ha_anh_tuan.jpg",
    },
    {
      "name": "Quốc Thiên",
      "image": "assets/images/artists/quoc_thien.jpg",
    },
  ];

  // ================== INIT ==================

  @override
  void initState() {
    super.initState();

    // ✅ CHỈ HIỆN SKELETON KHI LOGIN MỚI
    if (!AppState.homeLoaded) {
      _isLoading = true;

      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          setState(() {
            _isLoading = false;
            AppState.homeLoaded = true; // 🔑 đánh dấu home đã load
          });
        }
      });
    } else {
      _isLoading = false;
    }
  }

  // ================== PLAYER ==================

  void _playSong(Song song) async {
    LocalMusicStore.addRecent(song);

    if (_musicService.currentSong?.filePath == song.filePath) {
      if (_musicService.isPlaying) {
        await _musicService.pause();
      } else {
        await _musicService.resume();
      }
    } else {
      await _musicService.playSong(song);
    }
    setState(() {});
  }

  bool _isPlaying(String filePath) {
    return _musicService.currentSong?.filePath == filePath &&
        _musicService.isPlaying;
  }

  // ================== UI ==================

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: _isLoading ? _buildSkeleton() : _buildContent(),
    );
  }

  // ================== REAL CONTENT ==================

  Widget _buildContent() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
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
                        child: ClipRRect(
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(24),
                          ),
                          child: Image.asset(
                            artist["image"]!,
                            width: double.infinity,
                            fit: BoxFit.cover,
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

        const Text(
          "Danh sách bài hát",
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
    );
  }

  // ================== SKELETON ==================

  Widget _buildSkeleton() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _skeletonBox(height: 36, width: 120),
        const SizedBox(height: 20),
        _skeletonBox(height: 26, width: 160),
        const SizedBox(height: 12),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: 6,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 3.2,
          ),
          itemBuilder: (_, __) => _skeletonBox(height: 50),
        ),
        const SizedBox(height: 24),
        _skeletonBox(height: 200),
        const SizedBox(height: 24),
        _skeletonBox(height: 24),
        _skeletonBox(height: 24),
        _skeletonBox(height: 24),
      ],
    );
  }

  Widget _skeletonBox({double height = 20, double? width}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }

  // ================== COMPONENTS ==================

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
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(18),
              child: Image.asset(
                song.artistImage,
                width: 36,
                height: 36,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                song.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _songItem(Song song, int index) {
    final isPlaying = _isPlaying(song.filePath);

    return ListTile(
      onTap: () => _playSong(song),
      leading: CircleAvatar(
        backgroundColor: isPlaying ? Colors.pinkAccent : AppColors.card,
        child: Text('$index', style: const TextStyle(color: Colors.white)),
      ),
      title: Text(song.title, style: const TextStyle(color: Colors.white)),
      subtitle:
      Text(song.artist, style: const TextStyle(color: Colors.white54)),
      trailing: Icon(
        isPlaying ? Icons.pause : Icons.play_arrow,
        color: Colors.pinkAccent,
      ),
    );
  }
}