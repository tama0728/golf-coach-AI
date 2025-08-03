import 'package:flutter/material.dart';
import 'notice_detail_page.dart';

class NoticePage extends StatefulWidget {
  const NoticePage({Key? key}) : super(key: key);

  @override
  State<NoticePage> createState() => _NoticePageState();
}

class _NoticePageState extends State<NoticePage> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedFilter = '제목';
  final _filterOptions = ['제목', '내용'];
  final List<String> _notices = [
    '공지사항1',
    '공지사항2',
    '공지사항3',
    '공지사항4',
    '공지사항5',
    '공지사항6',
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        toolbarHeight: 70,
        title: const Text('공지사항',
            style: TextStyle(fontSize: 20,
              fontWeight: FontWeight.bold,)
        ),
        backgroundColor: Colors.white,
        elevation: 1,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black87),
      ),
      body: Column(
        children: [
          // ... (필터 박스 생략) ...
          const Divider(height: 1, thickness: 1),
          Expanded(
            child: ListView.separated(
              itemCount: _notices.length,
              separatorBuilder: (_, __) => const Divider(height: 1, thickness: 1),
              itemBuilder: (context, idx) {
                return ListTile(
                  contentPadding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                  title: Text(_notices[idx],
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 19,
                    ),
                  ),
                  trailing: const Icon(Icons.chevron_right, size: 35),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => NoticeDetailPage(
                          notices: _notices,
                          index: idx,
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
