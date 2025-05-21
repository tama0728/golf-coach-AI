
import 'package:flutter/material.dart';

class AppLicensePage extends StatelessWidget {
  const AppLicensePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('라이선스', style: TextStyle(color: Colors.black87)),
        backgroundColor: Colors.white,
        elevation: 1,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black87),
      ),
      body: const Center(
        child: Text('여기에 라이선스 정보를 넣으세요'),
      ),
      backgroundColor: Colors.white,
    );
  }
}
