
import 'package:flutter/material.dart';
import 'terms_page.dart';
import 'privacy_page.dart';
import 'app_license_page.dart';

class PolicyPage extends StatelessWidget {
  const PolicyPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 70,
        title: const Text('약관 및 정책', style: TextStyle(fontSize: 20,
            fontWeight: FontWeight.bold)
        ),
        backgroundColor: Colors.white,
        elevation: 1,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black87),
      ),
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          const Divider(height: 1, thickness: 1),

          // 서비스 이용약관
          ListTile(
            contentPadding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
            title: const Text('서비스 이용약관',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 19,
              ),
            ),
            trailing: const Icon(Icons.chevron_right, size: 35),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const TermsPage())
              );
            },
          ),
          const Divider(height: 1, thickness: 1),

          // 개인정보 처리방침
          ListTile(
            contentPadding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
            title: const Text('개인정보 처리방침',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 19,
              ),
            ),
            trailing: const Icon(Icons.chevron_right, size: 35),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const PrivacyPage())
              );
            },
          ),
          const Divider(height: 1, thickness: 1),

          // 라이선스
          ListTile(
            contentPadding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
            title: const Text('라이선스',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 19,
              ),
            ),
            trailing: const Icon(Icons.chevron_right, size: 35),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AppLicensePage()),
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
