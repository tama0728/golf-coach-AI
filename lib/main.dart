import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'login/app_start.dart';
import 'package:flutter/services.dart'; // 화면 회전 고정용

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");

  // 세로모드로 고정
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

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
