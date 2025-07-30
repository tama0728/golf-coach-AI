import 'package:flutter/material.dart';

class PrivacyPage extends StatelessWidget {
  const PrivacyPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 70,
        title: const Text(
          '개인정보 처리방침',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black87),
      ),
      body: Column(
        children: const [
          Divider(height: 1, thickness: 1),
          Expanded(
            child: Center(
              child: Text('여기에 개인정보 처리방침 내용을 넣으세요'),
            ),
          ),
        ],
      ),
      backgroundColor: Colors.white,
    );
  }
}


