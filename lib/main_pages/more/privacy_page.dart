import 'package:flutter/material.dart';

class PrivacyPage extends StatelessWidget {
  const PrivacyPage({Key? key}) : super(key: key);

  static const _privacyText = '''
개인정보 처리방침

골프코치앱(이하 “제공자”)는 이용자의 개인정보를 소중히 다루며, 『개인정보 보호법』 및 관련 법령을 준수하고 있습니다. 본 개인정보 처리방침은 회사가 제공하는 "골프 코치" 앱 서비스(이하 “서비스”)에서 처리하는 개인정보의 수집·이용·제공 등에 관한 사항을 규정합니다.

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
''';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('개인정보 처리방침', style: TextStyle(color: Colors.black87)),
        backgroundColor: Colors.white,
        elevation: 1,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black87),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Text(
          _privacyText,
          style: const TextStyle(fontSize: 14, height: 1.6),
        ),
      ),
    );
  }
}
