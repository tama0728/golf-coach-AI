// lib/main_pages/more/withdraw_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import '../../login/login_page.dart';

class WithdrawPage extends StatefulWidget {
  const WithdrawPage({Key? key}) : super(key: key);

  @override
  State<WithdrawPage> createState() => _WithdrawPageState();
}

class _WithdrawPageState extends State<WithdrawPage> {
  final _storage = const FlutterSecureStorage();
  bool _isLoading = false;
  String? token;
  String? userId;

  Future<void> _handleWithdraw() async {
    // 1) 탈퇴 확인 다이얼로그
    final confirm = await showDialog<bool>(
      context: context,
      builder: (c) => AlertDialog(
        title: const Text('회원탈퇴'),
        content: const Text('계정을 삭제하면 복구할 수 없습니다.\n정말 탈퇴하시겠습니까?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(c, false), child: const Text('취소')),
          TextButton(onPressed: () => Navigator.pop(c, true), child: const Text('탈퇴', style: TextStyle(color: Colors.red))),
        ],
      ),
    );
    if (confirm != true) return;

    setState(() => _isLoading = true);

    try {
      // 2) token 가져오기 (로그인 때 저장해두었다고 가정)
      final token = await _storage.read(key: 'jwt_token');
      print('🔨 탈퇴 시도하는 token=$token');
      if (token == null) throw 'token 찾을 수 없습니다.';

      // 3) API 호출: DELETE /users/:id
      final host = dotenv.get('HOSTIP'); // .env: HOSTIP=golf-coach.duckdns.org:3000
      final url = Uri.parse('http://$host/users/me');
      final resp = await http.delete(
        url,
        headers: {'Authorization': 'Bearer $token'},
      );
      print('🔨 탈퇴 요청 URL = $url');

      if (resp.statusCode == 200) {
        // 4) 토큰 & user_id 삭제
        await _storage.delete(key: 'jwt_token');

        // 5) 로그인 페이지로 이동 (스택 모두 지움)
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => LoginPage()),
              (route) => false,
        );
      } else {
        _showError('탈퇴 실패: ${resp.statusCode}');
      }
    } catch (e) {
      _showError('네트워크 오류: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _showError(String msg) {
    showDialog(
      context: context,
      builder: (c) => AlertDialog(
        title: const Text('Error'),
        content: Text(msg),
        actions: [
          TextButton(onPressed: () => Navigator.pop(c), child: const Text('OK')),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('회원탈퇴', style: TextStyle(color: Colors.black87)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black87),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: _isLoading
              ? const CircularProgressIndicator()
              : Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                '계정을 삭제하면 복구할 수 없습니다.\n정말 탈퇴하시겠습니까?',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                    minimumSize: const Size.fromHeight(48),
                  ),
                  onPressed: _handleWithdraw,
                  child: const Text('탈퇴하기', style: TextStyle(color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
      backgroundColor: Colors.white,
    );
  }
}
