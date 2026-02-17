import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'quiz_screen.dart';
import 'collection_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int keys = 5; // 열쇠 개수
  Timer? _timer;
  String timeUntilNextKey = '';
  
  @override
  void initState() {
    super.initState();
    loadKeys();
    checkKeyRecharge();
    _startTimer();
  }


  
  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
  
  Future<void> loadKeys() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      keys = prefs.getInt('keys') ?? 5;
    });
  }
  
  Future<void> saveKeys() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('keys', keys);
    await prefs.setInt('last_key_time', DateTime.now().millisecondsSinceEpoch);
  }
  
  Future<void> checkKeyRecharge() async {
    final prefs = await SharedPreferences.getInstance();
    final lastKeyTime = prefs.getInt('last_key_time') ?? 0;
    final now = DateTime.now().millisecondsSinceEpoch;
    final timeDiff = now - lastKeyTime;
    
    // 24시간 = 24 * 60 * 60 * 1000 = 86,400,000 밀리초
    const keyRechargeTime = 24 * 60 * 60 * 1000;
    
    if (keys < 5 && timeDiff >= keyRechargeTime) {
      final keysToAdd = (timeDiff ~/ keyRechargeTime).clamp(0, 5 - keys);
      setState(() {
        keys = (keys + keysToAdd).clamp(0, 5);
      });
      await saveKeys();
    }
    
    _updateTimeUntilNextKey();
  }
  
  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _updateTimeUntilNextKey();
    });
  }
  
  Future<void> _updateTimeUntilNextKey() async {
    if (keys >= 5) {
      setState(() {
        timeUntilNextKey = '';
      });
      return;
    }
    
    final prefs = await SharedPreferences.getInstance();
    const keyRechargeTime = 24 * 60 * 60 * 1000; // 24시간
    final lastKeyTime = prefs.getInt('last_key_time') ?? DateTime.now().millisecondsSinceEpoch;
    final now = DateTime.now().millisecondsSinceEpoch;
    
    final nextKeyTime = lastKeyTime + keyRechargeTime;
    final timeLeft = nextKeyTime - now;
    
    if (timeLeft <= 0) {
      await checkKeyRecharge();
    } else {
      final hours = (timeLeft ~/ (1000 * 60 * 60));
      final minutes = ((timeLeft % (1000 * 60 * 60)) ~/ (1000 * 60));
      final seconds = ((timeLeft % (1000 * 60)) ~/ 1000);
      
      setState(() {
        timeUntilNextKey = '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
      });
    }
  }
  
  Future<void> useKey() async {
    if (keys > 0) {
      setState(() {
        keys--;
      });
      await saveKeys();
    }
  }
  


  void startGame() async {
    final bool hasKeys = keys > 0;
    
    // 열쇠가 없을 때 안내 다이얼로그 표시
    if (!hasKeys) {
      final shouldContinue = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('⚠️ 열쇠 없음'),
          content: const Text(
            '열쇠가 없어도 문제를 풀 수 있습니다.\n\n'
            '하지만 보상을 획득하려면 열쇠가 필요합니다.\n'
            '열쇠는 24시간마다 하나씩 충전됩니다.\n\n'
            '게임을 계속 진행하시겠습니까?'
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('취소'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('계속하기'),
            ),
          ],
        ),
      );
      
      if (shouldContinue != true) {
        return;
      }
    }
    
    if (!mounted) return;
    
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => QuizScreen(hasKeys: hasKeys),
      ),
    );
    
    // 게임에서 돌아왔을 때 열쇠 개수 다시 로드
    await loadKeys();
  }

  @override
  Widget build(BuildContext context) {
    // 매 build마다 다음 프레임에서 열쇠 상태 업데이트
    WidgetsBinding.instance.addPostFrameCallback((_) {
      loadKeys();
    });
    
    return Scaffold(
      backgroundColor: Colors.lightBlue[50],
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // 게임 제목
              Container(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Icon(
                      Icons.calculate,
                      size: 80,
                      color: Colors.blue[600],
                    ),
                    const SizedBox(height: 20),
                    Text(
                      '브레인롯 수학게임',
                      style: Theme.of(context).textTheme.displayLarge?.copyWith(
                        color: Colors.blue[800],
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 30),
              
              // 열쇠 표시
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
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.vpn_key, color: Colors.amber[700], size: 30),
                    const SizedBox(width: 10),
                    Text(
                      '$keys / 5',
                      style: Theme.of(context).textTheme.displayMedium?.copyWith(
                        color: Colors.blue[800],
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 30),
              
              // 게임 시작 버튼 (열쇠 없어도 가능)
              ElevatedButton(
                onPressed: startGame,
                style: ElevatedButton.styleFrom(
                  backgroundColor: keys > 0 ? Colors.green : Colors.orange,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 50,
                    vertical: 20,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '게임 시작',
                      style: Theme.of(context).textTheme.displayMedium?.copyWith(
                        color: Colors.white,
                      ),
                    ),
                    if (keys <= 0) ...[
                      const SizedBox(height: 4),
                      Text(
                        '(보상 획득 불가)',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.white.withOpacity(0.9),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              
              const SizedBox(height: 30),
               
              // 캐릭터 도감 버튼
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const CollectionScreen(),
                    ),
                  );
                },
                icon: const Icon(Icons.collections_bookmark),
                label: const Text('캐릭터 도감'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigo,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30,
                    vertical: 15,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
              
              if (keys < 5) ...[
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.amber[50],
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.amber[200]!),
                  ),
                  child: Column(
                    children: [
                      Text(
                        '열쇠는 24시간마다 하나씩 충전됩니다',
                        style: TextStyle(
                          color: Colors.grey[700],
                          fontSize: 14,
                        ),
                      ),
                      if (timeUntilNextKey.isNotEmpty) ...[
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.schedule, color: Colors.amber[700], size: 18),
                            const SizedBox(width: 5),
                            Text(
                              '다음 충전까지: $timeUntilNextKey',
                              style: TextStyle(
                                color: Colors.amber[800],
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
} 