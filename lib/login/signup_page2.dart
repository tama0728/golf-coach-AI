import 'package:flutter/material.dart';
import 'signup_page3.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('회원가입')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView(
          children: [
            _buildTextField(_idController, '아이디'),
            _buildTextField(_pwController, '비밀번호', obscure: true),
            _buildTextField(_pwCheckController, '비밀번호 확인', obscure: true),
            _buildTextFieldWithButton(
              _emailController,
              '이메일',
              '인증요청',
                  () {
                print('이메일 인증 요청됨');
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
              // 다음 단계 or 가입 처리
              print('가입 정보 입력 완료');
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SignupPage3()),
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
}

