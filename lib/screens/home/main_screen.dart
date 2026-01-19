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
  Song? currentSong;
  final MusicService _musicService = MusicService();

  @override
  void initState() {
    super.initState();
    _musicService.onPlayerStateChanged.listen((_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  // ✅ ĐƠN GIẢN HÓA - pause/resume xử lý trong MusicService.play()
  void _playSong(Song song) async {
    await _musicService.play(song.filePath);
    setState(() {
      currentSong = song;
    });
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

      bottomSheet: currentSong != null
          ? MiniPlayerBar(song: currentSong!)
          : null,

      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black,
        currentIndex: index,
        onTap: (i) => setState(() => index = i),
        selectedItemColor: Colors.pink,
        unselectedItemColor: Colors.white54,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: ''),
        ],
      ),
    );
  }
}