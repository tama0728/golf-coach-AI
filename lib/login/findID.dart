import 'package:flutter/material.dart';

class FindIDPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('아이디 찾기')),
      body: Center(
        child: Text(
          '아이디 찾기 페이지',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
