import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'signup_page3.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'bloc.dart';
import 'package:email_validator/email_validator.dart';

class SignupPage2 extends StatefulWidget {
  @override
  _SignupPage2State createState() => _SignupPage2State();
}

class _SignupPage2State extends State<SignupPage2> {
  final _idController = TextEditingController();
  final _pwController = TextEditingController();
  final _pwCheckController = TextEditingController();
  final _emailController = TextEditingController();
  final _codeController = TextEditingController();
  final _phoneController = TextEditingController();

  bool _isLoading = false;
  String? _errorMessage;
  bool _isIdValid = false;
  bool _isPwValid = false;
  bool _isEmailValid = false;

  String? id;
  String? pw;
  String? email;
  String? phoneNum;
  String? _code;

  // handel id  // 아이디 중복확인
  Future<void> _handleCheckId() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    id = _idController.text.trim();

    print('아이디: $id');

    final url = Uri.parse('http://${dotenv.get('HOSTIP')}:3000/api/auth/checkId');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'id': id,
        }),
      );

      print(response.statusCode);
      print(response.body);

      if (response.statusCode == 200) {
        setState(() {
          _errorMessage = '아이디 사용 가능';
          _isIdValid = true;
        });
      } else if (response.statusCode == 400) {
        setState(() {
          _errorMessage = '이미 사용 중인 아이디입니다.';
        });
      } else {
        setState(() {
          _errorMessage = '아이디 확인 실패: ${jsonDecode(response.body)['error']}';
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
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(_isIdValid ? 'Success' : 'Error'),
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
    final bloc = Bloc();
    return Scaffold(
      appBar: AppBar(title: Text('회원가입')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView(
          children: [
            _buildTextFieldWithButton(
            _idController,
            '아이디',
            '중복확인', () {
              print('아이디 중복확인 클릭');
              _handleCheckId();
            }),
            _buildTextField(_pwController, '비밀번호', obscure: true),
            StreamBuilder<String>(
              stream: bloc.password,
              builder: (context, snapshot) => TextField(
                controller: _pwCheckController,
                onChanged: bloc.passwordChanged,
                keyboardType: TextInputType.text,
                obscureText: true,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  // hintText: "비밀번호 확인",
                  labelText: "비밀번호 확인",
                  errorText: snapshot.hasError ? snapshot.error.toString() : null,
                ),
              ),
            ),
            // _buildTextField(_pwCheckController, '비밀번호 확인', obscure: true),
            SizedBox(height: 16),
            _buildTextFieldWithButton(
              _emailController,
              '이메일',
              '인증요청',
                  () {
                print('이메일 인증 요청됨');
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('인증번호가 이메일로 발송되었습니다.')));
              },
            ),
            _buildTextFieldWithButton(
              _codeController,
              '인증번호 입력',
              '확인',
                  () {
                print('인증번호 확인 버튼 누름');
              },
            ),
            _buildTextField(_phoneController, '010-1234-5678', obscure: false),
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
              pw = _pwController.text.trim();
              email = _emailController.text.trim();
              phoneNum = _phoneController.text.trim();
              // 다음 단계 or 가입 처리
              print('가입 정보 입력 완료');
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SignupPage3(id!, pw!, email!, phoneNum!)),
              );
            },
            child: Text('다음으로'),
          ),
        ),
      ),

    );
  }

  Widget _buildTextField(TextEditingController controller, String label, {bool obscure = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextField(
        controller: controller,
        obscureText: obscure,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
        ),
      ),
    );
  }

  Widget _buildTextFieldWithButton(
      TextEditingController controller, String label, String buttonText, VoidCallback onPressed) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                labelText: label,
                border: OutlineInputBorder(),
              ),
            ),
          ),
          SizedBox(width: 10),
          ElevatedButton(
            onPressed: onPressed,
            child: Text(buttonText),
          ),
        ],
      ),
    );
  }

  Widget _buildTextFormFieldWithButton(
      TextEditingController controller, String label, String buttonText, VoidCallback onPressed) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        children: [
          Expanded(
            child: TextFormField(
              controller: controller,

              decoration: InputDecoration(
                labelText: label,
                border: OutlineInputBorder(),
              ),
            ),
          ),
          SizedBox(width: 10),
          ElevatedButton(
            onPressed: onPressed,
            child: Text(buttonText),
          ),
        ],
      ),
    );
  }
}

