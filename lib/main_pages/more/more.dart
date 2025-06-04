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
        toolbarHeight: 70,
        title: const Text(
          '더보기',
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
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          const Divider(height: 1, thickness: 1),

          // 공지사항
          ListTile(
            contentPadding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
            title: const Text('공지사항',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 19,
              ),
            ),
            trailing: const Icon(Icons.chevron_right, size: 35),
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
            contentPadding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
            title: const Text('고객센터',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 19,
              ),
            ),
            trailing: const Icon(Icons.chevron_right, size: 35),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const CustomerCenterPage()),
              );
            },
          ),

          // 그룹 분리용 연한 녹색 배경
          //Container(height: 8, color: const Color(0xFFE8F4EA)),
          Divider(
            color: Color(0xFFE6F5E6),
            thickness: 15,
            height: 15,
          ),

          // 약관 및 정책
          ListTile(
            contentPadding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
            title: const Text('약관 및 정책',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 19,
              ),
            ),
            trailing: const Icon(Icons.chevron_right, size: 35),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const PolicyPage()),
              );
            },
          ),
          //const Divider(height: 1, thickness: 1),
          Divider(
            color: Color(0xFFE6F5E6),
            thickness: 15,
            height: 15,
          ),

          // 계정 관리
          ListTile(
            contentPadding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
            title: const Text('계정 관리',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 19,
              ),
            ),
            trailing: const Icon(Icons.chevron_right, size: 35),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AccountPage()),
              );
            },
          ),

          const Divider(height: 1, thickness: 1),

          const SizedBox(height: 24),

          // 앱 버전
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 30),
            child: Text(
              '앱 버전 1.00',
              style: TextStyle(color: Colors.grey, fontSize: 19),
            ),
          ),
        ],
      ),
      backgroundColor: Colors.white,
    );
  }
}
