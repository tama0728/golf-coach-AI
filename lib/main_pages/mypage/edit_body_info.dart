import 'package:flutter/material.dart';

class EditBodyInfoPage extends StatelessWidget {
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _experienceController = TextEditingController();

  EditBodyInfoPage({super.key});

  Widget _buildToggleButton(String label) {
    return ElevatedButton(
      onPressed: () {
        // 토글 동작 구현
      },
      child: Text(
        label,
        style: TextStyle(fontSize: 18),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 70,
        title: const Text(
          '신체정보 수정',
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
      backgroundColor: Colors.white,

      body: Column(
        children: [
          const Divider(height: 1, thickness: 1),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: ListView(
                children: [
                  const SizedBox(height: 6),

                  const Text(
                    '당신의 타석 방향은?',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildToggleButton('좌'),
                      _buildToggleButton('우'),
                    ],
                  ),
                  const SizedBox(height: 24),

                  const Text(
                    '당신의 키는?',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _heightController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      hintText: '키 (cm)',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 24),

                  const Text(
                    '당신의 구력은?',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _experienceController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      hintText: '개월 수',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),

      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
          child: SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: () {
                // 저장 로직
                //print('저장됨');
                // 이전화면(마이페이지)로
                Navigator.pop(context);
              },
              child: const Text('저장하기', style: TextStyle(fontSize: 18)),
            ),
          ),
        ),
      ),
    );
  }
}
