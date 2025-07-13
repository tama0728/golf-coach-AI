import 'package:flutter/material.dart';
import 'edit_body_info.dart';

class MyPage extends StatelessWidget {
  final String username = '김수뭉';
  final String swingDir = '우타';

  final List<Map<String, String>> records = [
    {'datetime': '2025/01/13 13:20:48', 'score': '70점'},
    {'datetime': '2025/02/05 17:45:17', 'score': '62점'},
    {'datetime': '2025/02/14 11:30:33', 'score': '85점'},
    {'datetime': '2025/05/20 09:40:22', 'score': '91점'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BodyInfoHeader(username: username, swingDir: swingDir),
          Divider(
            color: Color(0xFFE6F5E6),
            thickness: 15,
            height: 15,
          ),
          AnalysisResultList(records: records),
        ],
      ),
    );
  }
}

// 1. 신체정보 헤더 영역
class BodyInfoHeader extends StatelessWidget {
  final String username;
  final String swingDir;

  const BodyInfoHeader({
    required this.username,
    required this.swingDir,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 40, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 제목 + 설정 버튼
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '개인정보',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              IconButton(
                // 오른쪽 위 아이콘 + -> 톱니바퀴
                icon: Icon(Icons.settings),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => EditBodyInfoPage()),
                  );
                },
              ),
            ],
          ),
          SizedBox(height: 16),
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.grey[200],
                ),
                child: const Icon(Icons.person, size: 30, color: Colors.grey),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$username / $swingDir',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }
}

// 2. 분석결과 리스트 전체
class AnalysisResultList extends StatelessWidget {
  final List<Map<String, String>> records;

  const AnalysisResultList({required this.records, super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 15, 20, 0),
            child: Text(
              '분석결과 기록',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: ListView.separated(
              padding: EdgeInsets.only(top: 10),
              itemCount: records.length,
              itemBuilder: (context, index) => AnalysisRecordTile(
                datetime: records[index]['datetime']!,
                score: records[index]['score']!,
              ),
              separatorBuilder: (_, __) => Divider(
                color: Color(0xFFD9D9D9),
                thickness: 1,
                height: 10,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// 4. 분석결과 리스트 항목 위젯
class AnalysisRecordTile extends StatelessWidget {
  final String datetime;
  final String score;

  const AnalysisRecordTile({
    required this.datetime,
    required this.score,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 30, vertical: 4),
      title: Text(
        datetime,
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 19),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            score,
            style: TextStyle(fontWeight: FontWeight.w800, fontSize: 21),
          ),
          SizedBox(width: 14),
          Icon(Icons.chevron_right, size: 35),
        ],
      ),
      onTap: () {
        print('클릭된 시간: $datetime');
      },
    );
  }
}
