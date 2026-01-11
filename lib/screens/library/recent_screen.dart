import 'package:flutter/material.dart';

class RecentScreen extends StatelessWidget {
  const RecentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF4A0000),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text("Gần đây"),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _chip("Nhạc"),

          const SizedBox(height: 16),

          _date("Th2, 10 tháng 12, 2025"),
          _songItem("Sau Ngần Ấy Năm", "Subheading"),

          const SizedBox(height: 12),

          _date("Th6, 7 tháng 11, 2025"),
          _songItem("Sau Ngần Ấy Năm", "Subheading"),
          _songItem("Hồng Nhan", "J97"),

          const SizedBox(height: 12),

          _date("Th2, 10 tháng 5, 2025"),
          _songItem("Đom Đóm", "J97"),
          _songItem("Bạc Phận", "J97"),
        ],
      ),
    );
  }

  // ===== COMPONENTS =====

  Widget _chip(String text) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          text,
          style: const TextStyle(color: Colors.black),
        ),
      ),
    );
  }

  Widget _date(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white70,
          fontSize: 13,
        ),
      ),
    );
  }

  Widget _songItem(String title, String artist) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          const CircleAvatar(radius: 22),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
                Text(
                  artist,
                  style: const TextStyle(
                    color: Colors.white54,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          const Icon(Icons.keyboard_arrow_down, color: Colors.white),
        ],
      ),
    );
  }
}
