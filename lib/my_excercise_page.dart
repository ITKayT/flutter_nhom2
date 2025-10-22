import 'package:flutter/material.dart';

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
              block5(),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  // Row: [ bell | settings ]
  Widget block1() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        IconButton(
          icon: const Icon(Icons.notifications_none),
          onPressed: () {},
          tooltip: 'Notifications',
        ),
        const SizedBox(width: 4),
        IconButton(
          icon: const Icon(Icons.settings_outlined),
          onPressed: () {},
          tooltip: 'Settings',
        ),
      ],
    );
  }

  // Welcome text
  Widget block2() {
    return const Padding(
      padding: EdgeInsets.only(top: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Welcome,',
            style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
          ),
          Text(
            'Tuấn Kiệt',
            style: TextStyle(fontSize: 36, fontWeight: FontWeight.w400),
          ),
        ],
      ),
    );
  }

  // Search bar
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

  // Saved Places title
  Widget block4() {
    return const Text(
      'Saved Places',
      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
    );
  }

  // Grid 2x2 của ảnh
  Widget block5() {
    final imgs = [
      'lib/assets/images/ngo-thanh-tung-B76nvP51iew-unsplash.jpg',
      'lib/assets/images/thai-an-3Qzf-U0XfCE-unsplash.jpg',
      'lib/assets/images/ph-ng-anh-nguy-n-Wg5QlgFdrDQ-unsplash.jpg',
      'lib/assets/images/nguyen-minh-O2BwqiFnVHo-unsplash.jpg',
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: imgs.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, // 2x2
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
  }
}
