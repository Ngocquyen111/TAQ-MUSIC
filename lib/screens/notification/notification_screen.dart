import 'package:flutter/material.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

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
        title: const Text("Thông báo"),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {},
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _sectionTitle("Mới nhất"),

          const SizedBox(height: 12),

          _notificationItem(
            image: "assets/noti1.jpg",
            title: "Phát hành mới",
            desc:
            "The Lizards x Shanti Album mới của Toàn Shanti đã phát hành. Nghe ngay!",
          ),

          const SizedBox(height: 16),

          _notificationItem(
            image: "assets/noti2.jpg",
            title: "Playlist đã được",
            desc:
            "Mới phát hành cho những chuyến đi mùa hè cùng các bản hit nghe mãi.",
          ),

          const SizedBox(height: 24),

          _sectionTitle("Trước đó"),

          const SizedBox(height: 12),

          _notificationItem(
            image: "assets/noti3.jpg",
            title: "Cập nhật nghệ sĩ",
            desc:
            "Toàn LALA vừa chia sẻ Album mới. Xem ngay để không bỏ lỡ!",
            isCircle: true,
          ),

          const SizedBox(height: 20),

          Center(
            child: Text(
              "Xem những cập nhật trước đó",
              style: TextStyle(
                color: Colors.white.withOpacity(0.85),
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ===== COMPONENTS =====

  Widget _sectionTitle(String text) {
    return Text(
      text,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _notificationItem({
    required String image,
    required String title,
    required String desc,
    bool isCircle = false,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(isCircle ? 30 : 8),
          child: Image.asset(
            image,
            width: 56,
            height: 56,
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                desc,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 13,
                  height: 1.3,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
