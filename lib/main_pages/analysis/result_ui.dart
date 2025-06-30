import 'package:flutter/material.dart';
import 'package:golf_coach_app/main_pages/main_page.dart';

class ResultUIPage extends StatelessWidget {
  const ResultUIPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: const CustomAppBar(),
        body: Column(
          children: const [
            Divider(height: 1, thickness: 1),
            CustomTabBar(),
            Divider(height: 1, thickness: 1),
            Expanded(
              child: TabBarView(
                children: [
                  TopTabPage(
                    comment: '좋습니다',
                    score: 90,
                    imagePath: '',
                    description: '상체 회전 좋음',
                  ),
                  ContactTabPage(
                    comment: '연락점도 괜찮네요',
                    score: 87,
                    imagePath: '',
                    description: '팔의 위치가 안정적으로 유지됩니다.',
                  ),
                  AddressTabPage(
                    comment: '임팩트 좋음',
                    score: 92,
                    imagePath: '',
                    description: '하체 고정 및 체중 이동이 잘 이뤄지고 있습니다.',
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
        Tab(text: 'TOP'),
        Tab(text: 'CONTACT'),
        Tab(text: 'ADDRESS'),
      ],
    );
  }
}

// 각각의 탭 위젯 정의

class TopTabPage extends StatelessWidget {
  final String comment;
  final int score;
  final String imagePath; // 지금은 안 쓰지만 일단 받기만 함
  final String description;

  const TopTabPage({
    super.key,
    required this.comment,
    required this.score,
    required this.imagePath,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
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
              height: 250,
              width: double.infinity,
              color: Colors.grey[300], // 회색 네모
              child: const Center(
                child: Text(
                  '이미지 자리',
                  style: TextStyle(color: Colors.black54),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            description,
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

class ContactTabPage extends StatelessWidget {
  final String comment;
  final int score;
  final String imagePath;
  final String description;

  const ContactTabPage({
    super.key,
    required this.comment,
    required this.score,
    required this.imagePath,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
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
              height: 250,
              width: double.infinity,
              color: Colors.grey[300],
              child: const Center(
                child: Text(
                  '이미지 자리',
                  style: TextStyle(color: Colors.black54),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            description,
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

class AddressTabPage extends StatelessWidget {
  final String comment;
  final int score;
  final String imagePath;
  final String description;

  const AddressTabPage({
    super.key,
    required this.comment,
    required this.score,
    required this.imagePath,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
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
              height: 250,
              width: double.infinity,
              color: Colors.grey[300],
              child: const Center(
                child: Text(
                  '이미지 자리',
                  style: TextStyle(color: Colors.black54),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            description,
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
                      child: Text(
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




