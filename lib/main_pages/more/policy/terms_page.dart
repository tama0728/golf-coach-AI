// lib/main_pages/more/terms_page.dart

import 'package:flutter/material.dart';

class TermsPage extends StatelessWidget {
  const TermsPage({Key? key}) : super(key: key);

  static const _terms = '''
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
''';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('서비스 이용약관', style: TextStyle(color: Colors.black87)),
        backgroundColor: Colors.white,
        elevation: 1,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black87),
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Text(
            _terms,
            style: const TextStyle(fontSize: 14, height: 1.6),
          ),
        ),
      ),
    );
  }
}
