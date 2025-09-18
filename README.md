# 🏌️ Golf Coach AI

AI 기반 골프 스윙 분석 및 코칭 모바일 애플리케이션

## 📖 프로젝트 개요

Golf Coach AI는 Flutter로 개발된 모바일 애플리케이션으로, AI 기술을 활용하여 골프 스윙을 분석하고 개인 맞춤형 코칭을 제공합니다. 초보자부터 중급자까지 골프 실력 향상을 위한 종합적인 솔루션을 제공합니다.

## 📦 관련 저장소

- **🏌️ Frontend (Mobile)**: [golf-coach-AI](https://github.com/your-username/golf-coach-AI) (현재 저장소)
- **🖥️ Backend Server**: [golf-coach-backend](https://github.com/tama0728/golf-coach-backend.git)

## ✨ 주요 기능

### 🎥 AI 스윙 분석
- **실시간 비디오 촬영**: 카메라를 이용한 골프 스윙 영상 촬영
- **AI 기반 분석**: 머신러닝을 통한 스윙 자세 및 동작 분석
- **비디오 편집**: 분석을 위한 영상 트리밍 및 편집 기능
- **결과 시각화**: 분석 결과를 직관적인 UI로 제공

### 🏠 홈 대시보드
- **개인 기록 관리**: 사용자의 골프 기록 및 통계 확인
- **추천 영상**: 사용자 수준에 맞는 골프 교육 영상 추천
- **공지사항**: 앱 업데이트 및 중요 정보 전달

### 📚 골프 입문 가이드북
- **기본 개념**: 골프 규칙, 용어, 장비 소개
- **스윙 동작**: 8단계 스윙 동작 상세 설명
- **매너 및 팁**: 골프 에티켓과 실전 팁 제공

### 👤 사용자 관리
- **회원가입/로그인**: 안전한 JWT 토큰 기반 인증
- **프로필 관리**: 개인 정보 및 프로필 이미지 설정
- **자동 로그인**: 보안 저장소를 통한 편리한 접근

## 🛠️ 기술 스택

### Frontend (Mobile)
- **Flutter**: 크로스 플랫폼 모바일 앱 개발
- **Dart**: 프로그래밍 언어
- **Provider**: 상태 관리
- **Camera**: 카메라 기능
- **Video Player**: 비디오 재생 및 편집

### Backend Server
- **Repository**: [golf-coach-backend](https://github.com/tama0728/golf-coach-backend.git)
- **API Communication**: REST API
- **Authentication**: JWT 토큰 기반
- **Data Storage**: 사용자 정보, 분석 결과, 영상 데이터

### Backend Integration
- **HTTP**: REST API 통신
- **JWT**: 토큰 기반 인증
- **Secure Storage**: 민감 정보 암호화 저장

### Media Processing
- **FFmpeg**: 비디오 처리 및 편집
- **Video Trimmer**: 영상 구간 편집
- **Image Picker**: 이미지/비디오 선택

## 📱 앱 구조

```
lib/
├── main.dart                   # 앱 진입점
├── login/                      # 인증 관련
│   ├── app_start.dart         # 스플래시 & 자동로그인
│   ├── login_page.dart        # 로그인 화면
│   ├── signup_page1.dart      # 회원가입 1단계
│   ├── signup_page2.dart      # 회원가입 2단계
│   ├── findID.dart            # 아이디 찾기
│   └── findPW.dart            # 비밀번호 찾기
├── main_pages/                 # 메인 기능
│   ├── main_page.dart         # 메인 네비게이션
│   ├── home/                  # 홈 화면
│   │   ├── home.dart          # 대시보드
│   │   ├── home_notice.dart   # 공지사항
│   │   └── home_video.dart    # 추천 영상
│   ├── analysis/              # AI 분석
│   │   ├── analysis.dart      # 영상 촬영/분석
│   │   ├── process.dart       # 분석 처리
│   │   ├── result.dart        # 결과 화면
│   │   └── result_ui.dart     # 결과 UI
│   ├── tutorial/              # 가이드북
│   │   └── tutorial.dart      # 골프 입문 가이드
│   ├── mypage/                # 마이페이지
│   └── more/                  # 더보기 메뉴
│       ├── account/           # 계정 관리
│       ├── notice/            # 공지사항
│       └── policy/            # 정책/약관
└── providers/                  # 상태 관리
    └── profile_image_provider.dart
```

## 🚀 시작하기

### 요구사항
- Flutter SDK 3.6.1 이상
- Dart SDK
- Android Studio / VS Code
- Android/iOS 개발 환경
- **백엔드 서버** (아래 설정 참조)

### 설치 및 실행

1. **저장소 클론**
```bash
git clone https://github.com/your-username/golf-coach-AI.git
cd golf-coach-AI
```

2. **의존성 설치**
```bash
flutter pub get
```

3. **백엔드 서버 설정**
```bash
# 백엔드 서버 저장소 클론
git clone https://github.com/tama0728/golf-coach-backend.git
cd golf-coach-backend

# 백엔드 서버 설치 및 실행 (자세한 내용은 백엔드 저장소 README 참조)
# 서버가 실행되면 기본적으로 3000 포트에서 동작
```

4. **환경 설정**
```bash
# golf-coach-AI 디렉토리로 돌아가서 .env 파일 생성
cd ../golf-coach-AI
echo "HOSTIP=localhost" > .env
# 또는 백엔드 서버가 다른 호스트에 있다면
# echo "HOSTIP=your_backend_server_ip" > .env
```

5. **앱 실행**
```bash
flutter run
```

### 디바이스 설정
- **카메라 권한**: 스윙 분석을 위한 카메라 접근 권한 필요
- **저장소 권한**: 영상 저장을 위한 저장소 접근 권한 필요
- **네트워크 권한**: 서버 통신을 위한 인터넷 연결 필요

## 📦 주요 의존성

```yaml
dependencies:
  flutter: ^3.6.1
  provider: ^6.1.1          # 상태 관리
  camera: ^0.11.1           # 카메라 기능
  video_player: ^2.8.1      # 비디오 재생
  video_trimmer: ^5.0.0     # 비디오 편집
  http: ^1.3.0              # HTTP 통신
  flutter_secure_storage: ^9.2.4  # 보안 저장소
  ffmpeg_kit_flutter_new: ^3.1.0  # 비디오 처리
  permission_handler: ^12.0.0+1   # 권한 관리
```

## 🔐 보안 및 개인정보

- **JWT 토큰**: 안전한 사용자 인증
- **Secure Storage**: 민감 정보 암호화 저장
- **권한 관리**: 필요한 권한만 요청
- **HTTPS 통신**: 데이터 전송 암호화

## 🤝 기여하기

1. Fork the Project
2. Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3. Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the Branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📄 라이센스

### 프로젝트 라이센스
이 프로젝트는 **MIT 라이센스** 하에 배포됩니다.

```
MIT License

Copyright (c) 2024 Golf Coach AI Team

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```

### 상용 이용 안내
- **개인/교육 목적**: 자유롭게 사용 가능
- **상업적 이용**: MIT 라이센스 조건 하에 허용
- **재배포**: 원본 라이센스 및 저작권 표시 필수

### 제3자 라이브러리 라이센스
이 프로젝트는 다음과 같은 오픈소스 라이브러리들을 사용합니다:
- **Flutter SDK**: BSD-3-Clause License
- **Provider**: MIT License
- **Camera Plugin**: BSD-3-Clause License
- **Video Player**: BSD-3-Clause License
- **HTTP Package**: BSD-3-Clause License
- **Secure Storage**: BSD-3-Clause License
- **FFmpeg Kit**: LGPL v3.0 License

### 면책조항
- 본 소프트웨어는 "있는 그대로" 제공되며, 명시적이거나 묵시적인 보증을 하지 않습니다
- 사용으로 인해 발생하는 손해에 대해 개발자는 책임지지 않습니다
- AI 분석 결과는 참고용이며, 전문적인 골프 코칭을 대체하지 않습니다

## 📞 연락처

프로젝트에 대한 문의사항이나 버그 리포트는 이슈를 통해 남겨주세요.

## 🙏 감사의 말

이 프로젝트는 골프를 사랑하는 모든 분들의 실력 향상을 위해 개발되었습니다. 피드백과 제안사항은 언제나 환영합니다.

---

**Golf Coach AI** - AI가 함께하는 스마트한 골프 레슨 🏌️‍♂️