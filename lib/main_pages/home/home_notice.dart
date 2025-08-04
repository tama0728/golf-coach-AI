import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../more/notice/notice.dart';
import '../more/notice/notice_detail_page.dart';

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

Future<List<NoticeListItem>> fetchRecentNotices() async {
  final host = dotenv.get('HOSTIP');
  final response = await http.get(Uri.parse('http://$host:3000/notice/list'));
  if (response.statusCode == 200) {
    List data = json.decode(response.body);
    List<NoticeListItem> allNotices =
        data.map((e) => NoticeListItem.fromJson(e)).toList();
    allNotices.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return allNotices.take(3).toList();
  } else {
    throw Exception('공지사항을 불러오지 못했습니다');
  }
}

String formatDate(String? isoString) {
  if (isoString == null || isoString.isEmpty) return '';
  final dateTime = DateTime.parse(isoString);
  return DateFormat('yyyy.MM.dd HH:mm').format(dateTime);
}

class NoticeTitleInteractive extends StatefulWidget {
  final String title;
  final VoidCallback onTap;
  const NoticeTitleInteractive(
      {required this.title, required this.onTap, Key? key})
      : super(key: key);

  @override
  State<NoticeTitleInteractive> createState() => _NoticeTitleInteractiveState();
}

class _NoticeTitleInteractiveState extends State<NoticeTitleInteractive> {
  bool _pressed = false;

  void _setPressed(bool pressed) {
    if (_pressed != pressed) {
      setState(() {
        _pressed = pressed;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Color color = _pressed ? Colors.green.shade400 : Colors.transparent;
    return GestureDetector(
      onTap: widget.onTap,
      onTapDown: (_) => _setPressed(true),
      onTapUp: (_) => _setPressed(false),
      onTapCancel: () => _setPressed(false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        color: color,
        padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 2),
        child: Text(
          widget.title,
          style: const TextStyle(
            fontSize: 15,
            color: Colors.black87,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }
}

// 공지사항 섹션 위젯
Widget buildNoticeSection(BuildContext context) {
  return Container(
    margin: const EdgeInsets.only(top: 20),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              '공지사항',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const NoticePage(),
                  ),
                );
              },
              child: const Text(
                '더보기',
                style: TextStyle(
                  color: Colors.green,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        FutureBuilder<List<NoticeListItem>>(
          future: fetchRecentNotices(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return const Center(
                child: Text('공지사항을 불러올 수 없습니다.'),
              );
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(
                child: Text('공지사항이 없습니다.'),
              );
            } else {
              return Column(
                children: snapshot.data!
                    .map((notice) => Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: NoticeTitleInteractive(
                                      title: notice.title,
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                NoticeDetailPage(
                                              noticeId: notice.noticeId,
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Text(
                                    formatDate(notice.createdAt),
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            if (notice != snapshot.data!.last)
                              Divider(color: Colors.grey.shade300),
                          ],
                        ))
                    .toList(),
              );
            }
          },
        ),
      ],
    ),
  );
}
