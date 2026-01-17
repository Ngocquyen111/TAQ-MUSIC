import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

import '../../theme/app_colors.dart';
import '../../services/music_service.dart';
import '../../data/music_data.dart';
import '../../models/song.dart';

/// ================= GLOBAL MUSIC STORE =================
/// Các screen khác chỉ cần import file này là dùng được
class MusicStore {
  static final List<Song> recentSongs = [];
  static final List<Song> favoriteSongs = [];
  static final List<Song> downloadedSongs = [];

  static void addRecent(Song song) {
    recentSongs.removeWhere((s) => s.filePath == song.filePath);
    recentSongs.insert(0, song);
  }

  static void addFavorite(Song song) {
    if (!favoriteSongs.any((s) => s.filePath == song.filePath)) {
      favoriteSongs.add(song);
    }
  }

  static void addDownload(Song song) {
    if (!downloadedSongs.any((s) => s.filePath == song.filePath)) {
      downloadedSongs.add(song);
    }
  }
}

class ArtistDetailScreen extends StatefulWidget {
  final String artistName;
  final String artistImage;

  const ArtistDetailScreen({
    super.key,
    required this.artistName,
    required this.artistImage,
  });

  @override
  State<ArtistDetailScreen> createState() => _ArtistDetailScreenState();
}

class _ArtistDetailScreenState extends State<ArtistDetailScreen> {
  final MusicService _musicService = MusicService();

  String? _currentPlayingSong;
  bool _isPlaying = false;
  List<Song> _songs = [];

  @override
  void initState() {
    super.initState();

    _songs = MusicData.getSongsByArtist(widget.artistName);

    _musicService.onPlayerStateChanged.listen((state) {
      if (!mounted) return;
      setState(() {
        _isPlaying = state == PlayerState.playing;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      body: CustomScrollView(
        slivers: [
          _buildAppBar(),
          _buildActionButtons(),
          _buildSongTitle(),
          _buildSongList(),
        ],
      ),
      bottomNavigationBar:
      _currentPlayingSong != null ? _buildMiniPlayer() : null,
    );
  }

  // ================= APP BAR =================
  Widget _buildAppBar() {
    return SliverAppBar(
      expandedHeight: 300,
      pinned: true,
      backgroundColor: AppColors.card,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () => Navigator.pop(context),
      ),
      flexibleSpace: FlexibleSpaceBar(
        title: Text(
          widget.artistName,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        background: Stack(
          fit: StackFit.expand,
          children: [
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.pinkAccent.withOpacity(0.3),
                    AppColors.card,
                  ],
                ),
              ),
              child: const Center(
                child: Icon(
                  Icons.person,
                  size: 120,
                  color: Colors.white54,
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withOpacity(0.7),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ================= ACTION BUTTON =================
  Widget _buildActionButtons() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _actionButton(
              Icons.shuffle,
              "Phát ngẫu nhiên",
              onTap: _playRandomSong,
            ),
          ],
        ),
      ),
    );
  }

  Widget _actionButton(
      IconData icon,
      String label, {
        VoidCallback? onTap,
      }) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.card,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: Colors.white),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(color: Colors.white70, fontSize: 12),
          ),
        ],
      ),
    );
  }

  // ================= SONG TITLE =================
  Widget _buildSongTitle() {
    return const SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.fromLTRB(16, 8, 16, 12),
        child: Text(
          "Bài hát",
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  // ================= SONG LIST =================
  Widget _buildSongList() {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
            (context, index) {
          final song = _songs[index];
          final isCurrentSong = _currentPlayingSong == song.filePath;

          return _songItem(
            song: song,
            index: index,
            isPlaying: isCurrentSong && _isPlaying,
            isCurrentSong: isCurrentSong,
          );
        },
        childCount: _songs.length,
      ),
    );
  }

  Widget _songItem({
    required Song song,
    required int index,
    required bool isPlaying,
    required bool isCurrentSong,
  }) {
    return InkWell(
      onTap: () => _playSong(song.filePath),
      child: Container(
        color:
        isCurrentSong ? AppColors.card.withOpacity(0.3) : Colors.transparent,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          children: [
            SizedBox(
              width: 30,
              child: isPlaying
                  ? const Icon(Icons.volume_up,
                  color: Colors.pinkAccent, size: 20)
                  : Text(
                "${index + 1}",
                style: TextStyle(
                  color: isCurrentSong
                      ? Colors.pinkAccent
                      : Colors.white70,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: AppColors.card,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.music_note,
                color: isPlaying
                    ? Colors.pinkAccent
                    : Colors.white.withOpacity(.6),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    song.title,
                    style: TextStyle(
                      color:
                      isCurrentSong ? Colors.pinkAccent : Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    song.artist,
                    style: const TextStyle(
                        color: Colors.white60, fontSize: 13),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: Icon(
                isPlaying
                    ? Icons.pause_circle_filled
                    : Icons.play_circle_filled,
                color: Colors.pinkAccent,
                size: 32,
              ),
              onPressed: () => _playSong(song.filePath),
            ),
            Text(song.duration,
                style: const TextStyle(color: Colors.white60)),
            IconButton(
              icon: const Icon(Icons.more_vert, color: Colors.white60),
              onPressed: () => _showSongOptions(song),
            ),
          ],
        ),
      ),
    );
  }

  // ================= MINI PLAYER =================
  Widget _buildMiniPlayer() {
    return Container(
      height: 70,
      color: AppColors.card,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          const Icon(Icons.music_note, color: Colors.pinkAccent),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              _getCurrentSongTitle(),
              style: const TextStyle(color: Colors.white),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          IconButton(
            icon: Icon(
              _isPlaying ? Icons.pause : Icons.play_arrow,
              color: Colors.white,
              size: 32,
            ),
            onPressed: _togglePlayPause,
          ),
        ],
      ),
    );
  }

  // ================= MUSIC CONTROL =================
  void _playSong(String path) {
    final song = _songs.firstWhere((s) => s.filePath == path);

    MusicStore.addRecent(song);

    setState(() => _currentPlayingSong = path);
    _musicService.play(path);
  }

  void _playRandomSong() {
    if (_songs.isEmpty) return;
    final song = _songs[DateTime.now().millisecond % _songs.length];
    _playSong(song.filePath);
  }

  void _togglePlayPause() {
    if (_isPlaying) {
      _musicService.pause();
    } else if (_currentPlayingSong != null) {
      _musicService.play(_currentPlayingSong!);
    }
  }

  // ================= BOTTOM SHEET =================
  void _showSongOptions(Song song) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.card,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading:
              const Icon(Icons.favorite, color: Colors.pinkAccent),
              title: const Text("Yêu thích",
                  style: TextStyle(color: Colors.white)),
              onTap: () {
                MusicStore.addFavorite(song);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading:
              const Icon(Icons.download, color: Colors.green),
              title: const Text("Tải xuống",
                  style: TextStyle(color: Colors.white)),
              onTap: () {
                MusicStore.addDownload(song);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  // ================= HELPER =================
  String _getCurrentSongTitle() {
    try {
      return _songs
          .firstWhere((s) => s.filePath == _currentPlayingSong)
          .title;
    } catch (_) {
      return "Đang phát...";
    }
  }
}
