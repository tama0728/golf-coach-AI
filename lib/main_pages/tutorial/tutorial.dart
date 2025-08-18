import 'package:flutter/material.dart';

class TutorialPage extends StatelessWidget {
  const TutorialPage({super.key});

  @override
  Widget build(BuildContext context) {
    // 최상위 토글 3개 (①/②/③)
    final roots = <ToggleNode>[
      _part1(), // ① 기본 개념 · 규칙 · 장비 (1,2,3)
      _part2(), // ② 스윙 동작 8단계 (4)
      _part3(), // ③ 매너 · 입문 과정 · 비용 · 팁 (5,6,7,8)
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('골프 입문 가이드북'),
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      body: ListView.builder(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
        itemCount: roots.length,
        itemBuilder: (_, i) => NotionToggle(node: roots[i]),
      ),
    );
  }

  // ① 기본 개념 · 규칙 · 장비 (1,2,3)
  ToggleNode _part1() {
    return ToggleNode(
      title: '① 기본 개념 · 규칙 · 장비',
      children: [
        ToggleNode(
          title: '골프란?',
          body: [
            '정해진 코스에서 최소 타수로 공을 홀컵에 넣는 스포츠',
            '개인 경기지만 매너와 규칙을 중시',
          ],
        ),
        ToggleNode(
          title: '주요 규칙과 용어',
          body: [
            '티샷(Teeshot): 각 홀의 첫 번째 샷',
            '페어웨이(Fairway): 티샷 후 공이 가는 잔디 구간',
            '그린(Green): 홀컵이 있는 짧게 깎인 잔디',
            '파(Par): 기준 타수 (예: 파4 → 4타)',
            '버디(Birdie): 기준보다 1타 적게 / 보기(Bogey): 기준보다 1타 많게',
          ],
        ),
        ToggleNode(
          title: '필수 장비',
          body: [
            '클럽: 드라이버, 아이언, 퍼터 (입문자는 최소 구성으로 시작 권장)',
            '골프공: 분실이 잦으므로 저렴한 공 추천',
            '장갑: 미끄럼 방지 및 손 보호',
            '의류: 운동복 가능, 필드에서는 단정한 복장 필요',
          ],
        ),
      ],
    );
  }

  // ② 스윙 동작 8단계 (4)
  ToggleNode _part2() {
    return ToggleNode(
      title: '② 스윙 동작 8단계',
      children: [
        ToggleNode(
          title: '어드레스 (Address)',
          body: [
            '공을 치기 전의 준비 자세',
            '스탠스(발 위치), 그립, 자세를 잡고 클럽을 공 뒤에 둠',
            '좋은 스윙의 출발점',
          ],
        ),
        ToggleNode(
          title: '테이크어웨이 (Takeaway)',
          body: [
            '어드레스에서 클럽을 뒤로 움직이는 동작',
            '클럽이 지면과 평행해질 때까지 진행',
            '“첫 단추”로 방향과 궤도를 결정',
          ],
        ),
        ToggleNode(
          title: '백스윙 (Backswing)',
          body: [
            '클럽을 머리 위까지 들어 올리는 동작',
            '상체 회전, 하체 고정, 체중 이동이 함께 일어남',
          ],
        ),
        ToggleNode(
          title: '탑 오브 스윙 (Top of Swing)',
          body: [
            '백스윙의 정점, 클럽이 가장 높이 올라간 지점',
            '다운스윙으로 전환되는 순간',
            '리듬과 균형이 중요한 구간',
          ],
        ),
        ToggleNode(
          title: '다운스윙 (Downswing)',
          body: [
            '탑에서 공 쪽으로 내려오는 동작',
            '하체 → 상체 → 팔 → 손 → 클럽 순으로 이어짐',
            '스피드와 파워가 집중되는 구간',
          ],
        ),
        ToggleNode(
          title: '임팩트 (Impact)',
          body: [
            '클럽 페이스가 공을 맞히는 순간 (타점)',
            '정확한 임팩트가 비거리와 방향성을 결정',
            '“스윗 스팟”에 맞으면 최고의 샷',
          ],
        ),
        ToggleNode(
          title: '팔로스루 (Follow Through)',
          body: [
            '임팩트 직후 클럽이 목표 방향으로 나아가는 동작',
            '샷의 궤도와 방향성을 안정시킴',
          ],
        ),
        ToggleNode(
          title: '피니시 (Finish)',
          body: [
            '스윙이 끝난 후 몸이 목표를 향한 자세',
            '체중은 앞발(오른손잡이 기준 왼발)에 실림',
            '“폼이 좋아야 샷이 좋다”가 나오는 구간',
          ],
        ),
      ],
    );
  }

  // ③ 매너 · 입문 과정 · 비용 · 팁 (5,6,7,8)
  ToggleNode _part3() {
    return ToggleNode(
      title: '③ 매너 · 입문 과정 · 비용 · 팁',
      children: [
        ToggleNode(
          title: '골프 매너',
          body: [
            '앞사람이 안전거리 확보 후 스윙',
            '플레이 중엔 조용히 (스윙/퍼팅 시 소음 자제)',
            '디봇(잔디 파인 자리)과 벙커 정리',
            '가장 멀리 있는 사람이 먼저 치는 순서 지키기',
          ],
        ),
        ToggleNode(
          title: '입문 과정',
          body: [
            '연습장에서 스윙과 타격감 익히기',
            '프로 레슨으로 기본 자세 교정',
            '스크린 골프로 실전 감각 키우기',
            '9홀/18홀 필드 라운딩 경험하기',
          ],
        ),
        ToggleNode(
          title: '비용 (평균 범위)',
          body: [
            '레슨: 월 20~50만 원',
            '연습장: 시간당 1~2만 원',
            '필드: 15~30만 원 (그린피·카트·캐디 포함)',
            '장비: 입문용 세트 50~100만 원 가능',
          ],
        ),
        ToggleNode(
          title: '입문 팁',
          body: [
            '처음엔 중고/렌탈로 시작 (과투자 방지)',
            '허리·손목 스트레칭 필수 (부상 예방)',
            '최소 3개월 이상 꾸준히 연습',
            '친구/동료와 함께 배우면 동기 부여 ↑',
          ],
        ),
      ],
    );
  }
}

/// ─────────────────────────────────────────────────
/// 데이터 모델
class ToggleNode {
  final String title;
  final List<String>? body;          // 항목형 본문 (불릿 리스트)
  final List<ToggleNode>? children;  // 하위 토글

  ToggleNode({
    required this.title,
    this.body,
    this.children,
  });
}

/// ─────────────────────────────────────────────────
/// Notion 스타일 토글 위젯 (재귀적 렌더링)
class NotionToggle extends StatefulWidget {
  final ToggleNode node;
  final int depth;

  const NotionToggle({
    super.key,
    required this.node,
    this.depth = 0,
  });

  @override
  State<NotionToggle> createState() => _NotionToggleState();
}

class _NotionToggleState extends State<NotionToggle>
    with SingleTickerProviderStateMixin {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final hasChildren = (widget.node.children?.isNotEmpty ?? false);
    final hasBody = (widget.node.body?.isNotEmpty ?? false);

    // 들여쓰기 (계층에 따른 좌측 마진)
    final leftInset = 8.0 + (widget.depth * 14.0);

    return Container(
      margin: EdgeInsets.only(left: leftInset, bottom: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        // 노션 느낌의 은은한 배경
        color: _expanded ? Colors.grey.withOpacity(0.08) : Colors.transparent,
      ),
      child: Column(
        children: [
          InkWell(
            borderRadius: BorderRadius.circular(10),
            onTap: () => setState(() => _expanded = !_expanded),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
              child: Row(
                children: [
                  // 회전하는 꺾쇠 아이콘 (닫힘: ▶, 열림: ▼ 느낌)
                  AnimatedRotation(
                    duration: const Duration(milliseconds: 160),
                    turns: _expanded ? 0.25 : 0, // 90도 회전
                    child: const Icon(Icons.chevron_right, size: 20),
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      widget.node.title,
                      style: TextStyle(
                        fontSize: widget.depth == 0 ? 18 : 16,
                        fontWeight: widget.depth == 0
                            ? FontWeight.w700
                            : FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // 펼쳐지는 본문/하위 토글
          AnimatedSize(
            duration: const Duration(milliseconds: 180),
            alignment: Alignment.topCenter,
            curve: Curves.easeInOut,
            child: _expanded
                ? Padding(
              padding: const EdgeInsets.fromLTRB(28, 2, 8, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (hasBody) ...[
                    _Bullets(widget.node.body!),
                    if (hasChildren) const SizedBox(height: 8),
                  ],
                  if (hasChildren)
                    ...widget.node.children!.map(
                          (child) => NotionToggle(
                        node: child,
                        depth: widget.depth + 1,
                      ),
                    ),
                ],
              ),
            )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}

/// 불릿 리스트 렌더러
class _Bullets extends StatelessWidget {
  final List<String> items;
  const _Bullets(this.items);

  @override
  Widget build(BuildContext context) {
    final textStyle = const TextStyle(fontSize: 15, height: 1.5);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: items
          .map(
            (t) => Padding(
          padding: const EdgeInsets.only(bottom: 6),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('•  ', style: TextStyle(fontSize: 16)),
              Expanded(child: Text(t, style: textStyle)),
            ],
          ),
        ),
      )
          .toList(),
    );
  }
}
