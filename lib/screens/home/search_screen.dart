import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../data/music_data.dart';
import '../../models/song.dart';
import '../../services/music_service.dart';

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

  @override
  void initState() {
    super.initState();
    _musicService.onPlayerStateChanged.listen((_) {
      if (mounted) setState(() {});
    });
  }

  void _onSearch(String keyword) {
    keyword = keyword.toLowerCase();
    final songs = MusicData.artists
        .expand((artist) => artist.songs)
        .where((song) =>
    song.title.toLowerCase().contains(keyword) ||
        song.artist.toLowerCase().contains(keyword))
        .toList();
    setState(() {
      _results = songs;
    });
  }

  bool _isCurrentlyPlaying(String filePath) {
    return _musicService.currentSongPath == filePath &&
        _musicService.isPlaying;
  }

  // ✅ THÊM HÀM NÀY
  void _handleSongTap(Song song) async {
    if (_musicService.currentSongPath == song.filePath) {
      if (_musicService.isPlaying) {
        await _musicService.pause();
      } else {
        await _musicService.resume();
      }
      setState(() {});
    } else {
      widget.onSongSelected(song);
    }
  }

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
                hintText: "Bạn muốn nghe gì",
                filled: true,
                fillColor: Colors.white,
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 16),

            if (_results.isNotEmpty)
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _results.length,
                itemBuilder: (_, index) {
                  final song = _results[index];
                  final isPlaying = _isCurrentlyPlaying(song.filePath);
                  return _buildSongItem(song, isPlaying);
                },
              ),
            const SizedBox(height: 24),

            const Text(
              "Khám phá nội dung mới mẻ",
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 160,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  _imageCard("assets/search1.jpg"),
                  _imageCard("assets/search2.jpg"),
                  _imageCard("assets/search3.jpg"),
                ],
              ),
            ),
            const SizedBox(height: 24),

            const Text(
              "Duyệt tìm tất cả",
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.6,
              children: const [
                _BrowseCard("Nhạc", Colors.pink),
                _BrowseCard("Album", Colors.green),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildSongItem(Song song, bool isPlaying) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        leading: Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: isPlaying
                ? Colors.pinkAccent.withOpacity(0.3)
                : Colors.grey[800],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            isPlaying ? Icons.pause : Icons.music_note,
            color: Colors.white,
          ),
        ),
        title: Text(
          song.title,
          style: TextStyle(
            color: isPlaying ? Colors.pinkAccent : Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(
          song.artist,
          style: TextStyle(
            color: Colors.grey[400],
            fontSize: 14,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: Icon(
          isPlaying ? Icons.pause_circle_filled : Icons.play_circle_outline,
          color: isPlaying ? Colors.pinkAccent : Colors.white,
          size: 32,
        ),
        onTap: () => _handleSongTap(song), // ✅ GỌI HÀM XỬ LÝ
        tileColor: isPlaying
            ? Colors.pinkAccent.withOpacity(0.1)
            : Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  Widget _imageCard(String path) {
    return Container(
      width: 140,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        image: DecorationImage(
          image: AssetImage(path),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

class _BrowseCard extends StatelessWidget {
  final String title;
  final Color color;

  const _BrowseCard(this.title, this.color);

  @override
  Widget build(BuildContext context) {
    return Container(
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
    );
  }
}