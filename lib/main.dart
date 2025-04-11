import 'package:flutter/material.dart';
import 'login/app_start.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Golf Coach App',
      theme: ThemeData(primarySwatch: Colors.green),
      home: SplashScreen(), // 앱 시작 시 로딩화면 먼저
    );
  }
}
