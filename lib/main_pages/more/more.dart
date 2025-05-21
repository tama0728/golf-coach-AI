import 'package:flutter/material.dart';
import 'notice.dart';
import 'customer_center.dart';
import 'policy.dart';
import 'account.dart';


class MorePage extends StatelessWidget {
  const MorePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '더보기',
          style: TextStyle(color: Colors.black87),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black87),
      ),
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          const Divider(height: 1, thickness: 1),

          // 공지사항
          ListTile(
            title: const Text('공지사항'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const NoticePage()),
              );
            },
          ),
          const Divider(height: 1, thickness: 1),

          // 고객센터
          ListTile(
            title: const Text('고객센터'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const CustomerCenterPage()),
              );
            },
          ),

          // 그룹 분리용 연한 녹색 배경
          Container(height: 8, color: const Color(0xFFE8F4EA)),

          // 약관 및 정책
          ListTile(
            title: const Text('약관 및 정책'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const PolicyPage()),
              );
            },
          ),
          const Divider(height: 1, thickness: 1),

          // 계정 관리
          ListTile(
            title: const Text('계정 관리'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AccountPage()),
              );
            },
          ),

          const SizedBox(height: 24),

          // 앱 버전
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              '앱 버전 1.00',
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ),
        ],
      ),
      backgroundColor: Colors.white,
    );
  }
}
