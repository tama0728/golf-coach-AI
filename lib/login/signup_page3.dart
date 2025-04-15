import 'package:flutter/material.dart';
import 'login_page.dart';

class SignupPage3 extends StatefulWidget {
  @override
  _SignupPage3State createState() => _SignupPage3State();
}

class _SignupPage3State extends State<SignupPage3> {
  final _nicknameController = TextEditingController();
  final _heightController = TextEditingController();
  final _experienceController = TextEditingController();
  String? _battingDirection; // '좌' or '우'

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('회원가입')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView(
          children: [
            // 닉네임 + 중복확인
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _nicknameController,
                    decoration: InputDecoration(
                      labelText: '닉네임',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    print('중복확인 클릭');
                  },
                  child: Text('중복확인'),
                ),
              ],
            ),
            SizedBox(height: 24),

            // 타석 방향
            Text('당신의 타석 방향은?', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildToggleButton('좌'),
                _buildToggleButton('우'),
              ],
            ),
            SizedBox(height: 24),

            // 키 입력
            Text('당신의 키는?', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            SizedBox(height: 12),
            TextField(
              controller: _heightController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: '키 (cm)',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 24),

            // 구력 입력
            Text('당신의 구력은?', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            SizedBox(height: 12),
            TextField(
              controller: _experienceController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: '개월 수',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 32),
          ],
        ),
      ),

      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SizedBox(
          width: double.infinity,
          height: 48,
          child: ElevatedButton(
            onPressed: () {
              // print('다음 단계로 이동');
              // print('닉네임: ${_nicknameController.text}');
              // print('타석 방향: $_battingDirection');
              // print('키: ${_heightController.text}');
              // print('구력: ${_experienceController.text}');
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LoginPage()),
              );
            },
            child: Text('로그인하러 가기'),
          ),
        ),
      ),

    );
  }

  Widget _buildToggleButton(String label) {
    final isSelected = _battingDirection == label;
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: isSelected ? Colors.blue : Colors.grey[300],
        foregroundColor: isSelected ? Colors.white : Colors.black,
      ),
      onPressed: () {
        setState(() {
          _battingDirection = label;
        });
      },
      child: Text(label),
    );
  }
}
