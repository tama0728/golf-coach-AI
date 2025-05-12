import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../login/login_page.dart';


class FindPWPage extends StatefulWidget {
  @override
  _FindPWPageState createState() => _FindPWPageState();
}

class _FindPWPageState extends State<FindPWPage> {
  final _emailController = TextEditingController();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _codeController = TextEditingController();
  final _newPwController = TextEditingController();
  final _confirmPwController = TextEditingController();

  bool _isLoading = false;
  String? _errorMessage;

  Future<void> _handleFindPW() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final email = _emailController.text.trim();
    final name = _nameController.text.trim();
    final phone = _phoneController.text.trim();
    final newPw = _newPwController.text.trim();
    final confPw = _confirmPwController.text.trim();

    print('이메일: $email');
    print('이름: $name');
    print('전화번호: $phone');
    print('새 비밀번호: $newPw');
    print('비밀번호 확인: $confPw');

    if (newPw != confPw) {
      setState(() {
        _errorMessage = '비밀번호가 일치하지 않습니다.';
      });
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

    final url = Uri.parse(
        'http://${dotenv.get('HOSTIP')}:3000/api/auth/findPassword');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'userEmail': email,
          'userName': name,
          'phoneNum': phone,
          'newPassword': newPw,
        }),
      );

      print(response.statusCode);
      print(response.body);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print('비밀번호 재설정 성공: ${data['email']}');
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('비밀번호 재설정 성공'),
              content: Text('이메일: ${data['email']}'),
              actions: <Widget>[
                TextButton(
                  child: Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => LoginPage()),
                    );
                  },
                ),
              ],
            );
          },
        );
        return ;
      } else {
        setState(() {
          _errorMessage = '일치하는 회원정보가 없습니다.: ${jsonDecode(response.body)['error']}';
        });
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
    }
    catch (e) {
      setState(() {
        _errorMessage = '네트워크 오류: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('비밀번호 찾기')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView(
          children: [
            _buildTextField(_emailController, '이메일'),
            SizedBox(height: 16),
            _buildTextField(_nameController, '이름'),
            SizedBox(height: 16),
            _buildTextField(_phoneController, '전화번호'),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                print('인증번호 요청');
              },
              child: Text('인증번호 받기'),
            ),
            SizedBox(height: 16),
            _buildTextField(_codeController, '인증번호 입력'),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                print('인증 확인');
              },
              child: Text('확인'),
            ),
            SizedBox(height: 24),
            _buildTextField(_newPwController, '새 비밀번호', obscure: true),
            SizedBox(height: 16),
            _buildTextField(_confirmPwController, '비밀번호 확인', obscure: true),
            SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                print('비밀번호 재설정 시도');
                _handleFindPW();
              },
              child: Text('비밀번호 변경'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, {bool obscure = false}) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
      ),
    );
  }
}
