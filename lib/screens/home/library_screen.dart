import 'package:flutter/material.dart';

class LibraryScreen extends StatelessWidget {
  const LibraryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: const [
        ListTile(
          leading: Icon(Icons.music_note),
          title: Text('Chúng ta của hiện tại'),
          subtitle: Text('Sơn Tùng M-TP'),
        ),
        ListTile(
          leading: Icon(Icons.music_note),
          title: Text('Hồng nhan'),
          subtitle: Text('Jack'),
        ),
      ],
    );
  }
}
