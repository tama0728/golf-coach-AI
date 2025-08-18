import 'package:flutter/material.dart';
import 'signup_page2.dart';

class SignupPage1 extends StatefulWidget {
  @override
  _SignupPage1State createState() => _SignupPage1State();
}

class _SignupPage1State extends State<SignupPage1> {
  bool agreeAll = false;
  bool agree1 = false;
  bool agree2 = false;

  void _toggleAll(bool? val) {
    setState(() {
      agreeAll = val ?? false;
      agree1 = agreeAll;
      agree2 = agreeAll;
    });
  }

  Widget _buildTermTile({
    required String title,
    required bool value,
    required Function(bool?) onChanged,
    required String content,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Checkbox(value: value, onChanged: onChanged),
            Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        Container(
          height: 300,
          width: 500,
          padding: EdgeInsets.all(8),
          margin: EdgeInsets.only(bottom: 20),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(8),
          ),
          child: SingleChildScrollView(
            child: Text(content),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    agreeAll = agree1 && agree2;

    return Scaffold(
      appBar: AppBar(title: Text('회원가입')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Row(
              children: [
                Checkbox(value: agreeAll, onChanged: _toggleAll),
                Text('전체 동의하기',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ],
            ),
            Divider(thickness: 1.2),
            _buildTermTile(
              title: '[필수] 어플 이용약관',
              value: agree1,
              onChanged: (val) => setState(() => agree1 = val ?? false),
              content: '''
골프 코치 앱 서비스 이용약관 (버전 1.0.0)

제1조(목적)
본 약관은 골프 코치 앱(이하 “제공자”)이 제공하는 골프 코치 앱 서비스(이하 “서비스”)의 이용과 관련하여 회사와 이용자의 권리·의무 및 책임사항, 기타 필요한 사항을 규정함을 목적으로 합니다.

제2조(정의)
1. “앱”이란 제공자가 제공하는 골프 코치 모바일 애플리케이션 일체를 말합니다.  
2. “이용자”란 본 약관에 따라 회사가 제공하는 서비스를 받는 회원 및 비회원을 말합니다.

제3조(약관의 게시 및 개정)
1. 제공자는 본 약관을 앱에 게시합니다.  
2. 제공자는 관련 법령을 위배하지 않는 범위에서 본 약관을 개정할 수 있으며, 개정 시 적용일자 및 개정사유를 명시하여 그 7일 전부터 공지합니다.

제4조(서비스의 제공 및 변경)
1. 제공자는 다음과 같은 서비스를 제공합니다.  
   1) 레슨 예약 및 관리  
   2) 스윙 영상 업로드 및 분석  
2. 회사는 서비스 개선을 위해 일부 기능을 통·폐합하거나 변경할 수 있습니다.  

제5조(서비스 이용요금)
1. 기본 서비스는 무료로 제공됩니다.  
2. 유료 부가서비스가 추가될 경우 별도의 요금제 안내 후 이용자가 동의한 경우에만 과금됩니다.

제6조(회원가입)
1. 이용자는 이메일, 비밀번호 등 필수 정보를 입력하여 회원가입을 신청합니다.  
2. 제공자는 신청 내용 확인 후 가입을 승낙하며, 부정 사용자에 대해서는 승낙을 거부할 수 있습니다.

제7조(회원 탈퇴 및 자격 상실)
1. 회원은 언제든지 탈퇴를 요청할 수 있으며, 회사는 즉시 처리합니다.  
2. 타인의 정보를 도용하거나 약관 위반 시 회사는 사전 통지 없이 서비스 이용을 제한하거나 자격을 상실시킬 수 있습니다.

제8조(이용자의 의무)
1. 이용자는 비밀번호 관리 책임을 지며, 제3자에게 이용을 허락해서는 안 됩니다.  
2. 모든 게시물·정보는 사실에 기반해야 하며, 타인의 권리를 침해해서는 안 됩니다.

제9조(회사의 의무)
1. 제공자는 안정적인 서비스 제공을 위해 최선을 다합니다.  
2. 서비스 장애 발생 시 신속히 복구 조치를 취합니다.

제10조(저작권의 귀속 및 이용제한)
1. 서비스 내 모든 저작물의 저작권은 회사 또는 원저작권자에게 귀속됩니다.  
2. 이용자는 게시된 정보를 무단 복제·배포할 수 없습니다.

제11조(분쟁해결)
1. 제공자와 이용자 간 분쟁 발생 시 상호 협의로 해결하며, 협의가 어려울 경우 서울중앙지방법원을 1심 관할법원으로 합니다.

부칙  
이 약관은 2025년 8월 1일부터 적용됩니다.
''',
            ),
            _buildTermTile(
              title: '[필수] 개인정보 수집 및 이용',
              value: agree2,
              onChanged: (val) => setState(() => agree2 = val ?? false),
              content: '''
개인정보 처리방침

골프코치앱(이하 “제공자”)는 이용자의 개인정보를 소중히 다루며, 『개인정보 보호법』 및 관련 법령을 준수하고 있습니다. 
본 개인정보 처리방침은 회사가 제공하는 "골프 코치" 앱 서비스(이하 “서비스”)에서 처리하는 개인정보의 수집·이용·제공 등에 관한 사항을 규정합니다.

제1조 (처리하는 개인정보의 항목)
1. 회원가입 및 관리
   - 필수수집항목: 이메일, 비밀번호(암호화 저장), 이름, 휴대전화번호
   - 선택수집항목: 키, 골프 스윙 손잡이(좌/우)
2. 로그인 및 인증
   - JWT 토큰, 자동로그인 설정 정보
3. 서비스 이용 기록
   - 접속 로그, 기기정보(OS, 버전), IP 주소, 이용 일시

제2조 (개인정보의 수집방법)
- 회원가입, 서비스 이용, 고객문의, 이벤트 응모 시 이용자가 직접 입력
- 자동 생성 정보(로그인 기록, 기기정보 등)

제3조 (개인정보 처리목적)
제공자는 수집한 개인정보를 다음의 목적을 위해 처리합니다.
1. 회원관리: 회원제 서비스 제공 및 본인 식별·인증, 부정이용 방지
2. 서비스 제공 및 개선: 맞춤형 콘텐츠 제공, 서비스 분석·개선
3. 문의 처리: 고객 문의·불만 처리, 민원사항 답변

제4조 (개인정보의 보유 및 이용기간)
- 회원가입일로부터 서비스 탈퇴 시까지 보유·이용
- 탈퇴 요청 시 지체 없이 해당 개인정보를 파기
- 단, 관련 법령에 따라 보관할 필요가 있는 경우 일정 기간 보관 후 파기

제5조 (개인정보 파기절차 및 방법)
1. 파기절차: 회원 탈퇴, 개인정보 보유기간 만료 등
2. 파기방법: 전자적 파일은 복구 불가능한 방법으로 영구 삭제

제6조 (제3자 제공 및 위탁)
- 제공자는 원칙적으로 이용자의 개인정보를 제3자에게 제공하지 않습니다.
- 외부 전문 업체에 위탁 시 사전에 고지하며, 위탁계약 시 개인정보 보호를 위한 관리·감독을 진행합니다.

제7조 (정보주체의 권리·의무 및 행사방법)
- 이용자는 언제든지 개인정보 열람·정정·삭제·처리정지 요청 가능
- 권리 행사는 개인정보 보호책임자에게 서면, 이메일 등으로 요청
- 이용자가 개인정보 오류 정정을 요청한 경우는 지체 없이 정정 처리

제8조 (개인정보 안전성 확보 조치)
- 관리적 조치: 내부관리계획 수립·시행, 직원 교육
- 기술적 조치: 개인정보 접근 통제, 암호화, 보안 프로그램 설치

부칙
본 방침은 2025년 8월 1일부터 시행합니다.
''',
            ),
          ],
        ),
      ),

      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SizedBox(
          width: double.infinity,
          height: 48,
          child: ElevatedButton(
            onPressed: (agree1 && agree2)
                ? () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SignupPage2()),
                    );
                  }
                : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: (agree1 && agree2) ? Color(0xFF6750A4) : null,
              foregroundColor: Colors.white,
              textStyle: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            child: const Text('다음으로'),
          ),
        ),
      ),
    );
  }
}