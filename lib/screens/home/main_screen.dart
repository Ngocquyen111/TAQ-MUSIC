import 'package:flutter/material.dart';
import '../../models/song.dart';
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

  @override
  Widget build(BuildContext context) {
    final pages = [
      const HomeScreen(),
      SearchScreen(
        onSongSelected: (song) {
          setState(() => currentSong = song); // ✅ KÍCH HOẠT MINI PLAYER
        },
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
