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
    // 최고 점수 및 날짜 계산
    int maxScore = -1;
    String maxScoreDate = '';
    int totalScore = 0;
    for (var record in records) {
      int score = int.tryParse(record['score']!.replaceAll('점', '')) ?? 0;
      totalScore += score;
      if (score > maxScore) {
        maxScore = score;
        maxScoreDate = record['datetime']!;
      }
    }
    double avgScore = records.isNotEmpty ? totalScore / records.length : 0;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 상단정보, Padding 안쪽 내용
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 40, 20, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 라벨 한 줄
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildLabel('스윙 방향'),
                    _verticalDivider(),
                    _buildLabel('최고 점수'),
                    _verticalDivider(),
                    _buildLabel('평균 점수'),
                  ],
                ),
                SizedBox(height: 8),
                // 값 한 줄
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildValue('우타'),
                    _verticalDivider(),
                    Tooltip(
                      message: maxScoreDate.isNotEmpty ? '달성일: $maxScoreDate' : '',
                      child: _buildValue(maxScore >= 0 ? '$maxScore점' : '-'),
                    ),
                    _verticalDivider(),
                    _buildValue(records.isNotEmpty ? '${avgScore.toStringAsFixed(1)}점' : '-'),
                  ],
                ),
                SizedBox(height: 40),
              ],
            ),
          ),

          // Divider는 Padding 밖에 둬서 끝까지 퍼지게
          Divider(
            color: Color(0xFFE6F5E6),
            thickness: 15,
            height: 15,
          ),

          // 분석결과 기록 제목
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 15, 20, 0),
            child: Text(
              '분석결과 기록',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          Expanded(
            child: ListView.separated(
              padding: EdgeInsets.only(top: 10),
              itemCount: records.length,
              itemBuilder: (context, index) {
                return _buildRecordTile(
                  records[index]['datetime']!,
                  records[index]['score']!,
                );
              },
              separatorBuilder: (context, index) => Divider(
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

  // 라벨 빌더
  Widget _buildLabel(String label) {
    return SizedBox(
      width: 90,
      child: Center(
        child: Text(
          label,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: Colors.grey[800],
          ),
        ),
      ),
    );
  }

  // 값 빌더
  Widget _buildValue(String value) {
    return SizedBox(
      width: 90,
      child: Center(
        child: Text(
          value,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  // 세로 구분선
  Widget _verticalDivider() {
    return Container(
      height: 40,
      child: VerticalDivider(
        color: Colors.grey[300],
        thickness: 1.5,
        width: 30,
      ),
    );
  }

  // 분석결과 리스트 항목
  Widget _buildRecordTile(String datetime, String score) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 30, vertical: 4),
      title: Text(
        datetime,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 19,
        ),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            score,
            style: TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 21,
            ),
          ),
          SizedBox(width: 14),
          Icon(
            Icons.chevron_right,
            size: 35,
          ),
        ],
      ),
      onTap: () {
        print('클릭된 시간: $datetime');
      },
    );
  }
}