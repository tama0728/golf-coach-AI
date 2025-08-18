import 'dart:convert';
import 'package:provider/provider.dart';
import '../../login/app_start.dart';
import '../../providers/profile_image_provider.dart';

import 'package:flutter/material.dart';
import 'edit_body_info.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../analysis/result_ui.dart';

class MyPage extends StatefulWidget {
  @override
  _MyPageState createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  List<Map<String, String>> records = [];

  late final String _userEmail;
  late final String _userNickname;
  late final String _swingDir;
  final storage = FlutterSecureStorage();

  bool _isLoaded = false;
  bool _isUserInfoLoaded = false;
  bool _isRecordsLoaded = false;

  @override
  void initState() {
    super.initState();
    fetchs();
  }

  Future<void> fetchs() async {
    // 유저 정보와 스윙 방향을 가져오는 함수
    await fetchUserInfo();
    // 레코드를 가져오는 함수
    await fetchRecords();
    setState(() {
      _isUserInfoLoaded = true;
      _isRecordsLoaded = true;
    });
  }

  // 유저 정보 및 스윙 방향을 가져오는 함수
  Future<void> fetchUserInfo() async {
    try {
      final token = await storage.read(key: 'jwt_token');
      final response = await http.get(
        Uri.parse('http://${dotenv.get('HOSTIP')}:3000/users/me'),
        headers: {
          if (token != null) 'Authorization': 'Bearer $token',
        },
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          _userNickname = data['user_nickname'] ?? 'Unknown User';
          _userEmail = data['user_email'] ?? 'Unknown Email';
          _swingDir = data['batting_side'] == 0 ? '오른손' : '왼손';
          _isUserInfoLoaded = true;
          _isLoaded = true;
        });
      } else {
        throw Exception('Failed to load user info');
      }
    } catch (e) {
      print('Error fetching user info: $e');
    }
  }

  Future<void> fetchRecords() async {
    if (!_isUserInfoLoaded) {
      print('User info not loaded yet, skipping records fetch');
      return;
    }
    try {
      final response = await http.get(
        Uri.parse(
            'http://${dotenv.get('HOSTIP')}:3000/api/analysis/results?user_email=$_userEmail'),
      );

      print('Response status: ${response.statusCode}');
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body) as List<dynamic>;
        setState(() {
          for (var record in data) {
            // 각 레코드의 datetime을 'yyyy/MM/dd HH:mm:ss' 형식으로 변환
            record as Map<String, dynamic>;
            String formattedDate =
                record['analysis_date'].replaceAll('T', ' ').substring(0, 19);
            records.add({
              'fileId': record['analysis_id'],
              'datetime': formattedDate,
              'score': '${record['analysis_score']}점',
            });
          }
        });
      } else {
        throw Exception(
            'Failed to load records ${jsonDecode(response.body)['message']}');
      }
    } catch (e) {
      print('Error fetching records: $e');
      setState(() {
        records.add(
            {'fileID': 'null', 'datetime': '아직 분석 기록이 없습니다.', 'score': ''});
        _isRecordsLoaded = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_isUserInfoLoaded || !_isRecordsLoaded) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: CircularProgressIndicator(color: Colors.green),
        ),
      );
    }
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BodyInfoHeader(username: _userNickname, swingDir: _swingDir),
          UserInfoHeader(
              username: _userNickname, swingDir: _swingDir, records: records),
          // Divider는 Padding 밖에 둬서 끝까지 퍼지게
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

// 0. 닉네임 아이콘 헤더 영역
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
      onTap: () async {
        // 서버에 프로필 이미지 업데이트
        final provider =
            Provider.of<ProfileImageProvider>(context, listen: false);
        final success = await provider.updateProfileImage(path);

        if (success) {
          setState(() {
            selectedImage = path;
          });
          Navigator.pop(context);
        } else {
          // 업데이트 실패 시 스낵바 표시
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('프로필 이미지 업데이트에 실패했습니다.'),
              backgroundColor: Colors.red,
            ),
          );
        }
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
              // IconButton(
              //   icon: Icon(Icons.settings),
              //   onPressed: () {
              //     Navigator.push(
              //       context,
              //       MaterialPageRoute(builder: (context) => EditBodyInfoPage()),
              //     );
              //   },
              // ),
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
                    '${widget.username} 님',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ],
          ),
          // const SizedBox(height: 20),
        ],
      ),
    );
  }
}

// 1. 유저정보 헤더 영역
class UserInfoHeader extends StatelessWidget {
  final String username;
  String swingDir;
  final List<Map<String, String>> records;

  UserInfoHeader({
    required this.username,
    required this.swingDir,
    required this.records,
    // super.key,
  });

  @override
  Widget build(BuildContext context) {
    // 최고 점수 및 날짜 계산
    double maxScore = -1;
    String maxScoreDate = '';
    double totalScore = 0;
    for (var record in records) {
      if (!record.containsKey('score') || !record.containsKey('datetime'))
        continue;
      double score = double.tryParse(record['score']!.replaceAll('점', '')) ?? 0;
      totalScore += score;
      if (score > maxScore) {
        maxScore = score;
        maxScoreDate = record['datetime']!;
      }
    }
    double avgScore = records.isNotEmpty ? totalScore / records.length : 0;
    // 위젯 빌드
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 제목 + 설정 버튼
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //   children: [
          //     Text(
          //       '개인정보',
          //       style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          //     ),
          //     IconButton(
          //       // 오른쪽 위 아이콘 + -> 톱니바퀴
          //       icon: Icon(Icons.settings),
          //       onPressed: () {
          //         Navigator.push(
          //           context,
          //           MaterialPageRoute(builder: (context) => EditBodyInfoPage()),
          //         );
          //       },
          //     ),
          //   ],
          // ),
          // SizedBox(height: 16),
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.start,
          //   children: [
          //     Container(
          //       width: 48,
          //       height: 48,
          //       decoration: BoxDecoration(
          //         shape: BoxShape.circle,
          //         color: Colors.grey[200],
          //       ),
          //       child: const Icon(Icons.person, size: 30, color: Colors.grey),
          //     ),
          //     SizedBox(width: 12),
          //     Text(
          //       '$username 님',
          //       style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          //     ),
          //   ],
          // ),
          // SizedBox(height: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  GestureDetector(
                    onTap: () async {
                      final selected = await showModalBottomSheet<String>(
                        context: context,
                        builder: (_) => SizedBox(
                          height: 150,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              // 오른손 버튼
                              GestureDetector(
                                onTap: () {
                                  Navigator.pop(context, '오른손');
                                },
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const [
                                    // Icon(Icons.pan_tool_alt, size: 36),
                                    // SizedBox(height: 8),
                                    Text(
                                      '오른손',
                                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                                    ),
                                  ],
                                ),
                              ),
                              // 왼손 버튼
                              GestureDetector(
                                onTap: () {
                                  Navigator.pop(context, '왼손');
                                },
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const [
                                    // Icon(Icons.pan_tool, size: 36),
                                    // SizedBox(height: 8),
                                    Text(
                                      '왼손',
                                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );

                      // 선택 결과를 활용하려면 여기에 추가
                      if (selected != null) {
                        // 예시: setState(() => _selectedHand = selected);
                        swingDir = selected;
                        print('선택된 손: $swingDir');
                        final hand = swingDir == '오른손' ? 0 : 1;
                        print('스윙 방향: $hand');
                          // 스윙 방향 업데이트
                        try {
                          final token = await storage.read(key: 'jwt_token');
                          final response = await http.put(
                            Uri.parse('http://${dotenv.get('HOSTIP')}:3000/users/me/batting-side'),
                            headers: {
                              if (token != null) 'Authorization': 'Bearer $token',
                            },
                            body: json.encode({
                              'batting_side': hand,
                            }),
                          );
                          print('스윙 방향 업데이트 응답: ${response.statusCode}');
                          print('응답 본문: ${response.body}');
                          if (response.statusCode == 200) {
                          } else if (response.statusCode == 401) {
                          } else if (response.statusCode == 404) {
                          } else {
                          }
                        } catch (e) {
                        }
                      }
                    },
                    child: _buildValue(swingDir),
                  ),
                  _verticalDivider(),
                  Tooltip(
                    message:
                        maxScoreDate.isNotEmpty ? '달성일: $maxScoreDate' : '',
                    child: _buildValue(maxScore >= 0 ? '$maxScore점' : '-'),
                  ),
                  _verticalDivider(),
                  _buildValue(records.isNotEmpty
                      ? '${avgScore.toStringAsFixed(2)}점'
                      : '-'),
                ],
              ),
            ],
          ),
          SizedBox(height: 16),
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
                fileId: records[index]['fileId'] ?? 'null',
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
  final String? fileId;
  final String datetime;
  final String score;

  const AnalysisRecordTile({
    required this.fileId,
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
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
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
        if (fileId == 'null') {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('데이터가 존재하지 않습니다.')),
          );
          return;
        }
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ResultUIPage(
              fileId!,
              double.parse(score.replaceAll('점', '')),
            ),
          ),
        );
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
