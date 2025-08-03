import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:intl/intl.dart';

class NoticeDetail {
  final int noticeId;
  final String title;
  final String content;
  final String adminEmail;
  final String createdAt;
  final int views;

  NoticeDetail({
    required this.noticeId,
    required this.title,
    required this.content,
    required this.adminEmail,
    required this.createdAt,
    required this.views,
  });

  factory NoticeDetail.fromJson(Map<String, dynamic> json) {
    return NoticeDetail(
      noticeId: json['notice_id'],
      title: json['title'],
      content: json['content'],
      adminEmail: json['admin_email'],
      createdAt: json['created_at'],
      views: json['views'],
    );
  }
}

class NoticeDetailPage extends StatelessWidget {
  final int noticeId;
  const NoticeDetailPage({Key? key, required this.noticeId}) : super(key: key);

  Future<NoticeDetail> fetchNoticeDetail() async {
    final host = dotenv.get('HOSTIP');
    final response =
        await http.get(Uri.parse('http://$host:3000/notice/$noticeId'));
    if (response.statusCode == 200) {
      return NoticeDetail.fromJson(json.decode(response.body));
    } else {
      throw Exception('공지사항 상세를 불러오지 못했습니다');
    }
  }

  String formatDate(String? isoString) {
    if (isoString == null || isoString.isEmpty) return '';
    final dateTime = DateTime.parse(isoString);
    return DateFormat('yyyy.MM.dd HH:mm').format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('공지사항', style: TextStyle(color: Colors.black87)),
        backgroundColor: Colors.white,
        elevation: 1,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black87),
      ),
      body: FutureBuilder<NoticeDetail>(
        future: fetchNoticeDetail(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.hasError) {
            return Center(child: Text('공지사항을 불러오지 못했습니다'));
          }
          final notice = snapshot.data!;
          return Padding(
            padding: const EdgeInsets.all(16),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // 제목 박스
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE8F4EA),
                      border: Border.all(color: Colors.green),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Text(
                        notice.title,
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // 메타 정보
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('작성자 : ${notice.adminEmail}'),
                        const SizedBox(height: 4),
                        Text('작성일 : ${formatDate(notice.createdAt)}'),
                        const SizedBox(height: 4),
                        Text('조회수 : ${notice.views}'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  // 내용
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(notice.content),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      backgroundColor: Colors.white,
    );
  }
}
