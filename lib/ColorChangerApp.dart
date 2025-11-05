import 'dart:math';

import 'package:flutter/material.dart';

class ColorChangerApp extends StatefulWidget {
  const ColorChangerApp({super.key});

  @override
  State<ColorChangerApp> createState() => _ColorChangerAppState();
}

class _ColorChangerAppState extends State<ColorChangerApp> {
  late Color currentColor;
  List<Color> colors = [Colors.purple, Colors.orange, Colors.blue, Colors.green];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    currentColor = Colors.purple;
  }

  void changeColor() {
    var random = Random();
    setState(() {
      currentColor = colors[random.nextInt(colors.length)];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppBar(),
      body: myBody(),
    );
  }
  
  myBody() {
    return Container(
      decoration: BoxDecoration(
        color: currentColor,
      ),
      child: Column(
        children: [
          Text("Màu sắc hiện tại"),
          Text("Tím", style: TextStyle(color: currentColor, fontSize: 30),),
          Row(
            children: [
              ElevatedButton.icon(
                onPressed: changeColor,
                label: Text("Đổi màu"),
              ),
              ElevatedButton.icon(
                onPressed: null,
                label: Text("Reset"),
              )
            ],
          )
        ],
      ),
    );
  }

  myAppBar() {
    return AppBar(
      title: Text("Ứng dụng đổi màu"),
      backgroundColor: Colors.teal,
      foregroundColor: Colors.white,
      centerTitle: true,
    );
  }
}