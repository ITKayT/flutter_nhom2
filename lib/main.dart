import 'package:flutter/material.dart';
import 'package:flutter_nhom2/My_report.dart';
import 'package:flutter_nhom2/my_BMI.dart';
import 'package:flutter_nhom2/my_product.dart';
import 'package:flutter_nhom2/newspage.dart';
// import 'package:flutter_nhom2/ColorChangerApp.dart';
// import 'package:flutter_nhom2/CountdownTimerApp.dart';
// import 'package:flutter_nhom2/FormLogin.dart';
// import 'package:flutter_nhom2/FormRegister.dart';
// import 'package:flutter_nhom2/CounterApp.dart';
// import 'package:flutter_nhom2/my_excercise_page.dart';
// import 'package:flutter_nhom2/my_classroom.dart';
// import 'package:flutter_nhom2/my_home_page.dart';
// import 'package:flutter_nhom2/my_place.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyNewsPage(),
    );  
  }
}
  