// lib/main_pages/qna_page.dart

import 'package:flutter/material.dart';

class QnAPage extends StatefulWidget {
  const QnAPage({Key? key}) : super(key: key);

  @override
  State<QnAPage> createState() => _QnAPageState();
}

class _QnAPageState extends State<QnAPage>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  // 1) Q&A 탭 데이터
  final TextEditingController _searchController = TextEditingController();
  String _selectedFilter = '제목';
  final List<String> _filterOptions = ['제목', '내용'];
  final List<bool> _expanded = List<bool>.generate(6, (_) => false);
  final List<String> _questions = [
    '질문1',
    '질문2',
    '질문3',
    '질문4',
    '질문5',
    '질문6',
  ];

  // 2) 내 문의내역 탭 데이터
  final List<String> _ongoing = ['내 질문1', '내 질문2'];
  final List<String> _completed = ['완료된 질문1', '완료된 질문2'];

  // 3) 문의하기 탭 데이터
  final TextEditingController _inquiryController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    _inquiryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const lightGreen = Color(0xFFE8F4EA);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Q&A', style: TextStyle(color: Colors.black87)),
        backgroundColor: Colors.white,
        elevation: 1,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black87),
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.black87,
          unselectedLabelColor: Colors.grey,
          indicatorColor: Colors.black87,
          tabs: const [
            Tab(text: 'Q&A'),
            Tab(text: '내 문의내역'),
            Tab(text: '문의하기'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [

          // ── 1) Q&A 탭 ─────────────────────────────
          SingleChildScrollView(
            child: Column(
              children: [
                // 필터 박스
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Row(
                      children: [
                        DropdownButton<String>(
                          value: _selectedFilter,
                          underline: const SizedBox(),
                          items: _filterOptions
                              .map((opt) => DropdownMenuItem(
                              value: opt, child: Text(opt)))
                              .toList(),
                          onChanged: (val) {
                            if (val != null) {
                              setState(() => _selectedFilter = val);
                            }
                          },
                        ),
                        const VerticalDivider(color: Colors.grey),
                        Expanded(
                          child: TextField(
                            controller: _searchController,
                            decoration: const InputDecoration(
                              hintText: '검색어',
                              border: InputBorder.none,
                              isDense: true,
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.search),
                          onPressed: () {
                            // TODO: 검색 로직
                          },
                        ),
                      ],
                    ),
                  ),
                ),

                const Divider(height: 1, thickness: 1),

                // 질문 목록
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: List.generate(_questions.length, (i) {
                      return Column(
                        children: [
                          ExpansionTile(
                            key: Key('qna_$i'),
                            tilePadding: EdgeInsets.zero,
                            title: Text(_questions[i]),
                            trailing: Icon(
                              _expanded[i]
                                  ? Icons.expand_less
                                  : Icons.expand_more,
                            ),
                            onExpansionChanged: (open) {
                              setState(() => _expanded[i] = open);
                            },
                            children: [
                              Container(
                                margin:
                                const EdgeInsets.fromLTRB(0, 0, 0, 16),
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Colors.grey.shade400),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Text('답변'),
                              ),
                            ],
                          ),
                          const Divider(height: 1, thickness: 1),
                        ],
                      );
                    }),
                  ),
                ),
              ],
            ),
          ),

          // ── 2) 내 문의내역 탭 ─────────────────────────────
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '진행중인 문의',
                    style:
                    TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  ..._ongoing.map(
                        (q) => Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      padding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 16),
                      decoration: BoxDecoration(
                        color: lightGreen,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(q,
                          style: const TextStyle(color: Colors.black87)),
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    '완료된 문의',
                    style:
                    TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  ..._completed.map(
                        (q) => Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      decoration: BoxDecoration(
                        color: lightGreen,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: ExpansionTile(
                        title:
                        Text(q, style: const TextStyle(color: Colors.black87)),
                        childrenPadding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        children: const [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              '여기에 답변 내용을 표시합니다.',
                              style: TextStyle(color: Colors.black87),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ── 3) 문의하기 탭 ─────────────────────────────
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                TextField(
                  controller: _inquiryController,
                  maxLines: 6,
                  decoration: InputDecoration(
                    hintText: '문의사항을 입력하세요',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4)),
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      // TODO: 문의 제출 로직
                    },
                    child: const Text('보내기'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      backgroundColor: Colors.white,
    );
  }
}
