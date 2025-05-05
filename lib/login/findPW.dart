import 'package:flutter/material.dart';

class FindPWPage extends StatefulWidget {
  @override
  _FindPWPageState createState() => _FindPWPageState();
}

class _FindPWPageState extends State<FindPWPage> {
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _codeController = TextEditingController();
  final _newPwController = TextEditingController();
  final _confirmPwController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('비밀번호 찾기')),
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
