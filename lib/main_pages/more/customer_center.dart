// lib/main_pages/customer_center.dart

import 'package:flutter/material.dart';
import 'bug_report.dart';
import 'qna_page.dart';

class CustomerCenterPage extends StatelessWidget {
  const CustomerCenterPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 70,
        title: const Text(
          '고객센터',
          style: TextStyle(fontSize: 20,
              fontWeight: FontWeight.bold),
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
          // 버그 신고
          ListTile(
            contentPadding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
            title: const Text('버그 신고',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 19,
              ),
            ),
            trailing: const Icon(Icons.chevron_right, size: 35),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const BugReportPage()),
              );
            },
          ),
          const Divider(height: 1, thickness: 1),

          // Q&A
          ListTile(
            contentPadding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
            title: const Text('FAQ',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 19,
              ),
            ),
            trailing: const Icon(Icons.chevron_right, size: 35),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const QnAPage()),
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
