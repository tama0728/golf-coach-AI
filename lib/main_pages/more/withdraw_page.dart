// lib/main_pages/withdraw_page.dart

import 'package:flutter/material.dart';
import 'withdraw_complete_page.dart'; // 탈퇴 완료 페이지

class WithdrawPage extends StatefulWidget {
  const WithdrawPage({Key? key}) : super(key: key);

  @override
  State<WithdrawPage> createState() => _WithdrawPageState();
}

class _WithdrawPageState extends State<WithdrawPage> {
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _pwController = TextEditingController();
  String? _errorText;

  @override
  void dispose() {
    _idController.dispose();
    _pwController.dispose();
    super.dispose();
  }

  void _onConfirm() {
    final id = _idController.text.trim();
    final pw = _pwController.text;

    if (id.isEmpty || pw.isEmpty) {
      setState(() {
        _errorText = '아이디와 비밀번호를 모두 입력해주세요.';
      });
      return;
    }

    // TODO: 실제 탈퇴 API 호출 후 성공 시
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const WithdrawCompletePage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('회원탈퇴', style: TextStyle(color: Colors.black87)),
        backgroundColor: Colors.white,
        elevation: 1,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black87),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '회원탈퇴 진행을 위해 아이디 및 비밀번호를\n다시 한 번 입력해주세요',
              style: TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 24),

            // 아이디 입력
            TextField(
              controller: _idController,
              decoration: InputDecoration(
                hintText: '아이디',
                contentPadding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(4)),
              ),
            ),
            const SizedBox(height: 16),

            // 비밀번호 입력
            TextField(
              controller: _pwController,
              obscureText: true,
              decoration: InputDecoration(
                hintText: '비밀번호',
                contentPadding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(4)),
              ),
            ),
            const SizedBox(height: 24),

            // 버튼
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      backgroundColor: Colors.grey.shade300,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child:
                    const Text('취소', style: TextStyle(color: Colors.black87)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _onConfirm,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green.shade200,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child:
                    const Text('확인', style: TextStyle(color: Colors.black87)),
                  ),
                ),
              ],
            ),

            // 에러 메시지
            if (_errorText != null) ...[
              const SizedBox(height: 12),
              Text(
                _errorText!,
                style: const TextStyle(color: Colors.red, fontSize: 12),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
