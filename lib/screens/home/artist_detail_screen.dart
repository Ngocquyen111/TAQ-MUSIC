import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

import '../../theme/app_colors.dart';
import '../../services/music_service.dart';
import '../../data/music_data.dart';
import '../../data/local_music_store.dart';
import '../../models/song.dart';

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
  late List<Song> _songs;

  @override
  void initState() {
    super.initState();
    _songs = MusicData.getSongsByArtist(widget.artistName);

    _musicService.onPlayerStateChanged.listen((_) {
      if (mounted) setState(() {});
    });
  }

  // ================= PLAY =================
  void _playSong(Song song) async {
    LocalMusicStore.addRecent(song);
    await _musicService.playSong(song);
    setState(() {});
  }

  bool _isPlaying(Song song) {
    return _musicService.currentSongPath == song.filePath &&
        _musicService.isPlaying;
  }

  // ================= UI =================
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
      _musicService.currentSong != null ? _buildMiniPlayer() : null,
    );
  }

  // ================= APP BAR =================
  Widget _buildAppBar() {
    return SliverAppBar(
      expandedHeight: 320,
      pinned: true,
      backgroundColor: AppColors.card,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () => Navigator.pop(context),
      ),
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            // ẢNH NGHỆ SĨ
            Image.asset(
              widget.artistImage,
              fit: BoxFit.cover,
            ),

            // GRADIENT PHỦ
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.black.withOpacity(0.3),
                    AppColors.card,
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),


            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 28),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.person,
                      color: Colors.white70,
                      size: 46,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      widget.artistName,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ================= ACTION =================
  Widget _buildActionButtons() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: InkWell(
          onTap: _playRandomSong,
          child: Column(
            children: const [
              Icon(Icons.shuffle, color: Colors.white),
              SizedBox(height: 6),
              Text(
                "Phát ngẫu nhiên",
                style: TextStyle(color: Colors.white70),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ================= TITLE =================
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

  // ================= LIST =================
  Widget _buildSongList() {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
            (context, index) {
          final song = _songs[index];
          final isPlaying = _isPlaying(song);

          return ListTile(
            onTap: () => _playSong(song),
            leading: CircleAvatar(
              backgroundColor:
              isPlaying ? Colors.pinkAccent : AppColors.card,
              child: Icon(
                isPlaying ? Icons.pause : Icons.music_note,
                color: Colors.white,
              ),
            ),
            title: Text(
              song.title,
              style: const TextStyle(color: Colors.white),
            ),
            subtitle: Text(
              song.artist,
              style: const TextStyle(color: Colors.white54),
            ),
            trailing: IconButton(
              icon: const Icon(Icons.more_vert, color: Colors.white60),
              onPressed: () => _showSongOptions(song),
            ),
          );
        },
        childCount: _songs.length,
      ),
    );
  }

  // ================= MINI PLAYER =================
  Widget _buildMiniPlayer() {
    final song = _musicService.currentSong!;
    final isPlaying = _musicService.isPlaying;

    return Container(
      height: 70,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      color: AppColors.card,
      child: Row(
        children: [
          const Icon(Icons.music_note, color: Colors.pinkAccent),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              song.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: Colors.white),
            ),
          ),
          IconButton(
            icon: Icon(
              isPlaying ? Icons.pause : Icons.play_arrow,
              color: Colors.white,
              size: 32,
            ),
            onPressed: () {
              isPlaying
                  ? _musicService.pause()
                  : _musicService.resume();
              setState(() {});
            },
          ),
        ],
      ),
    );
  }

  // ================= OPTIONS =================
  void _showSongOptions(Song song) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.card,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading:
            const Icon(Icons.favorite, color: Colors.pinkAccent),
            title: const Text(
              "Yêu thích",
              style: TextStyle(color: Colors.white),
            ),
            onTap: () {
              LocalMusicStore.addFavorite(song);
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.download, color: Colors.green),
            title: const Text(
              "Tải xuống",
              style: TextStyle(color: Colors.white),
            ),
            onTap: () {
              LocalMusicStore.addDownload(song);
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  // ================= RANDOM =================
  void _playRandomSong() {
    if (_songs.isEmpty) return;
    final song = _songs[DateTime.now().millisecond % _songs.length];
    _playSong(song);
  }
}
