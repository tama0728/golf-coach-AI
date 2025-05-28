import 'package:flutter/material.dart';

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
          // 상단정보, Padding 안쪽 내용
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 40, 20, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '신체정보',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildInfoItem('스윙 방향', '우타'),
                    _buildInfoItem('평균 타수', '100타'),
                    _buildInfoItem('구력', '6개월'),
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

  // 신체정보 항목
  Widget _buildInfoItem(String label, String value) {
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