# 브레인롯 수학게임 v1.0

## 📱 빌드 정보
- **빌드 날짜**: 2025년 6월 29일 오전 10:48
- **APK 크기**: 24.0MB
- **APK 파일명**: brainrot-math-game-v1.0.apk
- **소스 코드**: brainrot-math-game-v1.0-source.zip (3.5MB)

## 📦 포함된 파일들

### APK 파일
- `brainrot-math-game-v1.0.apk`: 설치 가능한 안드로이드 앱

### 소스 코드 압축 파일
- `brainrot-math-game-v1.0-source.zip`: 완전한 소스 코드
  - `lib/`: Dart 소스 코드 (모든 화면과 로직)
  - `android/`: 안드로이드 프로젝트 설정
  - `brainrot_image/`: 브레인롯 캐릭터 이미지 (41개)
  - `web/`: 웹 앱 설정
  - `pubspec.yaml`: Flutter 프로젝트 설정
  - `README.md`: 프로젝트 문서

## ✨ 주요 기능

### 🔑 열쇠 시스템
- 총 5개 열쇠 보유 가능
- 게임 시작 시 열쇠 1개 소모
- **24시간마다 1개씩 자동 충전**
- 실시간 충전 타이머 표시 (HH:MM:SS 형태)
- 8점 미만 획득 시 열쇠 자동 반환

### 🧮 수학 문제 시스템
- **1-8번째 문제**: 
  - 덧셈/뺄셈: 두 자릿수 (10~99)
  - 곱셈: 구구단 수준 (2~9단)
- **9-10번째 문제**: 
  - 3항 연산 (한자릿수): 예) 8+9-1, 7-3+2
  - 폰트 크기 자동 조정

### 🎭 브레인롯 캐릭터 수집
- 8점 이상 획득 시 랜덤 캐릭터 1개 획득
- 총 41개 브레인롯 캐릭터 수집 가능
- 캐릭터 도감 기능
- 수집 진행률 표시

### 🎨 UI/UX
- 앱 이름: "브레인롯 수학게임"
- 현대적이고 직관적인 인터페이스
- 반응형 디자인

## 🔧 기술 스택
- Flutter
- Dart
- SharedPreferences (로컬 저장소)

## 📝 알려진 이슈
- 이미지 저장 기능은 빌드 안정성을 위해 임시 제거됨

## 🔄 소스 코드 복원 방법

이 버전의 소스 코드를 다시 사용하려면:

1. **압축 파일 해제**:
   ```bash
   # Windows PowerShell
   Expand-Archive -Path brainrot-math-game-v1.0-source.zip -DestinationPath .
   
   # 또는 압축 해제 프로그램 사용
   ```

2. **Flutter 설정**:
   ```bash
   flutter pub get
   flutter run -d chrome    # 웹에서 테스트
   flutter build apk --release  # APK 빌드
   ```

3. **동일한 APK 재생성 확인**:
   - 빌드된 APK 크기가 약 24MB인지 확인
   - 모든 기능이 정상 작동하는지 테스트

## 🚀 다음 버전 계획
- 이미지 저장 기능 재구현
- 추가 브레인롯 캐릭터
- 성취 시스템
- 리더보드 기능 