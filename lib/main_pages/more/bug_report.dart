import 'package:flutter/material.dart';

class BugReportPage extends StatefulWidget {
  const BugReportPage({Key? key}) : super(key: key);

  @override
  State<BugReportPage> createState() => _BugReportPageState();
}

class _BugReportPageState extends State<BugReportPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _subjectController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _subjectController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  void _sendReport() {
    // TODO: 전송 로직 구현
    final email = _emailController.text.trim();
    final subject = _subjectController.text.trim();
    final content = _contentController.text.trim();
    print('Send bug report: $email, $subject, $content');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '버그 신고',
          style: TextStyle(color: Colors.black87),
        ),
        backgroundColor: Colors.white,
        elevation: 1,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black87),
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '아래 "이메일"에 답변 받을 이메일을 입력해주세요.',
                style: TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 16),

              // 이메일
              const Text('이메일 :'),
              const SizedBox(height: 4),
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(4)),
                ),
              ),
              const SizedBox(height: 16),

              // 문의 제목
              const Text('문의 제목 :'),
              const SizedBox(height: 4),
              TextField(
                controller: _subjectController,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(4)),
                ),
              ),
              const SizedBox(height: 16),

              // 버그 내용
              const Text('버그 내용 :'),
              const SizedBox(height: 4),
              TextField(
                controller: _contentController,
                maxLines: 8,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.all(12),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(4)),
                ),
              ),

              const SizedBox(height: 24),
              Row(
                children: [
                  ElevatedButton(
                    onPressed: _sendReport,
                    child: const Text('보내기'),
                  ),
                  const SizedBox(width: 12),
                  OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('취소'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
