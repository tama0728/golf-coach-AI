import 'package:flutter/material.dart';
import 'login_page.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SignupPage3 extends StatefulWidget {
  final String user_email;
  final String user_pw;
  final String phone_num;
  final String user_nickname;
  const SignupPage3(this.user_email, this.user_pw, this.phone_num, this.user_nickname);

  @override
  _SignupPage3State createState() => _SignupPage3State();
}

class _SignupPage3State extends State<SignupPage3> {
  final _userNameController = TextEditingController();
  final _experienceController = TextEditingController();
  String? _battingDirection; // '좌' or '우'

  String? user_nickname;
  int? batting_side;

  bool _isLoading = false;
  String? _errorMessage;
  String? _userNameError;


  Future<void> _handleSignup() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final url = Uri.parse('http://${dotenv.get('HOSTIP')}:3000/api/auth/signup');
    print("phone_num: ${widget.phone_num}");
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "user_email": widget.user_email,
          "user_pw": widget.user_pw,
          "user_nickname": widget.user_nickname,
          "phone_num": widget.phone_num,
          "batting_side": batting_side
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

  Future<void> _handleCheckUserName() async {
    final userNickname = _userNameController.text.trim();
    user_nickname = userNickname;
    if (userNickname.isEmpty) {
      setState(() {
        _userNameError = '닉네임을 입력하세요.';
      });
      return;
    }
    final url = Uri.parse('http://${dotenv.get('HOSTIP')}:3000/api/auth/check-username');
    setState(() {
      _isLoading = true;
      _userNameError = null;
    });
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'user_nickname': userNickname}),
      );
      if (response.statusCode == 200) {
        setState(() {
          _userNameError = null;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('사용 가능한 닉네임입니다.')),
        );
      } else {
        setState(() {
          _userNameError = '이미 사용 중인 닉네임입니다.';
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(_userNameError!)),
        );
      }
    } catch (e) {
      setState(() {
        _userNameError = '네트워크 오류: $e';
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(_userNameError!)),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
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
                    controller: _userNameController,
                    decoration: InputDecoration(
                      labelText: '닉네임',
                      border: OutlineInputBorder(),
                      errorText: _userNameError,
                    ),
                  ),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: _handleCheckUserName,
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
              user_nickname = _userNameController.text.trim();
              batting_side = _battingDirection == '좌' ? 1 : 0;
              // 닉네임 유효성 검사
              if (user_nickname == null || user_nickname!.isEmpty) {
                setState(() {
                  _userNameError = '닉네임을 입력하세요.';
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(_userNameError!)),
                );
                return;
              }
              if (_userNameError != null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(_userNameError!)),
                );
                return;
              }
              print('다음 단계로 이동');
              print('회원가입 정보:');
              print('user_email: ${widget.user_email}');
              print('user_pw: ${widget.user_pw}');
              print('user_nickname: ${widget.user_nickname}');
              print('batting_side: $batting_side');
              print('phone_num: ${widget.phone_num}');
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