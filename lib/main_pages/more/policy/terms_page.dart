import 'package:flutter/material.dart';

class TermsPage extends StatelessWidget {
  const TermsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 70,
        title: const Text(
          '서비스 이용약관',
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
              child: Text('여기에 서비스 이용약관 내용을 넣으세요'),
            ),
          ),
        ],
      ),
      backgroundColor: Colors.white,
    );
  }
}
