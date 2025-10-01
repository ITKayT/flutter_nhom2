import 'package:flutter/material.dart';

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: Text(
              'Xin chào mọi người!',
              style: TextStyle(color: Colors.red, fontSize: 30),
            ),
          ),
          Icon(Icons.heart_broken, size: 100, color: Colors.red),
          Text("Lập trình di động - Nhóm 2", style: TextStyle(color: Colors.blue, fontSize: 30)),
        ],
      ),
    );
  }
}
