import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // ===== HEADER =====
          Row(
            children: [
              const CircleAvatar(
                radius: 18,
                backgroundColor: Colors.orange,
                child: Icon(Icons.music_note, color: Colors.white),
              ),
              const SizedBox(width: 12),
              _chip("Tất cả", active: true),
              const SizedBox(width: 8),
              _chip("Nhạc đã tải"),
            ],
          ),

          const SizedBox(height: 20),

          // ===== FOR YOU LIST =====
          const Text(
            "Dành cho bạn",
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
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
            childAspectRatio: 3.2,
            children: List.generate(
              4,
                  (index) => _miniItem(),
            ),
          ),

          const SizedBox(height: 24),

          // ===== ARTIST CARD =====
          Container(
            height: 240,
            decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius: BorderRadius.circular(24),
            ),
            child: Column(
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(24)),
                    child: Image.asset(
                      "assets/artist.jpg", // ảnh nghệ sĩ
                      fit: BoxFit.cover,
                      width: double.infinity,
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

          const SizedBox(height: 24),

          // ===== ARTIST LIST =====
          const Text(
            "Nghệ sĩ",
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 12),

          _artistItem("Noo Phước Thịnh"),
          _artistItem("Hà Anh Tuấn"),
          _artistItem("Hồng Nhan J97"),
        ],
      ),
    );
  }

  // ===== COMPONENTS =====

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

  Widget _miniItem() {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: const [
          CircleAvatar(radius: 18),
          SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Title",
                  style: TextStyle(color: Colors.white, fontSize: 13)),
              Text("Description",
                  style: TextStyle(color: Colors.white54, fontSize: 11)),
            ],
          )
        ],
      ),
    );
  }

  Widget _artistItem(String name) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          const CircleAvatar(radius: 22),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              name,
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
          const Icon(Icons.play_circle_fill,
              color: Colors.white, size: 28)
        ],
      ),
    );
  }
}
