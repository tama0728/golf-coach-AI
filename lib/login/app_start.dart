import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../main_pages/main_page.dart';
import '../login/login_page.dart';

final storage = FlutterSecureStorage();

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkAutoLogin();
  }

  Future<void> _checkAutoLogin() async {
    final token = await storage.read(key: 'jwt_token');
    final autoLogin = await storage.read(key: 'auto_login');
    debugPrint('[SplashScreen] 토큰: $token, autoLogin: $autoLogin');

    if (token != null && autoLogin == 'true') {
      try {
        final url = Uri.parse('http://${dotenv.get('HOSTIP')}:3000/api/auth/check-token');
        final response = await http.get(url, headers: {'Authorization': 'Bearer $token'});
        debugPrint('[SplashScreen] check-token: ${response.statusCode}, ${response.body}');
        if (response.statusCode == 200) {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => MainPage()));
          return;
        }
      } catch (e) {
        debugPrint('[SplashScreen] 네트워크 오류: $e');
      }
    }
    // 토큰 없거나 실패 → 로그인 페이지로 이동
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => LoginPage()));
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
