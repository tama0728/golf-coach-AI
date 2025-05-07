import 'package:flutter/material.dart';

class PrivacyPage extends StatelessWidget {
  const PrivacyPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('개인정보 처리방침', style: TextStyle(color: Colors.black87)),
        backgroundColor: Colors.white,
        elevation: 1,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black87),
      ),
      body: const Center(
        child: Text('여기에 개인정보 처리방침 내용을 넣으세요'),
      ),
      backgroundColor: Colors.white,
    );
  }
}
