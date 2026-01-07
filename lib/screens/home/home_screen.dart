import 'home_screen.dart';
import 'library_screen.dart';
import 'profile_screen.dart';

import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'Trang chủ 🏠',
        style: TextStyle(fontSize: 22),
      ),
    );
  }
}
