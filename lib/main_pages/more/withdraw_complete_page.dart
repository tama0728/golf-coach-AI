// lib/main_pages/more/withdraw_complete_page.dart

import 'package:flutter/material.dart';
// 로그인 페이지로 돌아갈 때 사용할 import
import '../../login/login_page.dart';

class WithdrawCompletePage extends StatelessWidget {
  const WithdrawCompletePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '회원탈퇴',
          style: TextStyle(color: Colors.black87),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black87),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // AppBar 밑 1px 구분선
          const Divider(height: 1, thickness: 1),
          const SizedBox(height: 24),

          // 안내 문구
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              '회원 탈퇴가 정상 처리되었습니다.',
              style: TextStyle(color: Colors.black87, fontSize: 16),
              textAlign: TextAlign.start,
            ),
          ),
          const SizedBox(height: 24),

          // 확인 버튼
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFA0C3A0), // 연한 초록
                elevation: 0,
                minimumSize: const Size.fromHeight(48),
              ),
              onPressed: () {
                // 로그인 화면으로 돌아가기 (스택 전부 제거)
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => LoginPage()),
                      (route) => false,
                );
              },
              child: const Text(
                '확인',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          ),
        ],
      ),
      backgroundColor: Colors.white,
    );
  }
}
