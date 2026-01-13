import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../services/music_service.dart';
import '../../data/music_data.dart';
import '../../models/song.dart';
import 'package:audioplayers/audioplayers.dart';

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
      if (mounted) {
        setState(() {
          _isPlaying = state == PlayerState.playing;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
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
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _actionButton(
                    Icons.shuffle,
                    "Phát ngẫu nhiên",
                    onTap: () => _playRandomSong(),
                  ),
                  _actionButton(Icons.favorite_border, "Yêu thích"),
                  _actionButton(Icons.share, "Chia sẻ"),
                ],
              ),
            ),
          ),

          const SliverToBoxAdapter(
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
          ),

          SliverList(
            delegate: SliverChildBuilderDelegate(
                  (context, index) {
                if (index >= _songs.length) return null;

                final song = _songs[index];
                final isCurrentSong = _currentPlayingSong == song.filePath;

                return _songItem(
                  title: song.title,
                  artist: song.artist,
                  duration: song.duration,
                  index: index,
                  songPath: song.filePath,
                  isPlaying: isCurrentSong && _isPlaying,
                  isCurrentSong: isCurrentSong,
                );
              },
              childCount: _songs.length,
            ),
          ),
        ],
      ),
      bottomNavigationBar: _currentPlayingSong != null
          ? _buildMiniPlayer()
          : null,
    );
  }

  Widget _actionButton(IconData icon, String label, {VoidCallback? onTap}) {
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
            child: Icon(icon, color: Colors.white, size: 24),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _songItem({
    required String title,
    required String artist,
    required String duration,
    required int index,
    required String songPath,
    required bool isPlaying,
    required bool isCurrentSong,
  }) {
    return InkWell(
      onTap: () => _playSong(songPath, title),
      child: Container(
        color: isCurrentSong ? AppColors.card.withOpacity(0.3) : Colors.transparent,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          children: [
            // Số thứ tự hoặc icon đang phát
            SizedBox(
              width: 30,
              child: isPlaying
                  ? const Icon(Icons.volume_up, color: Colors.pinkAccent, size: 20)
                  : Text(
                "${index + 1}",
                style: TextStyle(
                  color: isCurrentSong ? Colors.pinkAccent : Colors.white70,
                  fontSize: 14,
                  fontWeight: isCurrentSong ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
            const SizedBox(width: 12),

            // Album art
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: AppColors.card,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                isPlaying ? Icons.music_note : Icons.music_note,
                color: isPlaying ? Colors.pinkAccent : Colors.white54,
              ),
            ),
            const SizedBox(width: 12),

            // Song info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: isCurrentSong ? Colors.pinkAccent : Colors.white,
                      fontSize: 15,
                      fontWeight: isCurrentSong ? FontWeight.w600 : FontWeight.w500,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    artist,
                    style: const TextStyle(
                      color: Colors.white60,
                      fontSize: 13,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),

            // Play/Pause button
            IconButton(
              icon: Icon(
                isPlaying ? Icons.pause_circle_filled : Icons.play_circle_filled,
                color: isCurrentSong ? Colors.pinkAccent : Colors.white60,
                size: 32,
              ),
              onPressed: () => _playSong(songPath, title),
            ),

            // Duration
            Text(
              duration,
              style: const TextStyle(
                color: Colors.white60,
                fontSize: 13,
              ),
            ),

            // More button
            IconButton(
              icon: const Icon(Icons.more_vert, color: Colors.white60),
              onPressed: () => _showSongOptions(title),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMiniPlayer() {
    return Container(
      height: 70,
      color: AppColors.card,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: Colors.pinkAccent.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.music_note, color: Colors.pinkAccent),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  _getCurrentSongTitle(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  widget.artistName,
                  style: const TextStyle(
                    color: Colors.white60,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(
              _isPlaying ? Icons.pause : Icons.play_arrow,
              color: Colors.white,
              size: 32,
            ),
            onPressed: () => _togglePlayPause(),
          ),
        ],
      ),
    );
  }

  // ===== MUSIC CONTROL METHODS =====
  void _playSong(String songPath, String title) {
    setState(() {
      _currentPlayingSong = songPath;
    });
    _musicService.play(songPath);
  }

  void _playRandomSong() {
    if (_songs.isEmpty) return;
    final randomIndex = DateTime.now().millisecond % _songs.length;
    final song = _songs[randomIndex];
    _playSong(song.filePath, song.title);
  }

  void _togglePlayPause() {
    if (_isPlaying) {
      _musicService.pause();
    } else if (_currentPlayingSong != null) {
      _musicService.play(_currentPlayingSong!);
    }
  }

  void _showSongOptions(String title) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.card,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.playlist_add, color: Colors.white),
              title: const Text("Thêm vào playlist", style: TextStyle(color: Colors.white)),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.share, color: Colors.white),
              title: const Text("Chia sẻ", style: TextStyle(color: Colors.white)),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.download, color: Colors.white),
              title: const Text("Tải xuống", style: TextStyle(color: Colors.white)),
              onTap: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }

  // ===== HELPER METHODS =====
  String _getCurrentSongTitle() {
    if (_currentPlayingSong == null) return "";
    try {
      final song = _songs.firstWhere((s) => s.filePath == _currentPlayingSong);
      return song.title;
    } catch (e) {
      return "Đang phát...";
    }
  }

  @override
  void dispose() {
    super.dispose();
  }
}