import 'package:flutter/material.dart';
import 'package:golf_coach_app/main_pages/analysis/analysis.dart';
import 'package:golf_coach_app/main_pages/analysis/result_ui.dart';
import 'package:golf_coach_app/main_pages/main_page.dart';
import 'dart:async';
import 'login_page.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Timer(Duration(seconds: 1), () {
    //   Navigator.of(context).pushReplacement(
    //     MaterialPageRoute(builder: (context) => LoginPage()),
    //     //MaterialPageRoute(builder: (context) => MainPage()),
    //   );
    // });

    /// 프레임 그려지고 난 뒤에 바로 pushReplacement 실행
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => MainPage()),
        //MaterialPageRoute(builder: (context) => ResultUIPage()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.golf_course, size: 100, color: Colors.green),
            SizedBox(height: 20),
            Text(
              '골프 코치',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            CircularProgressIndicator(color: Colors.green),
          ],
        ),
      ),
    );
  }
}
