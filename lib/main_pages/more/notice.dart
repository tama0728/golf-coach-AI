import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'notice_detail_page.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:intl/intl.dart';

class NoticeListItem {
  final int noticeId;
  final String title;
  final String createdAt;

  NoticeListItem(
      {required this.noticeId, required this.title, required this.createdAt});

  factory NoticeListItem.fromJson(Map<String, dynamic> json) {
    return NoticeListItem(
      noticeId: json['notice_id'],
      title: json['title'],
      createdAt: json['created_at'],
    );
  }
}

class NoticePage extends StatefulWidget {
  const NoticePage({Key? key}) : super(key: key);

  @override
  State<NoticePage> createState() => _NoticePageState();
}

class _NoticePageState extends State<NoticePage> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedFilter = '제목';
  final _filterOptions = ['제목', '내용'];

  @override
  void initState() {
    super.initState();
  }

  Future<List<NoticeListItem>> fetchNotices() async {
    final host = dotenv.get('HOSTIP');
    final response = await http.get(Uri.parse('http://$host:3000/notice/list'));
    if (response.statusCode == 200) {
      List data = json.decode(response.body);
      return data.map((e) => NoticeListItem.fromJson(e)).toList();
    } else {
      throw Exception('공지사항을 불러오지 못했습니다');
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  String formatDate(String? isoString) {
    if (isoString == null || isoString.isEmpty) return '';
    final dateTime = DateTime.parse(isoString);
    return DateFormat('yyyy.MM.dd HH:mm').format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        toolbarHeight: 70,
        title: const Text('공지사항',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            )),
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
            child: FutureBuilder<List<NoticeListItem>>(
              future: fetchNotices(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.hasError) {
                  return Center(child: Text('공지사항이 없습니다'));
                }
                final notices = snapshot.data!;
                return ListView.separated(
                  itemCount: notices.length,
                  separatorBuilder: (_, __) =>
                      const Divider(height: 1, thickness: 1),
                  itemBuilder: (context, idx) {
                    final notice = notices[idx];
                    return ListTile(
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                      title: Text(
                        notice.title,
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 19,
                        ),
                      ),
                      subtitle: Text(formatDate(notice.createdAt)),
                      trailing: const Icon(Icons.chevron_right, size: 35),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                NoticeDetailPage(noticeId: notice.noticeId),
                          ),
                        );
                      },
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
