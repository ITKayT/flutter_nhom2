import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

class MyExercisePage extends StatelessWidget {
  const MyExercisePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              block1(),
              const SizedBox(height: 16),
              block2(),
              const SizedBox(height: 12),
              block3(),
              const SizedBox(height: 16),
              block4(),
              const SizedBox(height: 8),
              block5(context), // <--- truyền context vào để đọc asset
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  // ---------------- block1 ----------------
  Widget block1() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        IconButton(
          icon: const Icon(Icons.notifications_none),
          onPressed: () {},
        ),
        IconButton(
          icon: const Icon(Icons.settings_outlined),
          onPressed: () {},
        ),
      ],
    );
  }

  // ---------------- block2 ----------------
  Widget block2() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Welcome,',
            style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold)),
        Text('Tuấn Kiệt',
            style: TextStyle(fontSize: 36, fontWeight: FontWeight.w400)),
      ],
    );
  }

  // ---------------- block3 ----------------
  Widget block3() {
    return Container(
      height: 44,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.black26),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      alignment: Alignment.centerLeft,
      child: const Row(
        children: [
          Icon(Icons.search, size: 20, color: Colors.black45),
          SizedBox(width: 8),
          Text('Search', style: TextStyle(color: Colors.black45)),
        ],
      ),
    );
  }

  // ---------------- block4 ----------------
  Widget block4() {
    return const Text(
      'Saved Places',
      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
    );
  }

  // ---------------- block5 (auto load images) ----------------
  Widget block5(BuildContext context) {
    return FutureBuilder<List<String>>(
      future: _loadAssetImages('assets/images/'),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Padding(
            padding: EdgeInsets.all(16),
            child: Center(child: CircularProgressIndicator()),
          );
        }

        final imgs = snapshot.data ?? [];
        if (imgs.isEmpty) {
          return const Padding(
            padding: EdgeInsets.all(16),
            child: Center(child: Text('Không có ảnh nào')),
          );
        }

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: imgs.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 16 / 10,
          ),
          itemBuilder: (_, i) => ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black26),
                borderRadius: BorderRadius.circular(12),
              ),
              clipBehavior: Clip.antiAlias,
              child: Image.asset(imgs[i], fit: BoxFit.cover),
            ),
          ),
        );
      },
    );
  }

  // ---------------- helper đọc AssetManifest ----------------
  Future<List<String>> _loadAssetImages(String folderPrefix) async {
    try {
      final manifestJson = await rootBundle.loadString('AssetManifest.json');
      final Map<String, dynamic> manifestMap = json.decode(manifestJson);

      final exts = RegExp(r'\.(png|jpe?g|webp|gif|bmp)$', caseSensitive: false);
      final paths = manifestMap.keys
          .where((path) => path.startsWith(folderPrefix) && exts.hasMatch(path))
          .toList()
        ..sort();

      return paths;
    } catch (e) {
      debugPrint('Lỗi khi đọc AssetManifest: $e');
      return <String>[];
    }
  }
}
