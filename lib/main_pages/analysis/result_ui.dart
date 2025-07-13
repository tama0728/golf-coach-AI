import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:http_parser/http_parser.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_player/video_player.dart';
import 'package:archive/archive.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:golf_coach_app/main_pages/main_page.dart';

class ResultUIPage extends StatefulWidget {
  final String _videoPath;

  const ResultUIPage(this._videoPath);

  @override
  _ResultUIPageState createState() => _ResultUIPageState();
}

class SwingAnalysis {
  final String swingPart;
  final String posture;
  final String evaluation;

  SwingAnalysis({
    required this.swingPart,
    required this.posture,
    required this.evaluation,
  });

  factory SwingAnalysis.fromJson(Map<String, dynamic> json) {
    return SwingAnalysis(
      swingPart: json['swing_part'] ?? 'Unknown Part',
      posture: json['posture'] ?? 'No Posture',
      evaluation: json['evaluation'] ?? 'No Evaluation',
    );
  }
}

class _ResultUIPageState extends State<ResultUIPage> {
  Map<String, dynamic>? _resultJsonData;
  bool _isLoaded = false;
  String? _errorMessage;
  VideoPlayerController? _controller;
  File? _videoFile;
  String? fileId;

  File _addressImageFile = File('');
  File _topImageFile = File('');
  File _contactImageFile = File('');

  bool _isAddressImageLoading = false;
  bool _isTopImageLoading = false;
  bool _isContactImageLoading = false;

  // bool _isZipLoading = false;
  bool _isSwingAnalysis = false;
  List<SwingAnalysis> _swingAnalysisList = [];

  @override
  void initState() {
    super.initState();
    // _fetchResultData();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: const CustomAppBar(),
        body: Column(
          children: [
            Divider(height: 1, thickness: 1),
            CustomTabBar(),
            Divider(height: 1, thickness: 1),
            Expanded(
              child: TabBarView(
                children: [
                  ResultTabPage(  // Address
                      part: 'ADDRESS',
                      imageFile: _addressImageFile ?? File(''),
                      swingAnalysisList: _swingAnalysisList.where((analysis) => analysis.swingPart == 'ADDRESS').toList()
                  ),
                  ResultTabPage(  // Top
                      part: 'TOP',
                      imageFile: _topImageFile ?? File(''),
                      swingAnalysisList: _swingAnalysisList.where((analysis) => analysis.swingPart == 'TOP').toList()
                  ),
                  ResultTabPage(  // Contact
                      part: 'CONTACT',
                      imageFile: _contactImageFile ?? File(''),
                      swingAnalysisList: _swingAnalysisList.where((analysis) => analysis.swingPart == 'CONTACT').toList()
                  ),
                ],
              ),
            ),
            DiagnosisButtonSection(),
          ],
        ),
      ),
    );
  }
}

// ================= AppBar 위젯 =================
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(70);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      toolbarHeight: 70,
      title: const Text(
        '분석결과',
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
      backgroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
      iconTheme: const IconThemeData(color: Colors.black87),
      actions: [
        IconButton(
          icon: const Icon(Icons.close),
          onPressed: () {
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => MainPage()),
                  (route) => false, // 이전 페이지 모두 제거
            );
          },
        ),
      ],
    );
  }
}

// ================= TabBar 위젯 =================
class CustomTabBar extends StatelessWidget {
  const CustomTabBar({super.key});

  @override
  Widget build(BuildContext context) {
    return const TabBar(
      labelColor: Colors.black,
      indicatorColor: Colors.black,
      indicatorSize: TabBarIndicatorSize.tab,
      tabs: [
        Tab(text: 'ADDRESS'),
        Tab(text: 'TOP'),
        Tab(text: 'CONTACT'),
      ],
    );
  }
}

// ================= Motion Result 위젯 =================
class ResultTabPage extends StatelessWidget {
  final String part;
  final File imageFile;
  final List<SwingAnalysis> swingAnalysisList;
  late final String comment;
  late final double score;

  ResultTabPage({
    super.key,
    required this.part,
    required this.imageFile,
    required this.swingAnalysisList,
  }) {
    var score_table = {
      'correct_midpoint': 15,
      'correct_arm_angle': 20,
      'correct_pelvis': 25,
      'correct_head': 15,
      'correct_shoulder_ankle': 15,
      'correct_knee_angle': 10
    };

    double totalScore = 0;
    double maxScore = 0;
    for (final analysis in swingAnalysisList) {
      // 예시: 각 스윙 파트에 따라 점수를 계산
      if (analysis.evaluation.contains('정확')) {
        totalScore += score_table[analysis.posture] ?? 0;
      } else {
        maxScore += score_table[analysis.posture] ?? 0;
      }
    }
    maxScore += totalScore;
    if (totalScore != 0) {
      totalScore = (totalScore / maxScore) * 100; // 백분율로 변환
    }
    print('Total Score: $totalScore');

    String tempComment = '스윙 분석 결과: ';
    if (totalScore >= 80) {
      tempComment += '훌륭합니다!';
    } else if (totalScore >= 50) {
      tempComment += '좋습니다.';
    } else if (totalScore >= 30) {
      tempComment += '보통입니다.';
    } else {
      tempComment += '개선이 필요합니다.';
    }
    score = totalScore;
    comment = tempComment;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                comment,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '($score점)',
                style: const TextStyle(
                  fontSize: 18,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Container(
              // height: 250,
              width: double.infinity,
              color: Colors.grey[300],
              child: Center(
                child: Image.file(imageFile, width: double.infinity, fit: BoxFit.contain),
                // Text(
                //   '이미지 자리',
                //   style: TextStyle(color: Colors.black54),
                // ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          for (final analysis in swingAnalysisList)
            Text(
              analysis.evaluation,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black87,
              ),
            ),
        ],
      ),
    );
  }
}
// 하단 진단결과보기 버튼
class DiagnosisButtonSection extends StatelessWidget {
  const DiagnosisButtonSection({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
          context: context,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          isScrollControlled: true,
          builder: (context) => DiagnosisBottomSheet(
            score: 84,
            videoPath: '동영상 경로',
          )
        );
      },
      child: Container(
        color: const Color(0xFFE6F5E6),
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 14),
        child: Column(
          children: const [
            Icon(
              Icons.arrow_drop_up,
              color: Colors.black,
              size: 50,
            ),
            Text(
              '진단결과보기',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// 진단결과 버튼 클릭시 올라오는 바텀시트
class DiagnosisBottomSheet extends StatelessWidget {
  final int score;
  final String videoPath;

  const DiagnosisBottomSheet({
    super.key,
    required this.score,
    required this.videoPath,
  });

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.8,
      minChildSize: 0.3,
      maxChildSize: 0.95,
      builder: (context, scrollController) {
        return Container(
          color: Colors.white,
          child: ListView(
            controller: scrollController,
            children: [
              const ColoredBox(
                color: Color(0xFFE6F5E6),
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Center(
                    child: Text(
                      '진단 결과',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  '스윙 점수 : ${score}점',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                      height: 250,
                      width: double.infinity,
                      color: Colors.grey[300],
                      child: const Center(
                        child:
                        Text(
                          '동영상 자리',
                          style: TextStyle(color: Colors.black54),
                        ),
                      ),
                    ),
                  ),
                ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }
}




