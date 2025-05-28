// 수정: lib/main_pages/account.dart

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../login/login_page.dart';   // ← 상대경로 주의!
import '../more/withdraw_page.dart';

final storage = FlutterSecureStorage();

class AccountPage extends StatelessWidget {
  const AccountPage({Key? key}) : super(key: key);

  Future<void> _logout(BuildContext context) async {
    // 로그아웃: 저장된 토큰 등 삭제
    await storage.delete(key: 'jwt_token');
    // 로그인 페이지로 이동 (이전 스택 모두 삭제)
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => LoginPage()),
          (route) => false,
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('로그아웃'),
        content: Text('정말 로그아웃 하시겠습니까?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('취소'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context); // 다이얼로그 닫기
              _logout(context); // 로그아웃 처리
            },
            child: Text('로그아웃', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('계정관리', style: TextStyle(color: Colors.black87)),
        backgroundColor: Colors.white,
        elevation: 1,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black87),
      ),
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          ListTile(
            title: const Text('로그아웃'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              _showLogoutDialog(context);
            },
          ),
          const Divider(height: 1, thickness: 1),
          ListTile(
            title: const Text('회원탈퇴'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => WithdrawPage()),
              );
            },
          ),
          const Divider(height: 1, thickness: 1),
        ],
      ),
      backgroundColor: Colors.white,
    );
  }
}
