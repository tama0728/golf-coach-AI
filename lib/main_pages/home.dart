import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'analysis/analysis.dart';
import 'main_page.dart';
import 'more/notice.dart';
import 'more/notice_detail_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

// VideoModel 클래스 추가
class VideoModel {
  final String title;
  final String thumbnailUrl;
  final String videoUrl;
  final String description;

  VideoModel({
    required this.title,
    required this.thumbnailUrl,
    required this.videoUrl,
    required this.description,
  });
}

class _HomePageState extends State<HomePage> {
  // 메인 색상 정의
  static const mainColor = Color(0xFFE6F5E6);

  // 기록 유무를 확인하기 위한 변수를 상태로 변경
  bool _hasRecords = false;

  // 최고 기록 데이터
  final Map<String, dynamic> bestRecord = {'date': '', 'score': 0};

  // 임시 공지사항 데이터
  final List<Map<String, String>> notices = [
    {'title': '공지사항 1', 'date': '2024.03.20'},
    {'title': '공지사항 2', 'date': '2024.03.18'},
    {'title': '공지사항 3', 'date': '2024.03.15'},
  ];

  // 추천 영상 데이터
  final List<VideoModel> recommendedVideos = [
    VideoModel(
      title: '골프 스윙의 기본',
      thumbnailUrl: 'https://img.youtube.com/vi/eDZKGr3UdaA/maxresdefault.jpg',
      videoUrl: 'https://www.youtube.com/watch?v=eDZKGr3UdaA',
      description: '골프 스윙의 기본 자세와 동작을 배워보세요.',
    ),
    VideoModel(
      title: '골프 스윙 교정',
      thumbnailUrl: 'https://img.youtube.com/vi/jWQx2f-CErU/maxresdefault.jpg',
      videoUrl: 'https://www.youtube.com/watch?v=jWQx2f-CErU',
      description: '스윙 자세 교정 방법',
    ),
    VideoModel(
      title: '골프 스윙 분석',
      thumbnailUrl: 'https://img.youtube.com/vi/eDZKGr3UdaA/maxresdefault.jpg',
      videoUrl: 'https://www.youtube.com/watch?v=eDZKGr3UdaA',
      description: '스윙 분석과 피드백',
    ),
  ];

  // 기록 시작하기 버튼 클릭 핸들러
  void _handleStartRecord() {
    // 튜토리얼 페이지로 이동 (인덱스: 1)
    MainPage.currentState?.updateIndex(1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                _buildProfileSection(context),
                const SizedBox(height: 24),
                _buildAnalysisButton(),
                const SizedBox(height: 24),
                _buildBestRecordSection(),
                const SizedBox(height: 24),
                _buildNoticeSection(),
                const SizedBox(height: 24),
                _buildRecommendedVideosSection(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProfileSection(BuildContext context) {
    return GestureDetector(
      onTap: () {
        MainPage.currentState?.updateIndex(3);
      },
      child: Row(
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
                '안녕하세요,',
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              ),
              const Text(
                '김수뭉님',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const Spacer(),
        ],
      ),
    );
  }


  Widget _buildNoticeSection() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: mainColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {
            // 더보기 탭(인덱스: 4)으로 이동
            MainPage.currentState?.updateIndex(4);
            // 공지사항 페이지로 이동
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const NoticePage()),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.campaign_outlined,
                        color: Colors.black87,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 16),
                    const Text(
                      '공지사항',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const Spacer(),
                    Row(
                      children: const [
                        Text(
                          '더보기',
                          style: TextStyle(fontSize: 14, color: Colors.black54),
                        ),
                        SizedBox(width: 4),
                        Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.black54,
                          size: 12,
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                ...notices.map(
                  (notice) => Column(
                    children: [
                      InkWell(
                        onTap: () {
                          // 공지사항 상세 페이지로 이동
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => NoticeDetailPage(
                                notices: notices
                                    .map((notice) => notice['title']!)
                                    .toList(),
                                index: notices.indexOf(notice),
                              ),
                            ),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  notice['title']!,
                                  style: const TextStyle(
                                    fontSize: 15,
                                    color: Colors.black87,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Text(
                                notice['date']!,
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      if (notice != notices.last)
                        Divider(color: Colors.grey[300], height: 1),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAnalysisButton() {
    return Container(
      width: double.infinity,
      height: 120,
      decoration: BoxDecoration(
        color: mainColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            // 분석 페이지의 인덱스는 2입니다 (홈:0, 튜토리얼:1, 분석:2, 마이페이지:3, 더보기:4)
            MainPage.currentState?.updateIndex(2);
          },
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text(
                      '스윙 분석하기',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'AI가 당신의 스윙을 분석해드립니다',
                      style: TextStyle(color: Colors.black54, fontSize: 14),
                    ),
                  ],
                ),
                const Spacer(),
                const Icon(Icons.golf_course, color: Colors.black87, size: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBestRecordSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '최고 기록',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        if (_hasRecords)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: mainColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        bestRecord['date'],
                        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${bestRecord['score']}점',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF009664),
                    ),
                  ),
                ),
              ],
            ),
          )
        else
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: mainColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              '아직 기록이 없습니다',
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
          ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _handleStartRecord,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF009664),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(_hasRecords ? '새로운 기록 시작하기' : '기록 시작하기'),
          ),
        ),
      ],
    );
  }

  Widget _buildRecommendedVideosSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '추천 영상',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 160,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: recommendedVideos.length,
            itemBuilder: (context, index) {
              final video = recommendedVideos[index];
              return GestureDetector(
                onTap: () async {
                  final Uri url = Uri.parse(video.videoUrl);
                  if (await canLaunchUrl(url)) {
                    await launchUrl(url, mode: LaunchMode.externalApplication);
                  }
                },
                child: Container(
                  width: 240,
                  margin: const EdgeInsets.only(right: 12),
                  decoration: BoxDecoration(
                    color: mainColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Stack(
                        children: [
                          ClipRRect(
                            borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(12)),
                            child: Image.network(
                              video.thumbnailUrl,
                              height: 100,
                              width: double.infinity,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  height: 100,
                                  color: Colors.grey[300],
                                  child:
                                      const Icon(Icons.video_library, size: 40),
                                );
                              },
                            ),
                          ),
                          Positioned.fill(
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.3),
                                borderRadius: const BorderRadius.vertical(
                                    top: Radius.circular(12)),
                              ),
                              child: const Center(
                                child: Icon(
                                  Icons.play_circle_outline,
                                  color: Colors.white,
                                  size: 36,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              video.title,
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 2),
                            Text(
                              video.description,
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.grey[600],
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
