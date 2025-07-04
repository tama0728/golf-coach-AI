import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../login/login_page.dart';

class FindIDPage extends StatefulWidget {
  @override
  _FindIDPageState createState() => _FindIDPageState();
}

class _FindIDPageState extends State<FindIDPage> {
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _codeController = TextEditingController();

  bool _isLoading = false;
  String? _errorMessage;

  Future<void> _handleFindID() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final name = _nameController.text.trim();
    final phone = _phoneController.text.trim();

    print('이름: $name');
    print('전화번호: $phone');

    final url = Uri.parse(
        'http://${dotenv.get('HOSTIP')}:3000/api/auth/findEmail');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'userName': name,
          'phoneNum': phone
        }),
      );

      print(response.statusCode);
      print(response.body);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print('이메일 찾기 성공: ${data['email']}');
        // 이메일 찾기 성공 시, 이메일을 보여주는 팝업
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('이메일 찾기 성공'),
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
      appBar: AppBar(title: Text('아이디 찾기')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView(
          children: [
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
            SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                print('입력 확인');
                _handleFindID();
              },
              child: Text('확인'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
      ),
    );
  }
}
