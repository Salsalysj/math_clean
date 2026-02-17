# 🧠 브레인롯 수학게임

재미있는 브레인롯 캐릭터들과 함께하는 수학 학습 게임입니다!

## 🎮 게임 소개

브레인롯 수학게임은 10개의 수학 문제를 풀고 점수에 따라 귀여운 브레인롯 캐릭터를 수집할 수 있는 교육용 게임입니다.

## ✨ 주요 기능

### 🔑 열쇠 시스템
- 게임 플레이를 위한 열쇠 시스템
- 24시간마다 자동 충전
- 실패 시 열쇠 자동 반환

### 🧮 다양한 수학 문제
- 1-8번: 두 자릿수 사칙연산, 구구단
- 9-10번: 한자릿수 3항 연산

### 🎭 캐릭터 수집
- 총 41개의 브레인롯 캐릭터
- 8점 이상 획득 시 랜덤 캐릭터 획득
- 도감 시스템으로 수집 현황 확인

## 🏗️ 기술 스택

- **Framework**: Flutter
- **Language**: Dart
- **State Management**: StatefulWidget
- **Local Storage**: SharedPreferences

## 🚀 설치 및 실행

### 요구사항
- Flutter SDK 3.0+
- Dart 3.0+
- Android Studio / VS Code

### 실행 방법
```bash
# 의존성 설치
flutter pub get

# 웹에서 실행
flutter run -d chrome

# 안드로이드에서 실행
flutter run -d android

# APK 빌드
flutter build apk --release
```

## 📦 빌드 관리

`releases/` 폴더에서 각 버전별 빌드를 관리합니다:

```
releases/
├── v1.0/
│   ├── brainrot-math-game-v1.0.apk
│   └── README.md
└── v1.1/
    ├── brainrot-math-game-v1.1.apk
    └── README.md
```

### 최신 버전
- **v1.0** (2025-06-29): 기본 기능 완성

자세한 버전별 변경사항은 각 버전 폴더의 README.md를 참고하세요.

## 🎯 로드맵

- [ ] 이미지 저장 기능 재구현
- [ ] 추가 브레인롯 캐릭터
- [ ] 성취 시스템
- [ ] 리더보드
- [ ] 멀티플레이어 모드

## 🤝 기여하기

1. Fork the Project
2. Create your Feature Branch
3. Commit your Changes
4. Push to the Branch
5. Open a Pull Request

## 📄 라이선스

이 프로젝트는 MIT 라이선스 하에 있습니다.

## 📞 연락처

프로젝트 관련 문의사항이 있으시면 언제든지 연락주세요!
