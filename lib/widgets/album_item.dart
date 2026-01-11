import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class AlbumItem extends StatelessWidget {
  final String name;
  const AlbumItem(this.name, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 120,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Center(
        child: Text(name, style: const TextStyle(color: Colors.white)),
      ),
    );
  }
}
