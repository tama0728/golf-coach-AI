import 'package:flutter/material.dart';

class NoticeDetailPage extends StatelessWidget {
  final List<String> notices;
  final int index;

  const NoticeDetailPage({
    Key? key,
    required this.notices,
    required this.index,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final title = notices[index];
    // 예시용 더미 데이터
    const author = '관리자';
    const date = '2025/03/25 13:08';
    const views = 17;
    final content = '여기에 $title 의 내용을 입력하세요.';

    return Scaffold(
      appBar: AppBar(
        title: Text(title, style: const TextStyle(color: Colors.black87)),
        backgroundColor: Colors.white,
        elevation: 1,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black87),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 제목 박스
              Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F4EA),
                  border: Border.all(color: Colors.green),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Text(
                    title,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // 메타 정보
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('작성자 : $author'),
                    const SizedBox(height: 4),
                    Text('작성일 : $date'),
                    const SizedBox(height: 4),
                    Text('조회수 : $views'),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // 내용
              Container(
                height: 200,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: SingleChildScrollView(child: Text(content)),
              ),
              const SizedBox(height: 16),

              // 이전글
              if (index > 0) ...[
                GestureDetector(
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (_) => NoticeDetailPage(
                          notices: notices,
                          index: index - 1,
                        ),
                      ),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text('이전글 : ${notices[index - 1]}'),
                  ),
                ),
                const SizedBox(height: 8),
              ],

              // 다음글
              if (index < notices.length - 1) ...[
                GestureDetector(
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (_) => NoticeDetailPage(
                          notices: notices,
                          index: index + 1,
                        ),
                      ),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text('다음글 : ${notices[index + 1]}'),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
      backgroundColor: Colors.white,
    );
  }
}
