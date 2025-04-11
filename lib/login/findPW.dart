import 'package:flutter/material.dart';

class FindPWPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('비밀번호 찾기')),
      body: Center(
        child: Text(
          '비밀번호 찾기 페이지',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
