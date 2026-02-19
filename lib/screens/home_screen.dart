import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'quiz_screen.dart';
import 'collection_screen.dart';
import 'package:math_game_clean/route_observer.dart';
import 'package:math_game_clean/pity_state.dart' as pity_state;

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with RouteAware {
  int keys = 5; // 열쇠 개수
  int pityGauge = 0; // 수집 게이지 0~100 (중복 시 +20%, 100%면 다음 보상 신규 보장)
  int brainEnergy = 0; // 브레인 에너지 0~20 (만점 시 +1, 20이면 스페셜 캐릭터 획득)
  Timer? _timer;
  String timeUntilNextKey = '';
  
  @override
  void initState() {
    super.initState();
    loadKeys();
    loadPityGauge();
    loadBrainEnergy();
    checkKeyRecharge();
    _startTimer();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.unsubscribe(this);
    final route = ModalRoute.of(context);
    if (route is ModalRoute<void> && route.isCurrent) {
      routeObserver.subscribe(this, route);
    }
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    _timer?.cancel();
    super.dispose();
  }

  /// 메인 화면이 다시 보일 때(보상에서 돌아올 때 등) 열쇠·수집 게이지 즉시 새로고침
  @override
  void didPopNext() {
    loadKeys();
    loadPityGauge();
    loadBrainEnergy();
  }
  
  Future<void> loadBrainEnergy() async {
    final prefs = await SharedPreferences.getInstance();
    final value = prefs.getInt('brain_energy') ?? 0;
    if (!mounted) return;
    setState(() {
      brainEnergy = value.clamp(0, 20);
    });
  }
  
  Future<void> loadPityGauge() async {
    final prefs = await SharedPreferences.getInstance();
    final value = prefs.getInt('pity_gauge') ?? 0;
    if (!mounted) return;
    setState(() {
      pityGauge = value;
    });
  }


  
  Future<void> loadKeys() async {
    final prefs = await SharedPreferences.getInstance();
    final value = prefs.getInt('keys') ?? 5;
    if (!mounted) return;
    setState(() {
      keys = value;
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
    
    // 6시간 = 6 * 60 * 60 * 1000 = 21,600,000 밀리초
    const keyRechargeTime = 6 * 60 * 60 * 1000;
    
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
    const keyRechargeTime = 6 * 60 * 60 * 1000; // 6시간
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
            '열쇠는 6시간마다 하나씩 충전됩니다.\n\n'
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
    
    // 게임에서 돌아왔을 때 열쇠·수집 게이지·브레인 에너지 다시 로드
    await loadKeys();
    await loadPityGauge();
    await loadBrainEnergy();
  }

  @override
  Widget build(BuildContext context) {
    // 보상 화면에서 설정해 둔 수집 게이지가 있으면 즉시 반영 (새로고침 없이)
    if (pity_state.pendingPityGauge != null) {
      final value = pity_state.pendingPityGauge!;
      pity_state.pendingPityGauge = null;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) setState(() => pityGauge = value);
      });
    }
    // 매 build마다 다음 프레임에서 열쇠·수집 게이지·브레인 에너지 업데이트
    WidgetsBinding.instance.addPostFrameCallback((_) {
      loadKeys();
      loadPityGauge();
      loadBrainEnergy();
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
              
              const SizedBox(height: 20),
              
              // 수집 게이지 (중복 시 +20%, 100%면 다음 보상 신규 보장)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                margin: const EdgeInsets.symmetric(horizontal: 20),
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
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.auto_awesome, color: Colors.purple[600], size: 20),
                        const SizedBox(width: 6),
                        Text(
                          '수집 게이지',
                          style: TextStyle(
                            color: Colors.grey[800],
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: LinearProgressIndicator(
                        value: pityGauge / 100,
                        minHeight: 14,
                        backgroundColor: Colors.grey[300],
                        valueColor: AlwaysStoppedAnimation<Color>(
                          pityGauge >= 100 ? Colors.purple : Colors.purple[400]!,
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      pityGauge >= 100
                          ? '다음 보상: 신규 카드 보장!'
                          : '$pityGauge% (중복 시 +20%)',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 20),
              
              // 브레인 에너지 (만점 시 +1, 20칸이면 스페셜 캐릭터 획득)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                margin: const EdgeInsets.symmetric(horizontal: 20),
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
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.psychology, color: Colors.amber[700], size: 20),
                        const SizedBox(width: 6),
                        Text(
                          '브레인 에너지',
                          style: TextStyle(
                            color: Colors.grey[800],
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(20, (i) {
                        final filled = i < brainEnergy;
                        return Container(
                          width: 14,
                          height: 14,
                          margin: const EdgeInsets.symmetric(horizontal: 1),
                          decoration: BoxDecoration(
                            color: filled ? Colors.amber[600] : Colors.grey[300],
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: filled ? Colors.amber[800]! : Colors.grey[400]!,
                              width: 1,
                            ),
                          ),
                        );
                      }),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      brainEnergy >= 20
                          ? '스페셜 캐릭터 획득 가능!'
                          : '$brainEnergy/20 (10점 만점 시 +1)',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 24),
              
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
                        '열쇠는 6시간마다 하나씩 충전됩니다',
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