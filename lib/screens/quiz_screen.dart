import 'dart:convert';
import 'package:flutter/material.dart';
import 'dart:math';
import 'package:shared_preferences/shared_preferences.dart';
import 'reward_screen.dart';
import 'home_screen.dart';
import 'package:math_game_clean/special_characters.dart';

class QuizScreen extends StatefulWidget {
  final bool hasKeys;
  
  const QuizScreen({super.key, this.hasKeys = true});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int currentQuestion = 1;
  int score = 0;
  int? num1, num2, num3, correctAnswer;
  String operation = '+';
  String? operation2;
  bool isThreeTermQuestion = false;
  final TextEditingController _answerController = TextEditingController();
  bool isAnswered = false;
  bool isCorrect = false;
  
  @override
  void initState() {
    super.initState();
    generateQuestion();
  }

  void generateQuestion() {
    if (currentQuestion == 9 || currentQuestion == 10) {
      // 9, 10번째 문제만 3항 혼합 문제
      _generateThreeTermQuestion();
    } else {
      // 1-8번째 문제는 2항 문제
      _generateTwoTermQuestion();
    }
    
    _answerController.clear();
    isAnswered = false;
    isCorrect = false;
  }

  void _generateTwoTermQuestion() {
    final random = Random();
    isThreeTermQuestion = false;
    
    // 연산 종류 선택 (덧셈, 뺄셈, 곱셈)
    final operations = ['+', '-', '×'];
    operation = operations[random.nextInt(operations.length)];
    
    switch (operation) {
      case '+':
        // 덧셈 (50~150)
        num1 = random.nextInt(101) + 50; // 50~150
        num2 = random.nextInt(101) + 50; // 50~150
        correctAnswer = num1! + num2!;
        break;
      case '-':
        // 뺄셈 (50~150)
        num1 = random.nextInt(101) + 50; // 50~150
        num2 = random.nextInt(num1! - 49) + 50; // 50~(num1-1), 결과가 양수가 되도록
        correctAnswer = num1! - num2!;
        break;
      case '×':
        // 한자리수 x 한자리수
        num1 = random.nextInt(8) + 2; // 2~9 (1 제외)
        num2 = random.nextInt(8) + 2; // 2~9 (1 제외)
        correctAnswer = num1! * num2!;
        break;
    }
  }

  void _generateThreeTermQuestion() {
    final random = Random();
    isThreeTermQuestion = true;
    
    // 첫 번째와 두 번째 연산 선택
    final operations = ['+', '-'];
    operation = operations[random.nextInt(operations.length)];
    operation2 = operations[random.nextInt(operations.length)];
    
    // 두자리수 생성 (10~99)
    num1 = random.nextInt(90) + 10; // 10~99
    num2 = random.nextInt(90) + 10; // 10~99
    num3 = random.nextInt(90) + 10; // 10~99
    
    // 중간 결과 계산
    int intermediateResult;
    if (operation == '+') {
      intermediateResult = num1! + num2!;
    } else {
      // 뺄셈에서 음수가 나오지 않도록 더 큰 수에서 작은 수를 빼도록 조정
      if (num1! < num2!) {
        final temp = num1;
        num1 = num2;
        num2 = temp;
      }
      intermediateResult = num1! - num2!;
    }
    
    // 최종 결과 계산
    if (operation2 == '+') {
      correctAnswer = intermediateResult + num3!;
    } else {
      // 뺄셈일 때 음수가 나오지 않도록 조정
      if (intermediateResult < num3!) {
        operation2 = '+';
        correctAnswer = intermediateResult + num3!;
      } else {
        correctAnswer = intermediateResult - num3!;
      }
    }
  }

  void checkAnswer() async {
    if (_answerController.text.isEmpty) return;
    
    // ─── 치트키 (퀴즈 1번 문제 답란에 입력 후 제출) ─────────────────────────
    // 111111 : 만점(10점) 처리 → 보상 화면으로 이동
    // 111119 : 만점(10점) 처리 → 보상 화면으로 이동 → 스페셜 캐릭터 보상 획득
    // 222222 : 0점 처리 → 보상 화면으로 이동
    // 333333 : 열쇠 5개 충전 → 홈으로
    // 000000 : 도감 전부 리셋 (브레인롯·몹·스페셜·스페셜 레벨) → 홈으로
    // 999999 : 도감 전부 해금 (브레인롯 + 마인크래프트) → 홈으로
    // 999991 : 브레인롯 캐릭터 도감 100% → 홈으로
    // 999992 : 마인크래프트 몹 도감 100% → 홈으로
    // 999993 : 스페셜 캐릭터 도감 100% (레벨 1) → 홈으로
    // ─────────────────────────────────────────────────────────────────
    if (currentQuestion == 1) {
      if (_answerController.text == '111111') {
        // 10문제 모두 맞춘 것으로 간주
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => RewardScreen(score: 10, hasKeys: widget.hasKeys),
          ),
        );
        return;
      } else if (_answerController.text == '111119') {
        // 만점 + 스페셜 캐릭터 보상
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => RewardScreen(score: 10, hasKeys: widget.hasKeys, forceSpecialReward: true),
          ),
        );
        return;
      } else if (_answerController.text == '222222') {
        // 10문제 모두 틀린 것으로 간주
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => RewardScreen(score: 0, hasKeys: widget.hasKeys),
          ),
        );
        return;
      } else if (_answerController.text == '000000') {
        // 도감 리셋
        await _resetCollection();
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
          (route) => false,
        );
        return;
      } else if (_answerController.text == '999999') {
        // 도감 모두 획득
        await _unlockAllCharacters();
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
          (route) => false,
        );
        return;
      } else if (_answerController.text == '333333') {
        // 열쇠 5개 충전
        await _fillAllKeys();
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
          (route) => false,
        );
        return;
      } else if (_answerController.text == '999991') {
        // 브레인롯 캐릭터 도감 100%
        await _unlockBrainrot100();
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
          (route) => false,
        );
        return;
      } else if (_answerController.text == '999992') {
        // 마인크래프트 몹 도감 100%
        await _unlockMinecraft100();
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
          (route) => false,
        );
        return;
      } else if (_answerController.text == '999993') {
        // 스페셜 캐릭터 도감 100%
        await _unlockSpecial100();
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
          (route) => false,
        );
        return;
      }
    }
    
    final userAnswer = int.tryParse(_answerController.text);
    if (userAnswer == null) return;
    
    setState(() {
      isAnswered = true;
      isCorrect = userAnswer == correctAnswer;
      if (isCorrect) {
        score++;
      }
    });
  }

  void nextQuestion() {
    if (currentQuestion >= 10) {
      // 10문제 완료 - 보상 화면으로 이동 (열쇠 상태 전달)
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => RewardScreen(
            score: score,
            hasKeys: widget.hasKeys,
          ),
        ),
      );
    } else {
      setState(() {
        currentQuestion++;
        generateQuestion();
      });
    }
  }

  String getQuestionText() {
    if (isThreeTermQuestion) {
      return '$num1 $operation $num2 $operation2 $num3 = ?';
    } else {
      return '$num1 $operation $num2 = ?';
    }
  }

  // 치트 코드용 헬퍼 메서드들
  Future<void> _resetCollection() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('collected_characters');
    await prefs.remove('collected_mobs');
    await prefs.remove('collected_special');
    await prefs.remove('special_levels');
    print('도감 리셋 완료 (브레인롯 + 마인크래프트 + 스페셜)');
  }

  Future<void> _unlockAllCharacters() async {
    final prefs = await SharedPreferences.getInstance();
    
    // 모든 브레인롯 캐릭터 이미지 목록
    final List<String> allCharacters = [
      'brainrot_image/가라마라라마라라만 단 마두둥둥 탁 툰퉁 퍼르쿤퉁.webp',
      'brainrot_image/고릴로 워터멜론드릴로.webp',
      'brainrot_image/그라이푸시 메두시.webp',
      'brainrot_image/글로르보 프루토드릴로.webp',
      'brainrot_image/라 바카 사투르노 사투르니타.webp',
      'brainrot_image/리노 토스트리노.webp',
      'brainrot_image/리릴리 라릴라.webp',
      'brainrot_image/마카키니 바나니니.webp',
      'brainrot_image/바나니타 돌피니타.webp',
      'brainrot_image/발레리나 카푸치나.webp',
      'brainrot_image/발레리노 로로로.webp',
      'brainrot_image/보네카 암발라부.webp',
      'brainrot_image/보브리토 반디토.webp',
      'brainrot_image/봄바르디로 크로코딜로.webp',
      'brainrot_image/봄봄비니 구지니.webp',
      'brainrot_image/부르발로니 룰릴롤리.webp',
      'brainrot_image/브르르 브르르 파타핌.webp',
      'brainrot_image/브리 브리 비쿠스 디쿠스 봄비쿠스.webp',
      'brainrot_image/블루베리니 옥토푸시니.webp',
      'brainrot_image/오 딘딘딘딘 둔 마 딘딘딘 둔.webp',
      'brainrot_image/오랑구티니 아나나시니.webp',
      'brainrot_image/일 칵토 히포포타모.webp',
      'brainrot_image/지라파 첼레스테.webp',
      'brainrot_image/지브라 주브라 지브라리니.webp',
      'brainrot_image/침판지니 바나니니.webp',
      'brainrot_image/카푸치노 아사시노.webp',
      'brainrot_image/코코판토 엘레판토.webp',
      'brainrot_image/크로코딜도 페니시니.webp',
      'brainrot_image/타 타 타 타 타 타 타 타 타 타 타 사후르.webp',
      'brainrot_image/퉁 퉁 퉁 퉁 퉁 퉁 퉁 퉁 퉁 사후르.webp',
      'brainrot_image/트랄랄레로 트랄랄라.webp',
      'brainrot_image/트래코투코툴루 델라펠라두스투즈.webp',
      'brainrot_image/트룰리메로 트룰리치나.webp',
      'brainrot_image/트리피 트로피1.webp',
      'brainrot_image/트리피 트로피2.webp',
      'brainrot_image/트릭 트랙 바라붐.webp',
      'brainrot_image/티그룰리 그레이프루투니.webp',
      'brainrot_image/티그룰리니 워터멜리니.webp',
      'brainrot_image/팟 핫스팟.webp',
      'brainrot_image/프룰리 프룰라.webp',
      'brainrot_image/프리고 카멜로.webp',
    ];
    
    // 모든 마인크래프트 몹 이미지 목록 (MobDatabase 사용)
    final List<String> allMobNames = MobDatabase.getAllMobNames();
    final List<String> validMobs = allMobNames.map((mobName) {
      // .webp 우선, 벡스는 .png
      if (mobName == '벡스') {
        return 'minecraft_image/$mobName.png';
      }
      return 'minecraft_image/$mobName.webp';
    }).toList();
    
    await prefs.setStringList('collected_characters', allCharacters);
    await prefs.setStringList('collected_mobs', validMobs);
    print('모든 캐릭터 획득 완료: ${allCharacters.length}개 (브레인롯)');
    print('모든 몹 획득 완료: ${validMobs.length}개 (마인크래프트)');
  }

  Future<void> _fillAllKeys() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('keys', 5);
    await prefs.setInt('last_key_time', DateTime.now().millisecondsSinceEpoch);
    print('열쇠 5개 충전 완료');
  }

  Future<void> _unlockBrainrot100() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> allCharacters = [
      'brainrot_image/가라마라라마라라만 단 마두둥둥 탁 툰퉁 퍼르쿤퉁.webp',
      'brainrot_image/고릴로 워터멜론드릴로.webp',
      'brainrot_image/그라이푸시 메두시.webp',
      'brainrot_image/글로르보 프루토드릴로.webp',
      'brainrot_image/라 바카 사투르노 사투르니타.webp',
      'brainrot_image/리노 토스트리노.webp',
      'brainrot_image/리릴리 라릴라.webp',
      'brainrot_image/마카키니 바나니니.webp',
      'brainrot_image/바나니타 돌피니타.webp',
      'brainrot_image/발레리나 카푸치나.webp',
      'brainrot_image/발레리노 로로로.webp',
      'brainrot_image/보네카 암발라부.webp',
      'brainrot_image/보브리토 반디토.webp',
      'brainrot_image/봄바르디로 크로코딜로.webp',
      'brainrot_image/봄봄비니 구지니.webp',
      'brainrot_image/부르발로니 룰릴롤리.webp',
      'brainrot_image/브르르 브르르 파타핌.webp',
      'brainrot_image/브리 브리 비쿠스 디쿠스 봄비쿠스.webp',
      'brainrot_image/블루베리니 옥토푸시니.webp',
      'brainrot_image/오 딘딘딘딘 둔 마 딘딘딘 둔.webp',
      'brainrot_image/오랑구티니 아나나시니.webp',
      'brainrot_image/일 칵토 히포포타모.webp',
      'brainrot_image/지라파 첼레스테.webp',
      'brainrot_image/지브라 주브라 지브라리니.webp',
      'brainrot_image/침판지니 바나니니.webp',
      'brainrot_image/카푸치노 아사시노.webp',
      'brainrot_image/코코판토 엘레판토.webp',
      'brainrot_image/크로코딜도 페니시니.webp',
      'brainrot_image/타 타 타 타 타 타 타 타 타 타 타 사후르.webp',
      'brainrot_image/퉁 퉁 퉁 퉁 퉁 퉁 퉁 퉁 퉁 사후르.webp',
      'brainrot_image/트랄랄레로 트랄랄라.webp',
      'brainrot_image/트래코투코툴루 델라펠라두스투즈.webp',
      'brainrot_image/트룰리메로 트룰리치나.webp',
      'brainrot_image/트리피 트로피1.webp',
      'brainrot_image/트리피 트로피2.webp',
      'brainrot_image/트릭 트랙 바라붐.webp',
      'brainrot_image/티그룰리 그레이프루투니.webp',
      'brainrot_image/티그룰리니 워터멜리니.webp',
      'brainrot_image/팟 핫스팟.webp',
      'brainrot_image/프룰리 프룰라.webp',
      'brainrot_image/프리고 카멜로.webp',
    ];
    await prefs.setStringList('collected_characters', allCharacters);
    print('치트: 브레인롯 캐릭터 도감 100% 획득 (${allCharacters.length}개)');
  }

  Future<void> _unlockMinecraft100() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> allMobs = [
      'minecraft_image/가디언.webp',
      'minecraft_image/가스트.jpg',
      'minecraft_image/난폭한 피글린.webp',
      'minecraft_image/마그마 큐브.webp',
      'minecraft_image/마녀.webp',
      'minecraft_image/벡스.png',
      'minecraft_image/변명자.webp',
      'minecraft_image/보그드.webp',
      'minecraft_image/복어.jpg',
      'minecraft_image/브리즈.webp',
      'minecraft_image/블레이즈.jpg',
      'minecraft_image/셜커.webp',
      'minecraft_image/소환사.webp',
      'minecraft_image/스켈레톤.webp',
      'minecraft_image/스켈레톤 기병.webp',
      'minecraft_image/스트레이.webp',
      'minecraft_image/스파이더 조키.jpg',
      'minecraft_image/슬라임.webp',
      'minecraft_image/아기 피글린.webp',
      'minecraft_image/약탈자.webp',
      'minecraft_image/엔더마이트.jpg',
      'minecraft_image/엘더 가디언.webp',
      'minecraft_image/워든.jpg',
      'minecraft_image/위더 스켈레톤.webp',
      'minecraft_image/익사자.webp',
      'minecraft_image/조글린.webp',
      'minecraft_image/좀벌레.jpg',
      'minecraft_image/좀비.webp',
      'minecraft_image/좀비 주민.jpg',
      'minecraft_image/좀비 피글린.webp',
      'minecraft_image/충전된 크리퍼.webp',
      'minecraft_image/치킨 조키.jpg',
      'minecraft_image/크리킹.webp',
      'minecraft_image/크리퍼.webp',
      'minecraft_image/파괴수.webp',
      'minecraft_image/팬텀.jpg',
      'minecraft_image/피글린.webp',
      'minecraft_image/허스크.webp',
      'minecraft_image/호글린.webp',
      'minecraft_image/환술사.webp',
    ];
    await prefs.setStringList('collected_mobs', allMobs);
    print('치트: 마인크래프트 몹 도감 100% 획득 (${allMobs.length}개)');
  }

  Future<void> _unlockSpecial100() async {
    final prefs = await SharedPreferences.getInstance();
    final allSpecial = await loadSpecialCharacterImagesFromCsv();
    await prefs.setStringList('collected_special', allSpecial);
    final levels = {for (final p in allSpecial) p: 1};
    await prefs.setString('special_levels', jsonEncode(levels));
    print('치트: 스페셜 캐릭터 도감 100% 획득 (${allSpecial.length}개, 레벨 1)');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.purple[50],
      appBar: AppBar(
        title: Text('문제 $currentQuestion/10'),
        backgroundColor: Colors.purple[600],
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // 점수 표시
              Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.star, color: Colors.amber, size: 30),
                    const SizedBox(width: 10),
                    Text(
                      '점수: $score',
                      style: Theme.of(context).textTheme.displayMedium?.copyWith(
                        color: Colors.purple[800],
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 50),
              
              // 문제 표시
              Container(
                padding: const EdgeInsets.all(30),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Text(
                      getQuestionText(),
                      style: Theme.of(context).textTheme.displayLarge?.copyWith(
                        color: Colors.purple[800],
                        fontSize: isThreeTermQuestion ? 32 : 40,
                      ),
                    ),
                    
                    const SizedBox(height: 30),
                    
                    // 답 입력 필드
                    TextField(
                      controller: _answerController,
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 24),
                      decoration: InputDecoration(
                        hintText: '답을 입력하세요',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        filled: true,
                        fillColor: Colors.grey[100],
                      ),
                      enabled: !isAnswered,
                    ),
                    
                    const SizedBox(height: 20),
                    
                    // 정답 확인 결과
                    if (isAnswered) ...[
                      Container(
                        padding: const EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          color: isCorrect ? Colors.green[100] : Colors.red[100],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          isCorrect ? '정답입니다! 🎉' : '틀렸습니다. 정답은 $correctAnswer입니다.',
                          style: TextStyle(
                            fontSize: 18,
                            color: isCorrect ? Colors.green[800] : Colors.red[800],
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              
              const SizedBox(height: 40),
              
              // 버튼들
              if (!isAnswered) ...[
                ElevatedButton(
                  onPressed: checkAnswer,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 40,
                      vertical: 15,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  child: Text(
                    '확인',
                    style: Theme.of(context).textTheme.displayMedium?.copyWith(
                      color: Colors.white,
                    ),
                  ),
                ),
              ] else ...[
                ElevatedButton(
                  onPressed: nextQuestion,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 40,
                      vertical: 15,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  child: Text(
                    currentQuestion >= 10 ? '결과 보기' : '다음 문제',
                    style: Theme.of(context).textTheme.displayMedium?.copyWith(
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
  
  @override
  void dispose() {
    _answerController.dispose();
    super.dispose();
  }
} 