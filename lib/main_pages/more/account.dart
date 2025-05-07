// 수정: lib/main_pages/account.dart

import 'package:flutter/material.dart';
import 'withdraw_page.dart'; // 새로 만든 회원탈퇴 페이지 import

class AccountPage extends StatelessWidget {
  const AccountPage({Key? key}) : super(key: key);

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
              // TODO: 로그아웃 처리
            },
          ),
          const Divider(height: 1, thickness: 1),
          ListTile(
            title: const Text('회원탈퇴'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const WithdrawPage()),
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
