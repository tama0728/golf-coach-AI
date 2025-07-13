import 'package:flutter/material.dart';
import 'edit_body_info.dart';

class MyPage extends StatelessWidget {
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
          BodyInfoHeader(),
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
  const BodyInfoHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 40, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 제목 + 버튼
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '신체정보',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              IconButton(
                icon: Icon(Icons.add),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => EditBodyInfoPage()),
                  );
                },
              ),
            ],
          ),
          SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: const [
              BodyInfoItem(label: '스윙 방향', value: '우타'),
              BodyInfoItem(label: '평균 타수', value: '100타'),
              BodyInfoItem(label: '구력', value: '6개월'),
            ],
          ),
          SizedBox(height: 40),
        ],
      ),
    );
  }
}

// 2. 신체정보 항목 위젯
class BodyInfoItem extends StatelessWidget {
  final String label;
  final String value;

  const BodyInfoItem({required this.label, required this.value, super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: Colors.grey[800],
          ),
        ),
        SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

// 3. 분석결과 리스트 전체
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
