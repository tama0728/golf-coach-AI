// lib/main_pages/account.dart

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../login/login_page.dart';
import '../more/withdraw_page.dart';

final storage = FlutterSecureStorage();

class AccountPage extends StatelessWidget {
  const AccountPage({Key? key}) : super(key: key);

  // 로그아웃 다이얼로그 함수
  Future<void> _showLogoutDialog(BuildContext context) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('로그아웃'),
        content: Text('정말 로그아웃하시겠습니까?'),
        actions: [
          TextButton(
            child: Text('취소'),
            onPressed: () => Navigator.of(context).pop(false),
          ),
          TextButton(
            child: Text('확인'),
            onPressed: () => Navigator.of(context).pop(true),
          ),
        ],
      ),
    );

    if (confirm == true) {
      final token = await storage.read(key: 'jwt_token');
      print('[AccountPage] 삭제 전 토큰: $token');
      await storage.delete(key: 'jwt_token');
      await storage.write(key: 'auto_login', value: 'false');
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
            (route) => false,
      );
    }
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
