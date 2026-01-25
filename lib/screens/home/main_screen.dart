import 'package:flutter/material.dart';
import '../../models/song.dart';
import '../../services/music_service.dart';
import '../../widgets/mini_player_bar.dart';
import 'search_screen.dart';
import 'home_screen.dart';
import 'settings_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int index = 0;
  final MusicService _musicService = MusicService();

  // ▶️ PHÁT NHẠC (GỌI QUA SERVICE)
  void _playSong(Song song) async {
    await _musicService.playSong(song);
    setState(() {}); // rebuild để hiện MiniPlayer
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      const HomeScreen(),
      SearchScreen(
        onSongSelected: _playSong,
      ),
      const SettingsScreen(),
    ];

    return Scaffold(
      body: pages[index],

      // 🎵 MINI PLAYER (TỰ LẤY currentSong)
      bottomSheet: _musicService.currentSong != null
          ? const MiniPlayerBar()
          : null,

      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black,
        currentIndex: index,
        onTap: (i) => setState(() => index = i),
        selectedItemColor: Colors.pink,
        unselectedItemColor: Colors.white54,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: '',
          ),
        ],
      ),
    );
  }
}
