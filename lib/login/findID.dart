import 'package:flutter/material.dart';

class FindIDPage extends StatefulWidget {
  @override
  _FindIDPageState createState() => _FindIDPageState();
}

class _FindIDPageState extends State<FindIDPage> {
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _codeController = TextEditingController();

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
