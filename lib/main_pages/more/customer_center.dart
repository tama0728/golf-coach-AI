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
        title: const Text(
          '고객센터',
          style: TextStyle(color: Colors.black87),
        ),
        backgroundColor: Colors.white,
        elevation: 1,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black87),
      ),
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          // 버그 신고
          ListTile(
            title: const Text('버그 신고'),
            trailing: const Icon(Icons.chevron_right),
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
            title: const Text('Q&A'),
            trailing: const Icon(Icons.chevron_right),
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
