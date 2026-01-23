import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../user_store.dart';
import 'edit_profile_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  File? _avatarImage;
  final ImagePicker _picker = ImagePicker();
  static const String _avatarKey = 'user_avatar_path';

  bool _showPassword = false;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadAvatar();
    _loadUserFromFirebase(); // 🔥 LẤY DATA TỪ FIREBASE
  }

  /// ================= LOAD USER FROM FIRESTORE =================
  Future<void> _loadUserFromFirebase() async {
    if (UserStore.uid.isEmpty) return;

    try {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(UserStore.uid)
          .get();

      if (doc.exists) {
        final data = doc.data()!;
        UserStore.name = data['name'] ?? '';
        UserStore.username = data['username'] ?? '';
        UserStore.email = data['email'] ?? '';
        UserStore.phone = data['phone'] ?? '';
        UserStore.birthday = data['birthday'] ?? '';
      }
    } catch (e) {
      debugPrint("Load profile error: $e");
    }

    setState(() => _loading = false);
  }

  /// ================= AVATAR LOCAL =================
  Future<void> _loadAvatar() async {
    final prefs = await SharedPreferences.getInstance();
    final path = prefs.getString(_avatarKey);
    if (path != null && File(path).existsSync()) {
      setState(() {
        _avatarImage = File(path);
      });
    }
  }

  Future<void> _pickAvatar() async {
    final XFile? image =
    await _picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        _avatarImage = File(image.path);
      });

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_avatarKey, image.path);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        backgroundColor: Color(0xFF0F0F0F),
        body: Center(
          child: CircularProgressIndicator(color: Colors.pinkAccent),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFF0F0F0F),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F0F0F),
        elevation: 0,
        title: const Text(
          "Trang cá nhân",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () async {
              final updated = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const EditProfileScreen(),
                ),
              );
              if (updated == true) {
                await _loadUserFromFirebase(); // 🔥 LOAD LẠI SAU KHI EDIT
              }
            },
          )
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // ================= HEADER =================
          Center(
            child: GestureDetector(
              onTap: _pickAvatar,
              child: Stack(
                alignment: Alignment.bottomRight,
                children: [
                  CircleAvatar(
                    radius: 60,
                    backgroundColor: Colors.pinkAccent,
                    backgroundImage:
                    _avatarImage != null ? FileImage(_avatarImage!) : null,
                    child: _avatarImage == null
                        ? Text(
                      UserStore.name.isNotEmpty
                          ? UserStore.name[0].toUpperCase()
                          : "U",
                      style: const TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    )
                        : null,
                  ),
                  Container(
                    width: 34,
                    height: 34,
                    decoration: BoxDecoration(
                      color: Colors.black,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: const Icon(
                      Icons.camera_alt,
                      color: Colors.white,
                      size: 18,
                    ),
                  )
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          Center(
            child: Text(
              UserStore.name,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          const SizedBox(height: 32),

          _infoCard(
            icon: Icons.person,
            label: "Họ và tên",
            value: UserStore.name,
          ),
          _infoCard(
            icon: Icons.account_circle,
            label: "Username",
            value: UserStore.username,
          ),
          _infoCard(
            icon: Icons.email,
            label: "Email",
            value: UserStore.email,
          ),
          _infoCard(
            icon: Icons.phone,
            label: "Số điện thoại",
            value: UserStore.phone,
          ),
          _infoCard(
            icon: Icons.cake,
            label: "Ngày sinh",
            value: UserStore.birthday,
          ),
        ],
      ),
    );
  }

  Widget _infoCard({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1C1C1C),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          _iconBox(icon),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    color: Colors.white54,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _iconBox(IconData icon) {
    return Container(
      width: 42,
      height: 42,
      decoration: BoxDecoration(
        color: Colors.pinkAccent.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(icon, color: Colors.pinkAccent),
    );
  }
}
