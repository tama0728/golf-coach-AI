import 'package:flutter/material.dart';
import 'login_page.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SignupPage3 extends StatefulWidget {
  final String id;
  final String pw;
  final String email;
  final String phoneNum;
  const SignupPage3(this.id, this.pw, this.email, this.phoneNum);

  @override
  _SignupPage3State createState() => _SignupPage3State();
}

class _SignupPage3State extends State<SignupPage3> {
  final _nicknameController = TextEditingController();
  final _heightController = TextEditingController();
  final _experienceController = TextEditingController();
  String? _battingDirection; // '좌' or '우'

  String? userName;
  String? phoneNum;
  String? userHeight;
  int? userHand;

  bool _isLoading = false;
  String? _errorMessage;


  Future<void> _handleSignup() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final url = Uri.parse('http://${dotenv.get('HOSTIP')}:3000/api/auth/signup');
    print( "phoneNum: ${widget.phoneNum}");
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "id":widget.id,
          "password":widget.pw,
          "userEmail":widget.email,
          "userName":userName,
          "phoneNum":widget.phoneNum,
          "userHeight":userHeight,
          "userHand":userHand
        }),
      );

      print(response.statusCode);
      print(response.body);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final data = jsonDecode(response.body);
        final token = data['token'];

        // 토큰 안전하게 저장
        await storage.write(key: 'jwt_token', value: token);

        // 홈 화면 등으로 이동
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => LoginPage()),
        );
        return ;
      } else {
        setState(() {
          _errorMessage = '로그인 실패: ${jsonDecode(response.body)['error']}';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = '네트워크 오류: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
    // error popup
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text(_errorMessage ?? 'Unknown error'),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('회원가입')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView(
          children: [
            // 닉네임 + 중복확인
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _nicknameController,
                    decoration: InputDecoration(
                      labelText: '닉네임',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    print('중복확인 클릭');
                  },
                  child: Text('중복확인'),
                ),
              ],
            ),
            SizedBox(height: 24),

            // 타석 방향
            Text('당신의 타석 방향은?', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildToggleButton('좌'),
                _buildToggleButton('우'),
              ],
            ),
            SizedBox(height: 24),

            // 키 입력
            Text('당신의 키는?', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            SizedBox(height: 12),
            TextField(
              controller: _heightController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: '키 (cm)',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 24),

            // 구력 입력
            Text('당신의 구력은?', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            SizedBox(height: 12),
            TextField(
              controller: _experienceController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: '개월 수',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 32),
          ],
        ),
      ),

      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SizedBox(
          width: double.infinity,
          height: 48,
          child: ElevatedButton(
            onPressed: () {
              userName = _nicknameController.text.trim();
              userHeight = _heightController.text.trim();
              userHand = _battingDirection == '좌' ? 1 : 0;
              print('다음 단계로 이동');
              print('회원가입 정보:');
              print('아이디: ${widget.id}');
              print('비밀번호: ${widget.pw}');
              print('이메일: ${widget.email}');
              print('닉네임: $userName');
              print('키: $userHeight');
              print('타석 방향: $userHand');
              print('번호: ${widget.phoneNum}');
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(builder: (context) => LoginPage()),
              // );
              _handleSignup();
            },
            child: Text('로그인하러 가기'),
          ),
        ),
      ),

    );
  }

  Widget _buildToggleButton(String label) {
    final isSelected = _battingDirection == label;
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: isSelected ? Colors.blue : Colors.grey[300],
        foregroundColor: isSelected ? Colors.white : Colors.black,
      ),
      onPressed: () {
        setState(() {
          _battingDirection = label;
        });
      },
      child: Text(label),
    );
  }
}
