import 'package:flutter/material.dart';
import 'signup_page2.dart';

class SignupPage1 extends StatefulWidget {
  @override
  _SignupPage1State createState() => _SignupPage1State();
}

class _SignupPage1State extends State<SignupPage1> {
  bool agreeAll = false;
  bool agree1 = false;
  bool agree2 = false;

  void _toggleAll(bool? val) {
    setState(() {
      agreeAll = val ?? false;
      agree1 = agreeAll;
      agree2 = agreeAll;
    });
  }

  Widget _buildTermTile({
    required String title,
    required bool value,
    required Function(bool?) onChanged,
    required String content,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Checkbox(value: value, onChanged: onChanged),
            Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        Container(
          height: 100,
          width: 500,
          padding: EdgeInsets.all(8),
          margin: EdgeInsets.only(bottom: 20),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(8),
          ),
          child: SingleChildScrollView(
            child: Text(content),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    agreeAll = agree1 && agree2;

    return Scaffold(
      appBar: AppBar(title: Text('회원가입')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Row(
              children: [
                Checkbox(value: agreeAll, onChanged: _toggleAll),
                Text('전체 동의하기',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ],
            ),
            Divider(thickness: 1.2),
            _buildTermTile(
              title: '[필수] 어플 이용약관',
              value: agree1,
              onChanged: (val) => setState(() => agree1 = val ?? false),
              content: '여기 어플 이용약관 내용이 주르륵 들어감\n줄줄줄...',
            ),
            _buildTermTile(
              title: '[필수] 개인정보 수집 및 이용',
              value: agree2,
              onChanged: (val) => setState(() => agree2 = val ?? false),
              content: '개인정보 수집에 대한 설명이 들어가는 부분입니다...',
            ),
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
              if (agree1 && agree2) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SignupPage2()),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('필수 약관에 모두 동의해주세요.')),
                );
              }
            },
            child: Text('다음으로'),
          ),
        ),
      ),
    );
  }
}