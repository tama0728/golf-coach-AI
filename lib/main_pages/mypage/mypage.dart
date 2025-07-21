import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'edit_body_info.dart';
import '../../providers/profile_image_provider.dart';

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
class BodyInfoHeader extends StatefulWidget {
  final String username;
  final String swingDir;

  const BodyInfoHeader({
    required this.username,
    required this.swingDir,
    super.key,
  });

  @override
  State<BodyInfoHeader> createState() => _BodyInfoHeaderState();
}

class _BodyInfoHeaderState extends State<BodyInfoHeader> {
  // 홈 -> 마이페이지 이동시 프로필 사진 profile1.png로 변경되는 문제 해결
  late String selectedImage;

  @override
  void initState() {
    super.initState();
    final provider = Provider.of<ProfileImageProvider>(context, listen: false);
    selectedImage = provider.imagePath;
  }

  void _selectProfileImage() {
    showModalBottomSheet(
      context: context,
      builder: (_) => SizedBox(
        height: 150,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildProfileOption('assets/profile/profile1.png'),
            _buildProfileOption('assets/profile/profile2.png'),
            _buildProfileOption('assets/profile/profile3.png'),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileOption(String path) {
    return GestureDetector(
      onTap: () {
        // 프로필 이미지 변경 상태 저장
        Provider.of<ProfileImageProvider>(context, listen: false).setImagePath(path);
        setState(() {
          selectedImage = path;
        });
        Navigator.pop(context);
      },
      child: CircleAvatar(
        radius: 30,
        backgroundImage: AssetImage(path),
      ),
    );
  }

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
          const SizedBox(height: 16),
          Row(
            children: [
              // 프로필 사진
              GestureDetector(
                onTap: _selectProfileImage,
                child: CircleAvatar(
                  radius: 24,
                  backgroundImage: AssetImage(selectedImage),
                ),
              ),
              const SizedBox(width: 12),
              // 닉네임 / 방향
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${widget.username} / ${widget.swingDir}',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
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

// 3. 분석결과 리스트 항목 위젯
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

// 프로필 이미지 선택
class ProfileImageSelector extends StatefulWidget {
  const ProfileImageSelector({super.key});

  @override
  State<ProfileImageSelector> createState() => _ProfileImageSelectorState();
}

class _ProfileImageSelectorState extends State<ProfileImageSelector> {
  final List<String> imagePaths = [
    'assets/profile1.png',
    'assets/profile2.png',
    'assets/profile3.png',
  ];

  String selectedImage = 'assets/profile1.png'; // 기본 이미지

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 40,
          backgroundImage: AssetImage(selectedImage),
        ),
        SizedBox(height: 10),
        Wrap(
          spacing: 10,
          children: imagePaths.map((path) {
            return GestureDetector(
              onTap: () {
                setState(() {
                  selectedImage = path;
                });
              },
              child: CircleAvatar(
                radius: 25,
                backgroundImage: AssetImage(path),
                // 선택된 항목 표시 테두리
                child: selectedImage == path
                    ? Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.green, width: 3),
                  ),
                )
                    : null,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

