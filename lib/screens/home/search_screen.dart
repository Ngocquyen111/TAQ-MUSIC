import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../data/music_data.dart';
import '../../models/song.dart';
import '../../services/music_service.dart';
import '../../data/local_music_store.dart';

class SearchScreen extends StatefulWidget {
  final ValueChanged<Song> onSongSelected;

  const SearchScreen({
    super.key,
    required this.onSongSelected,
  });

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchCtrl = TextEditingController();
  final MusicService _musicService = MusicService();

  List<Song> _results = [];
  final List<Song> _recentSearches = [];

  // ================= SEARCH  =================

  void _onSearch(String keyword) {
    keyword = keyword.trim().toLowerCase();

    if (keyword.isEmpty) {
      setState(() => _results = []);
      return;
    }

    final songs = MusicData.artists
        .expand((a) => a.songs)
        .where((s) =>
        s.title.toLowerCase().startsWith(keyword))
        .toList();

    setState(() => _results = songs);
  }

  bool _isPlaying(Song song) {
    return _musicService.currentSong?.filePath == song.filePath &&
        _musicService.isPlaying;
  }

  // ================= PLAY =================

  void _handleSongTap(Song song) async {
    LocalMusicStore.addRecent(song);

    if (_musicService.currentSong?.filePath == song.filePath) {
      if (_musicService.isPlaying) {
        await _musicService.pause();
      } else {
        await _musicService.resume();
      }
    } else {
      await _musicService.playSong(song);

      if (!_recentSearches.contains(song)) {
        _recentSearches.insert(0, song);
        if (_recentSearches.length > 5) {
          _recentSearches.removeLast();
        }
      }
    }
    setState(() {});
  }

  // ================= CATEGORY =================

  List<Song> _getSongsByCategory(String category) {
    final allSongs =
    MusicData.artists.expand((a) => a.songs).toList();

    switch (category) {
      case "Ballad":
        return allSongs.where((s) =>
        s.artist.toLowerCase().contains("noo") ||
            s.artist.toLowerCase().contains("hà anh tuấn") ||
            s.artist.toLowerCase().contains("quốc thiên")).toList();

      case "V-Pop":
        return allSongs;

      case "Tâm trạng":
        return allSongs.where((s) =>
        s.title.toLowerCase().contains("buồn") ||
            s.title.toLowerCase().contains("mưa") ||
            s.title.toLowerCase().contains("cô đơn")).toList();

      case "Remix":
        return allSongs
            .where((s) => s.title.toLowerCase().contains("remix"))
            .toList();

      default:
        return [];
    }
  }

  void _openCategory(String title) {
    final songs = _getSongsByCategory(title);

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.black,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: songs.isEmpty
                    ? const Center(
                  child: Text(
                    "Chưa có bài hát",
                    style: TextStyle(color: Colors.grey),
                  ),
                )
                    : ListView.builder(
                  itemCount: songs.length,
                  itemBuilder: (_, i) {
                    final song = songs[i];
                    return _buildSongItem(
                        song, _isPlaying(song));
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // ================= UI =================

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            const Text(
              "Tìm kiếm",
              style: TextStyle(
                color: Colors.white,
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),

            TextField(
              controller: _searchCtrl,
              onChanged: _onSearch,
              decoration: InputDecoration(
                hintText: "Bạn muốn nghe gì?",
                filled: true,
                fillColor: Colors.white,
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
              ),
            ),

            if (_results.isNotEmpty) ...[
              const SizedBox(height: 16),
              const Text("Kết quả",
                  style: TextStyle(color: Colors.white)),
              const SizedBox(height: 8),
              ..._results.map(
                    (s) => _buildSongItem(s, _isPlaying(s)),
              ),
            ],

            if (_searchCtrl.text.isEmpty &&
                _recentSearches.isNotEmpty) ...[
              const SizedBox(height: 24),
              const Text(
                "Tìm kiếm gần đây",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              ..._recentSearches.map(
                    (s) => _buildSongItem(s, _isPlaying(s)),
              ),
            ],

            const SizedBox(height: 24),

            const Text(
              "Duyệt tìm",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.6,
              children: [
                _BrowseCard("Ballad", Colors.pink,
                    onTap: () => _openCategory("Ballad")),
                _BrowseCard("V-Pop", Colors.green,
                    onTap: () => _openCategory("V-Pop")),
                _BrowseCard("Tâm trạng", Colors.blue,
                    onTap: () => _openCategory("Tâm trạng")),
                _BrowseCard("Remix", Colors.orange,
                    onTap: () => _openCategory("Remix")),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSongItem(Song song, bool isPlaying) {
    return ListTile(
      onTap: () => _handleSongTap(song),
      leading: CircleAvatar(
        backgroundColor:
        isPlaying ? Colors.pinkAccent : Colors.grey[800],
        child: Icon(
          isPlaying ? Icons.pause : Icons.music_note,
          color: Colors.white,
        ),
      ),
      title: Text(song.title,
          style: const TextStyle(color: Colors.white)),
      subtitle: Text(song.artist,
          style: const TextStyle(color: Colors.white54)),
      trailing: Icon(
        isPlaying ? Icons.pause_circle : Icons.play_circle,
        color: Colors.pinkAccent,
      ),
    );
  }
}

// ================= BROWSE CARD =================

class _BrowseCard extends StatelessWidget {
  final String title;
  final Color color;
  final VoidCallback onTap;

  const _BrowseCard(this.title, this.color,
      {required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(18),
        ),
        padding: const EdgeInsets.all(12),
        alignment: Alignment.bottomLeft,
        child: Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
