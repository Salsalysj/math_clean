import 'dart:convert';
import 'package:flutter/material.dart';
import 'dart:math';
import 'package:math_game_clean/pity_state.dart' as pity_state;
import 'package:math_game_clean/special_characters.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';
import 'package:gal/gal.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/rendering.dart';

// 마인크래프트 몹 정보 클래스
class MobInfo {
  final int id;
  final String name;
  final String attackPower;
  final String specialAbility;
  final String health;
  final String dropItems;

  MobInfo({
    required this.id,
    required this.name,
    required this.attackPower,
    required this.specialAbility,
    required this.health,
    required this.dropItems,
  });
}

// 마인크래프트 몹 데이터베이스
class MobDatabase {
  static final Map<String, MobInfo> _mobs = {
    '좀비': MobInfo(
      id: 1, name: '좀비',
      attackPower: '3', specialAbility: '', health: '20',
      dropItems: '썩은 살점, 좀비 머리, 음반'
    ),
    '좀비 주민': MobInfo(
      id: 2, name: '좀비 주민',
      attackPower: '3', specialAbility: '', health: '20',
      dropItems: '썩은 살점'
    ),
    '허스크': MobInfo(
      id: 3, name: '허스크',
      attackPower: '3', specialAbility: '허기', health: '20',
      dropItems: '썩은 살점'
    ),
    '익사자': MobInfo(
      id: 4, name: '익사자',
      attackPower: '3', specialAbility: '', health: '20',
      dropItems: '썩은 살점'
    ),
    '스켈레톤': MobInfo(
      id: 5, name: '스켈레톤',
      attackPower: '2~4', specialAbility: '', health: '20',
      dropItems: '화살, 뼈다귀, 스켈레톤 해골'
    ),
    '위더 스켈레톤': MobInfo(
      id: 6, name: '위더 스켈레톤',
      attackPower: '8', specialAbility: '시듦', health: '20',
      dropItems: '석탄, 뼈다귀, 위더 스켈레톤 해골'
    ),
    '스트레이': MobInfo(
      id: 7, name: '스트레이',
      attackPower: '2~5', specialAbility: '속도 감소', health: '20',
      dropItems: '화살, 뼈다귀, 감속의 화살'
    ),
    '보그드': MobInfo(
      id: 8, name: '보그드',
      attackPower: '3~5', specialAbility: '독', health: '16',
      dropItems: '화살, 뼈, 독화살'
    ),
    '슬라임': MobInfo(
      id: 9, name: '슬라임',
      attackPower: '2', specialAbility: '', health: '4',
      dropItems: '슬라임 볼'
    ),
    '마그마 큐브': MobInfo(
      id: 10, name: '마그마 큐브',
      attackPower: '4', specialAbility: '', health: '4',
      dropItems: '마그마 크림'
    ),
    '가디언': MobInfo(
      id: 11, name: '가디언',
      attackPower: '6', specialAbility: '가시', health: '30',
      dropItems: '프리즈머린 조각, 프리즈머린 수정, 생 대구'
    ),
    '엘더 가디언': MobInfo(
      id: 12, name: '엘더 가디언',
      attackPower: '8', specialAbility: '가시, 채굴 피로', health: '80',
      dropItems: '프리즈머린 조각, 프리즈머린 수정, 생 대구'
    ),
    '변명자': MobInfo(
      id: 13, name: '변명자',
      attackPower: '13', specialAbility: '', health: '24',
      dropItems: '에메랄드'
    ),
    '소환사': MobInfo(
      id: 14, name: '소환사',
      attackPower: '6', specialAbility: '', health: '24',
      dropItems: '불사의 토템, 에메랄드'
    ),
    '벡스': MobInfo(
      id: 15, name: '벡스',
      attackPower: '9', specialAbility: '', health: '14',
      dropItems: ''
    ),
    '약탈자': MobInfo(
      id: 16, name: '약탈자',
      attackPower: '4', specialAbility: '', health: '24',
      dropItems: '화살'
    ),
    '파괴수': MobInfo(
      id: 17, name: '파괴수',
      attackPower: '12', specialAbility: '포효', health: '100',
      dropItems: '인장'
    ),
    '환술사': MobInfo(
      id: 18, name: '환술사',
      attackPower: '2~5', specialAbility: '실명', health: '32',
      dropItems: '불길한 현수막'
    ),
    '크리퍼': MobInfo(
      id: 19, name: '크리퍼',
      attackPower: '43', specialAbility: '', health: '20',
      dropItems: '화약, 크리퍼 머리, 음반'
    ),
    '충전된 크리퍼': MobInfo(
      id: 20, name: '충전된 크리퍼',
      attackPower: '85', specialAbility: '', health: '20',
      dropItems: '화약, 크리퍼 머리, 음반'
    ),
    '가스트': MobInfo(
      id: 21, name: '가스트',
      attackPower: '17', specialAbility: '', health: '10',
      dropItems: '화약, 가스트 눈물, 음반'
    ),
    '팬텀': MobInfo(
      id: 22, name: '팬텀',
      attackPower: '6', specialAbility: '', health: '20',
      dropItems: '팬텀 막'
    ),
    '피글린': MobInfo(
      id: 23, name: '피글린',
      attackPower: '9', specialAbility: '', health: '16',
      dropItems: '금 검, 쇠뇌, 금 방어구'
    ),
    '아기 피글린': MobInfo(
      id: 24, name: '아기 피글린',
      attackPower: '0', specialAbility: '', health: '16',
      dropItems: ''
    ),
    '난폭한 피글린': MobInfo(
      id: 25, name: '난폭한 피글린',
      attackPower: '10', specialAbility: '', health: '50',
      dropItems: '금 도끼'
    ),
    '좀비 피글린': MobInfo(
      id: 26, name: '좀비 피글린',
      attackPower: '8', specialAbility: '', health: '20',
      dropItems: '썩은 살점, 금 조각, 금 주괴, 금 검'
    ),
    '워든': MobInfo(
      id: 27, name: '워든',
      attackPower: '30', specialAbility: '어둠', health: '500',
      dropItems: '스컬크 촉매'
    ),
    '좀벌레': MobInfo(
      id: 28, name: '좀벌레',
      attackPower: '1', specialAbility: '', health: '8',
      dropItems: ''
    ),
    '블레이즈': MobInfo(
      id: 29, name: '블레이즈',
      attackPower: '6', specialAbility: '', health: '20',
      dropItems: '블레이즈 막대기'
    ),
    '마녀': MobInfo(
      id: 30, name: '마녀',
      attackPower: '6', specialAbility: '속도 감소, 독, 나약함', health: '26',
      dropItems: '레드스톤 가루, 화약, 발광석 가루'
    ),
    '복어': MobInfo(
      id: 31, name: '복어',
      attackPower: '3', specialAbility: '독', health: '3',
      dropItems: '복어, 뼛가루, 뼈'
    ),
    '엔더마이트': MobInfo(
      id: 32, name: '엔더마이트',
      attackPower: '2', specialAbility: '', health: '8',
      dropItems: ''
    ),
    '셜커': MobInfo(
      id: 33, name: '셜커',
      attackPower: '4', specialAbility: '공중 부양', health: '30',
      dropItems: '셜커 껍데기'
    ),
    '호글린': MobInfo(
      id: 34, name: '호글린',
      attackPower: '3~8', specialAbility: '', health: '40',
      dropItems: '익히지 않은 돼지고기, 가죽'
    ),
    '조글린': MobInfo(
      id: 35, name: '조글린',
      attackPower: '3~8', specialAbility: '', health: '40',
      dropItems: '썩은 살점'
    ),
    '브리즈': MobInfo(
      id: 36, name: '브리즈',
      attackPower: '1', specialAbility: '', health: '30',
      dropItems: '브리즈 막대기'
    ),
    '크리킹': MobInfo(
      id: 37, name: '크리킹',
      attackPower: '3', specialAbility: '', health: '1',
      dropItems: ''
    ),
    '스파이더 조키': MobInfo(
      id: 38, name: '스파이더 조키',
      attackPower: '2~4', specialAbility: '', health: '20',
      dropItems: '화살, 뼈다귀, 스켈레톤 해골'
    ),
    '스켈레톤 기병': MobInfo(
      id: 39, name: '스켈레톤 기병',
      attackPower: '1~4', specialAbility: '', health: '20',
      dropItems: '화살, 뼈다귀, 스켈레톤 해골'
    ),
    '치킨 조키': MobInfo(
      id: 40, name: '치킨 조키',
      attackPower: '2~4', specialAbility: '', health: '20',
      dropItems: '화살, 뼈다귀, 스켈레톤 해골'
    ),
  };

  static MobInfo? getMobInfo(String name) {
    return _mobs[name];
  }
  
  static List<String> getAllMobNames() {
    return _mobs.keys.toList();
  }
}

// 캐릭터 정보 클래스
class CharacterInfo {
  final int id;
  final String koreanName;
  final String englishName;
  final String skill;
  final int combat;
  final int intelligence;
  final int cuteness;
  final int rarity;

  CharacterInfo({
    required this.id,
    required this.koreanName,
    required this.englishName,
    required this.skill,
    required this.combat,
    required this.intelligence,
    required this.cuteness,
    required this.rarity,
  });
}

// 캐릭터 데이터베이스
class CharacterDatabase {
  static final Map<String, CharacterInfo> _characters = {
    '가라마라라마라라만 단 마두둥둥 탁 툰퉁 퍼르쿤퉁': CharacterInfo(
      id: 1, koreanName: '가라마라라마라라만 단 마두둥둥 탁 툰퉁 퍼르쿤퉁',
      englishName: 'Garamararamaraman Dan Madudung Tak Tuntung Perrekuntung',
      skill: '뇌절 임팩트 – 예측불가 기습공격', combat: 5, intelligence: 3, cuteness: 5, rarity: 3
    ),
    '고릴로 워터멜론드릴로': CharacterInfo(
      id: 2, koreanName: '고릴로 워터멜론드릴로', englishName: 'Gorillo Watermelondrillo',
      skill: '수박 펀치 – 한방에 상대를 날려버림', combat: 4, intelligence: 3, cuteness: 2, rarity: 4
    ),
    '그라이푸시 메두시': CharacterInfo(
      id: 3, koreanName: '그라이푸시 메두시', englishName: 'Grapussy Medussy',
      skill: '뇌절 임팩트 – 예측불가 기습공격', combat: 2, intelligence: 2, cuteness: 5, rarity: 3
    ),
    '글로르보 프루토드릴로': CharacterInfo(
      id: 4, koreanName: '글로르보 프루토드릴로', englishName: 'Glorbo Frutodrillo',
      skill: '뇌절 임팩트 – 예측불가 기습공격', combat: 5, intelligence: 2, cuteness: 2, rarity: 3
    ),
    '라 바카 사투르노 사투르니타': CharacterInfo(
      id: 5, koreanName: '라 바카 사투르노 사투르니타', englishName: 'La Vacca Saturno Saturnita',
      skill: '뇌절 임팩트 – 예측불가 기습공격', combat: 5, intelligence: 2, cuteness: 4, rarity: 2
    ),
    '리노 토스트리노': CharacterInfo(
      id: 6, koreanName: '리노 토스트리노', englishName: 'Rino Tostrino',
      skill: '육중 바디 – 압도적 파워로 적을 밀어냄', combat: 4, intelligence: 2, cuteness: 3, rarity: 3
    ),
    '리릴리 라릴라': CharacterInfo(
      id: 7, koreanName: '리릴리 라릴라', englishName: 'Lirili Larila',
      skill: '시간 감속 – 일정 시간 적의 속도 느리게 함', combat: 4, intelligence: 4, cuteness: 3, rarity: 4
    ),
    '마카키니 바나니니': CharacterInfo(
      id: 8, koreanName: '마카키니 바나니니', englishName: 'Macachini Bananini',
      skill: '바나나 껍질 미끄럼 – 상대가 미끄러진다', combat: 3, intelligence: 3, cuteness: 4, rarity: 3
    ),
    '바나니타 돌피니타': CharacterInfo(
      id: 9, koreanName: '바나니타 돌피니타', englishName: 'Bananita Dolfinita',
      skill: '돌고래 점프 – 장애물을 뛰어넘음', combat: 3, intelligence: 4, cuteness: 5, rarity: 4
    ),
    '발레리나 카푸치나': CharacterInfo(
      id: 10, koreanName: '발레리나 카푸치나', englishName: 'Ballerina Cappuccina',
      skill: '포인테 리볼버 – 우아한 회전으로 상대 혼란', combat: 2, intelligence: 3, cuteness: 4, rarity: 4
    ),
    '발레리노 로로로': CharacterInfo(
      id: 11, koreanName: '발레리노 로로로', englishName: 'Ballerino Lorororo',
      skill: '육중 바디 – 압도적 파워로 적을 밀어냄', combat: 4, intelligence: 3, cuteness: 4, rarity: 4
    ),
    '보네카 암발라부': CharacterInfo(
      id: 12, koreanName: '보네카 암발라부', englishName: 'Boneca Ambalabu',
      skill: '뇌절 임팩트 – 예측불가 기습공격', combat: 4, intelligence: 2, cuteness: 5, rarity: 4
    ),
    '보브리토 반디토': CharacterInfo(
      id: 13, koreanName: '보브리토 반디토', englishName: 'Bovrito Bandito',
      skill: '뇌절 임팩트 – 예측불가 기습공격', combat: 5, intelligence: 3, cuteness: 2, rarity: 4
    ),
    '봄바르디로 크로코딜로': CharacterInfo(
      id: 14, koreanName: '봄바르디로 크로코딜로', englishName: 'Bombardiro Crocodilo',
      skill: '폭탄 모드 – 공중에서 공격 폭격을 가함', combat: 5, intelligence: 3, cuteness: 2, rarity: 5
    ),
    '봄봄비니 구지니': CharacterInfo(
      id: 15, koreanName: '봄봄비니 구지니', englishName: 'Bombombini Gujini',
      skill: '뇌절 임팩트 – 예측불가 기습공격', combat: 2, intelligence: 4, cuteness: 3, rarity: 2
    ),
    '부르발로니 룰릴롤리': CharacterInfo(
      id: 16, koreanName: '부르발로니 룰릴롤리', englishName: 'Burballoni Rulilrolli',
      skill: '뇌절 임팩트 – 예측불가 기습공격', combat: 3, intelligence: 2, cuteness: 3, rarity: 3
    ),
    '브르르 브르르 파타핌': CharacterInfo(
      id: 17, koreanName: '브르르 브르르 파타핌', englishName: 'Brr Brr Patapim',
      skill: '브르르 파타임 – 모자에서 점프 공격', combat: 3, intelligence: 2, cuteness: 3, rarity: 3
    ),
    '브리 브리 비쿠스 디쿠스 봄비쿠스': CharacterInfo(
      id: 18, koreanName: '브리 브리 비쿠스 디쿠스 봄비쿠스', englishName: 'Bri Bri Vicus Dicus Bombicus',
      skill: '뇌절 임팩트 – 예측불가 기습공격', combat: 5, intelligence: 2, cuteness: 4, rarity: 3
    ),
    '블루베리니 옥토푸시니': CharacterInfo(
      id: 19, koreanName: '블루베리니 옥토푸시니', englishName: 'Blueberrini Octopussini',
      skill: '뇌절 임팩트 – 예측불가 기습공격', combat: 4, intelligence: 5, cuteness: 3, rarity: 4
    ),
    '오 딘딘딘딘 둔 마 딘딘딘 둔': CharacterInfo(
      id: 20, koreanName: '오 딘딘딘딘 둔 마 딘딘딘 둔', englishName: 'O Dindindindin Dun Ma Dindindin Dun',
      skill: '뇌절 임팩트 – 예측불가 기습공격', combat: 3, intelligence: 4, cuteness: 5, rarity: 4
    ),
    '오랑구티니 아나나시니': CharacterInfo(
      id: 21, koreanName: '오랑구티니 아나나시니', englishName: 'Orangutini Ananassini',
      skill: '뇌절 임팩트 – 예측불가 기습공격', combat: 2, intelligence: 3, cuteness: 2, rarity: 4
    ),
    '일 칵토 히포포타모': CharacterInfo(
      id: 22, koreanName: '일 칵토 히포포타모', englishName: 'Il Cacto Hippopotamo',
      skill: '육중 바디 – 압도적 파워로 적을 밀어냄', combat: 5, intelligence: 3, cuteness: 4, rarity: 4
    ),
    '지라파 첼레스테': CharacterInfo(
      id: 23, koreanName: '지라파 첼레스테', englishName: 'Giraffa Celeste',
      skill: '뇌절 임팩트 – 예측불가 기습공격', combat: 5, intelligence: 3, cuteness: 4, rarity: 3
    ),
    '지브라 주브라 지브라리니': CharacterInfo(
      id: 24, koreanName: '지브라 주브라 지브라리니', englishName: 'Zebra Jubra Zebrarini',
      skill: '뇌절 임팩트 – 예측불가 기습공격', combat: 4, intelligence: 3, cuteness: 3, rarity: 4
    ),
    '침판지니 바나니니': CharacterInfo(
      id: 25, koreanName: '침판지니 바나니니', englishName: 'Chimpanzini Bananini',
      skill: '바나나 폭탄 – 직접 던지는 바나나 공격', combat: 3, intelligence: 2, cuteness: 4, rarity: 4
    ),
    '카푸치노 아사시노': CharacterInfo(
      id: 26, koreanName: '카푸치노 아사시노', englishName: 'Cappuccino Assassino',
      skill: '카페향 – 주변을 힐링', combat: 2, intelligence: 4, cuteness: 5, rarity: 4
    ),
    '코코판토 엘레판토': CharacterInfo(
      id: 27, koreanName: '코코판토 엘레판토', englishName: 'Cocopanto Elephanto',
      skill: '육중 바디 – 압도적 파워로 적을 밀어냄', combat: 4, intelligence: 3, cuteness: 3, rarity: 4
    ),
    '크로코딜도 페니시니': CharacterInfo(
      id: 28, koreanName: '크로코딜도 페니시니', englishName: 'Crocodildo Penisini',
      skill: '뇌절 임팩트 – 예측불가 기습공격', combat: 2, intelligence: 3, cuteness: 5, rarity: 3
    ),
    '타 타 타 타 타 타 타 타 타 타 타 사후르': CharacterInfo(
      id: 29, koreanName: '타 타 타 타 타 타 타 타 타 타 타 사후르', englishName: 'Ta Ta Ta Ta Ta Ta Ta Ta Ta Ta Ta Sahur',
      skill: '뇌절 임팩트 – 예측불가 기습공격', combat: 3, intelligence: 3, cuteness: 3, rarity: 5
    ),
    '퉁 퉁 퉁 퉁 퉁 퉁 퉁 퉁 퉁 사후르': CharacterInfo(
      id: 30, koreanName: '퉁 퉁 퉁 퉁 퉁 퉁 퉁 퉁 퉁 사후르', englishName: 'Tung Tung Tung Tung Tung Tung Tung Tung Tung Sahur',
      skill: '사후르 리듬 – 리듬에 맞춰 충격파를 발사', combat: 5, intelligence: 2, cuteness: 4, rarity: 4
    ),
    '트랄랄레로 트랄랄라': CharacterInfo(
      id: 31, koreanName: '트랄랄레로 트랄랄라', englishName: 'Tralalero Tralala',
      skill: '스니커즈 스프린트 – 물 위도 달릴 수 있는 속도로 적을 추격', combat: 4, intelligence: 4, cuteness: 3, rarity: 4
    ),
    '트래코투코툴루 델라펠라두스투즈': CharacterInfo(
      id: 32, koreanName: '트래코투코툴루 델라펠라두스투즈', englishName: 'Tracotucotulu Dellapelladustuz',
      skill: '뇌절 임팩트 – 예측불가 기습공격', combat: 4, intelligence: 2, cuteness: 4, rarity: 5
    ),
    '트룰리메로 트룰리치나': CharacterInfo(
      id: 33, koreanName: '트룰리메로 트룰리치나', englishName: 'Trullimero Trullichina',
      skill: '트룰리 춤 – 리듬 공격', combat: 3, intelligence: 3, cuteness: 4, rarity: 4
    ),
    '트리피 트로피1': CharacterInfo(
      id: 34, koreanName: '트리피 트로피1', englishName: 'Trippi Troppi 1',
      skill: '해저 충격파 – 바다에서 폭발하는 충격', combat: 3, intelligence: 2, cuteness: 4, rarity: 3
    ),
    '트리피 트로피2': CharacterInfo(
      id: 35, koreanName: '트리피 트로피2', englishName: 'Trippi Troppi 2',
      skill: '해저 충격파 – 바다에서 폭발하는 충격', combat: 3, intelligence: 2, cuteness: 4, rarity: 3
    ),
    '트릭 트랙 바라붐': CharacterInfo(
      id: 36, koreanName: '트릭 트랙 바라붐', englishName: 'Trick Track Baraboom',
      skill: '뇌절 임팩트 – 예측불가 기습공격', combat: 5, intelligence: 4, cuteness: 2, rarity: 4
    ),
    '티그룰리 그레이프루투니': CharacterInfo(
      id: 37, koreanName: '티그룰리 그레이프루투니', englishName: 'Tigruli GrapeFruitini',
      skill: '뇌절 임팩트 – 예측불가 기습공격', combat: 2, intelligence: 4, cuteness: 5, rarity: 5
    ),
    '티그룰리니 워터멜리니': CharacterInfo(
      id: 38, koreanName: '티그룰리니 워터멜리니', englishName: 'Tigrulini Watermelini',
      skill: '뇌절 임팩트 – 예측불가 기습공격', combat: 5, intelligence: 2, cuteness: 2, rarity: 4
    ),
    '팟 핫스팟': CharacterInfo(
      id: 39, koreanName: '팟 핫스팟', englishName: 'Pot Hotspot',
      skill: '뇌절 임팩트 – 예측불가 기습공격', combat: 2, intelligence: 5, cuteness: 2, rarity: 5
    ),
    '프룰리 프룰라': CharacterInfo(
      id: 40, koreanName: '프룰리 프룰라', englishName: 'Frulli Frulla',
      skill: '뇌절 임팩트 – 예측불가 기습공격', combat: 4, intelligence: 4, cuteness: 5, rarity: 2
    ),
    '프리고 카멜로': CharacterInfo(
      id: 41, koreanName: '프리고 카멜로', englishName: 'Frigo Camello',
      skill: '뇌절 임팩트 – 예측불가 기습공격', combat: 4, intelligence: 2, cuteness: 3, rarity: 3
    ),
  };

  static CharacterInfo? getCharacterInfo(String koreanName) {
    return _characters[koreanName];
  }
}

class RewardScreen extends StatefulWidget {
  final int score;
  final bool hasKeys;
  /// 치트 111119: true면 브레인 에너지 없이 스페셜 캐릭터 보상만 지급
  final bool forceSpecialReward;
  
  const RewardScreen({Key? key, required this.score, this.hasKeys = true, this.forceSpecialReward = false}) : super(key: key);

  @override
  State<RewardScreen> createState() => _RewardScreenState();
}

class _RewardScreenState extends State<RewardScreen> {
  String selectedImage = '';
  bool hasEarnedCharacter = false;
  CharacterInfo? selectedCharacterInfo;
  MobInfo? selectedMobInfo;
  final GlobalKey _repaintBoundaryKey = GlobalKey();
  bool isAllCollected = false;
  int totalCharacters = 41;
  int collectedCount = 0;
  bool isMinecraftMob = false; // false: 브레인롯, true: 마인크래프트
  bool isSpecialCharacter = false; // true: 이번 보상이 스페셜 캐릭터 (브레인 에너지 20 보장)
  SpecialInfo? selectedSpecialInfo; // 스페셜 보상 시 CSV 기반 카드 정보
  int selectedSpecialLevel = 1; // 스페셜 보상 시 도감 표시용 레벨 (1~5)
  
  // brainrot_image 폴더의 이미지 파일들
  final List<String> rewardImages = [
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

  // 마인크래프트 몹 이미지 경로 생성 함수 (실제 파일 확장자 매핑)
  String getMobImagePath(String mobName) {
    // 실제 파일 확장자 매핑 (CSV 기준)
    final Map<String, String> mobExtensions = {
      '가스트': '.jpg',
      '벡스': '.png',
      '복어': '.jpg',
      '브리즈': '.webp',
      '블레이즈': '.jpg',
      '스파이더 조키': '.jpg',
      '엔더마이트': '.jpg',
      '워든': '.jpg',
      '좀벌레': '.jpg',
      '좀비 주민': '.jpg',
      '치킨 조키': '.jpg',
      '팬텀': '.jpg',
      // 나머지는 .webp
    };
    
    String extension = mobExtensions[mobName] ?? '.webp';
    return 'minecraft_image/$mobName$extension';
  }
  
  // 실제 존재하는 이미지 경로 찾기
  String? findMobImagePath(String mobName) {
    return getMobImagePath(mobName);
  }

  // 마인크래프트 몹 이미지 목록 (실제 존재하는 파일만)
  List<String> getMobImages() {
    // 실제 존재하는 이미지 파일 목록 (확장자 포함)
    return [
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
  }

  @override
  void initState() {
    super.initState();
    
    // 열쇠가 있고 8점 이상이어야 캐릭터 획득
    hasEarnedCharacter = widget.score >= 8 && widget.hasKeys;
    print('RewardScreen initState: score = ${widget.score}, hasKeys = ${widget.hasKeys}, hasEarnedCharacter = $hasEarnedCharacter');
    if (hasEarnedCharacter) {
      _initializeReward();
    } else {
      if (widget.score >= 8 && !widget.hasKeys) {
        print('8점 이상이지만 열쇠가 없어서 캐릭터 획득 불가');
      } else {
        print('8점 미만이라 캐릭터 획득 불가');
      }
    }
  }

  Future<void> _initializeReward() async {
    final prefs = await SharedPreferences.getInstance();
    // 치트 111119: 만점 + 스페셜 보상 (브레인 에너지 소모 없음)
    if (widget.forceSpecialReward) {
      await _grantSpecialAsReward(consumeBrainEnergy: false);
      useKeyDirectly();
      return;
    }
    // 브레인 에너지가 이미 20인 경우 → 이번 회차 보상은 반드시 스페셜 캐릭터 (다음 번 보상)
    if ((prefs.getInt('brain_energy') ?? 0) == 20) {
      await _grantSpecialAsReward(consumeBrainEnergy: true);
      useKeyDirectly();
      return;
    }
    // 그 외: 브레인롯 또는 마인크래프트 몹 선택
    final random = Random();
    isMinecraftMob = random.nextBool(); // 50% 확률
    if (isMinecraftMob) {
      await selectRandomMob();
      await saveMobToCollection();
    } else {
      await selectRandomImage();
      await saveCharacterToCollection();
    }
    await _processBrainEnergy();
    useKeyDirectly();
  }

  static const int _specialMaxLevel = 5;

  /// special_levels JSON 로드: { "path": level (1~5) }
  static Future<Map<String, int>> _loadSpecialLevels(SharedPreferences prefs) async {
    try {
      final json = prefs.getString('special_levels');
      if (json == null || json.isEmpty) return {};
      final map = jsonDecode(json) as Map<String, dynamic>?;
      if (map == null) return {};
      return map.map((k, v) => MapEntry(k, (v is int ? v : int.tryParse(v.toString()) ?? 1).clamp(1, _specialMaxLevel)));
    } catch (_) {
      return {};
    }
  }

  static Future<void> _saveSpecialLevels(SharedPreferences prefs, Map<String, int> levels) async {
    await prefs.setString('special_levels', jsonEncode(levels));
  }

  /// 이번 보상을 스페셜 캐릭터로 지급 (최초 1, 중복 시 +1, 최대 5). [consumeBrainEnergy] true면 브레인 에너지 0으로 소모.
  Future<void> _grantSpecialAsReward({bool consumeBrainEnergy = true}) async {
    final prefs = await SharedPreferences.getInstance();
    final collected = prefs.getStringList('collected_special') ?? [];
    final levels = await _loadSpecialLevels(prefs);
    final allSpecial = await loadSpecialCharacterImagesFromCsv();
    final infoMap = await loadSpecialCharacterInfoFromCsv();
    final uncollected = allSpecial.where((e) => !collected.contains(e)).toList();
    String picked;
    if (uncollected.isNotEmpty) {
      picked = uncollected[Random().nextInt(uncollected.length)];
      collected.add(picked);
      levels[picked] = 1;
      await prefs.setStringList('collected_special', collected);
    } else {
      picked = allSpecial.isNotEmpty ? allSpecial[Random().nextInt(allSpecial.length)] : '';
      if (picked.isNotEmpty) {
        levels[picked] = ((levels[picked] ?? 1) + 1).clamp(1, _specialMaxLevel);
      }
    }
    await _saveSpecialLevels(prefs, levels);
    if (consumeBrainEnergy) await prefs.setInt('brain_energy', 0);
    if (!mounted) return;
    setState(() {
      isSpecialCharacter = true;
      selectedImage = picked;
      selectedSpecialInfo = infoMap[picked];
      selectedSpecialLevel = levels[picked] ?? 1;
      collectedCount = collected.length;
      totalCharacters = allSpecial.isEmpty ? 1 : allSpecial.length;
      isAllCollected = allSpecial.isNotEmpty && collected.length >= allSpecial.length;
    });
    print('스페셜 캐릭터 보상 획득: $picked 레벨 ${levels[picked]}${consumeBrainEnergy ? ' (브레인 에너지 20 사용)' : ' (치트)'}');
  }

  Future<void> _processBrainEnergy() async {
    if (widget.score != 10) return; // 만점일 때만
    final prefs = await SharedPreferences.getInstance();
    int energy = (prefs.getInt('brain_energy') ?? 0).clamp(0, 20);
    energy = (energy + 1).clamp(0, 20); // 20까지 채움, 다음 회차에 스페셜 지급
    await prefs.setInt('brain_energy', energy);
  }

  Future<void> useKeyDirectly() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      int keys = prefs.getInt('keys') ?? 5;
      print('현재 열쇠 개수: $keys');
      
      if (keys > 0) {
        keys--;
        await prefs.setInt('keys', keys);
        print('열쇠 차감 완료. 남은 열쇠: $keys');
      } else {
        print('열쇠가 0개라서 차감할 수 없음');
      }
    } catch (e) {
      print('열쇠 차감 중 오류 발생: $e');
    }
  }

  Future<void> selectRandomImage() async {
    final random = Random();
    final prefs = await SharedPreferences.getInstance();
    List<String> collectedCharacters = prefs.getStringList('collected_characters') ?? [];
    int pity = prefs.getInt('pity_gauge') ?? 0;
    
    // 미수집 캐릭터 목록 계산
    List<String> uncollectedCharacters = rewardImages
        .where((character) => !collectedCharacters.contains(character))
        .toList();
    
    String pickedImage;
    int newPity;
    
    // 수집 게이지 100%: 다음 보상은 반드시 신규 (미수집이 있을 때만)
    if (pity >= 100 && uncollectedCharacters.isNotEmpty) {
      pickedImage = uncollectedCharacters[random.nextInt(uncollectedCharacters.length)];
      newPity = 0;
      print('수집 게이지 100% 발동: 신규 캐릭터 보장');
    } else {
      pickedImage = rewardImages[random.nextInt(rewardImages.length)];
      if (pity >= 100) {
        newPity = 0; // 이미 전부 수집된 경우에도 수집 게이지 소모
      } else {
        // 중복 여부·게이지 갱신은 보상 수령 시점(saveCharacterToCollection)에서 처리
        newPity = pity;
      }
    }
    
    await prefs.setInt('pity_gauge', newPity);
    pity_state.pendingPityGauge = newPity; // 메인 복귀 시 즉시 반영

    setState(() {
      collectedCount = collectedCharacters.length;
      isAllCollected = uncollectedCharacters.isEmpty;
      selectedImage = pickedImage;
      String characterName = getCharacterName(selectedImage);
      selectedCharacterInfo = CharacterDatabase.getCharacterInfo(characterName);
      print('선택된 캐릭터: $characterName');
    });
  }

  Future<void> selectRandomMob() async {
    final random = Random();
    final prefs = await SharedPreferences.getInstance();
    List<String> collectedMobs = prefs.getStringList('collected_mobs') ?? [];
    final allMobImages = getMobImages();
    
    // 미수집 몹 목록 계산
    List<String> uncollectedMobs = allMobImages
        .where((mob) => !collectedMobs.contains(mob))
        .toList();
    
    int pity = prefs.getInt('pity_gauge') ?? 0;
    String pickedImage;
    int newPity;
    
    // 수집 게이지 100%: 다음 보상은 반드시 신규 (미수집이 있을 때만)
    if (pity >= 100 && uncollectedMobs.isNotEmpty) {
      pickedImage = uncollectedMobs[random.nextInt(uncollectedMobs.length)];
      newPity = 0;
      print('수집 게이지 100% 발동: 신규 몹 보장');
    } else {
      pickedImage = allMobImages[random.nextInt(allMobImages.length)];
      if (pity >= 100) {
        newPity = 0; // 이미 전부 수집된 경우에도 수집 게이지 소모
      } else {
        // 중복 여부·게이지 갱신은 보상 수령 시점(saveMobToCollection)에서 처리
        newPity = pity;
      }
    }
    
    await prefs.setInt('pity_gauge', newPity);
    pity_state.pendingPityGauge = newPity; // 메인 복귀 시 즉시 반영

    setState(() {
      collectedCount = collectedMobs.length;
      isAllCollected = uncollectedMobs.isEmpty;
      selectedImage = pickedImage;
      String mobName = getMobName(selectedImage);
      selectedMobInfo = MobDatabase.getMobInfo(mobName);
      totalCharacters = allMobImages.length;
      print('선택된 몹: $mobName');
    });
  }

  String getMobName(String imagePath) {
    String fileName = imagePath.split('/').last;
    // 확장자 제거 (.webp, .png, .jpg)
    if (fileName.endsWith('.webp')) {
      return fileName.replaceAll('.webp', '');
    } else if (fileName.endsWith('.png')) {
      return fileName.replaceAll('.png', '');
    } else if (fileName.endsWith('.jpg')) {
      return fileName.replaceAll('.jpg', '');
    }
    return fileName;
  }

  Future<void> saveCharacterToCollection() async {
    if (selectedImage.isEmpty) return;
    final prefs = await SharedPreferences.getInstance();
    List<String> collectedCharacters = prefs.getStringList('collected_characters') ?? [];
    final isDuplicate = collectedCharacters.contains(selectedImage);

    // 보상 수령 시점에 중복이면 수집 게이지 +20% (타이밍 맞춤)
    if (isDuplicate) {
      final pity = prefs.getInt('pity_gauge') ?? 0;
      final newPity = (pity + 20).clamp(0, 100);
      await prefs.setInt('pity_gauge', newPity);
      pity_state.pendingPityGauge = newPity; // 메인 복귀 시 즉시 반영
      print('보상 수령(중복 캐릭터) → 수집 게이지 $pity% → $newPity%');
    } else {
      // 새 캐릭터 획득 시 수집 게이지 초기화
      collectedCharacters.add(selectedImage);
      await prefs.setStringList('collected_characters', collectedCharacters);
      await prefs.setInt('pity_gauge', 0);
      pity_state.pendingPityGauge = 0;
      print('보상 수령(신규 캐릭터) → 수집 게이지 0%로 초기화');
    }
  }

  Future<void> saveMobToCollection() async {
    if (selectedImage.isEmpty) return;
    final prefs = await SharedPreferences.getInstance();
    List<String> collectedMobs = prefs.getStringList('collected_mobs') ?? [];
    final isDuplicate = collectedMobs.contains(selectedImage);

    // 보상 수령 시점에 중복이면 수집 게이지 +20% (타이밍 맞춤)
    if (isDuplicate) {
      final pity = prefs.getInt('pity_gauge') ?? 0;
      final newPity = (pity + 20).clamp(0, 100);
      await prefs.setInt('pity_gauge', newPity);
      pity_state.pendingPityGauge = newPity; // 메인 복귀 시 즉시 반영
      print('보상 수령(중복 몹) → 수집 게이지 $pity% → $newPity%');
    } else {
      // 새 몹 획득 시 수집 게이지 초기화
      collectedMobs.add(selectedImage);
      await prefs.setStringList('collected_mobs', collectedMobs);
      await prefs.setInt('pity_gauge', 0);
      pity_state.pendingPityGauge = 0;
      print('보상 수령(신규 몹) → 수집 게이지 0%로 초기화');
    }
  }

  String getCharacterName(String imagePath) {
    return imagePath
        .split('/')
        .last
        .replaceAll('.webp', '')
        .replaceAll('brainrot_image/', '');
  }

  // 별 표시 위젯 (채워진 별만 표시)
  Widget buildStarsWidget(int rating) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(rating, (index) {
        return const Icon(
          Icons.star,
          color: Colors.amber,
          size: 18,
        );
      }),
    );
  }

  String getGradeText() {
    if (widget.score == 10) {
      return '완벽해요! 🌟';
    } else if (widget.score >= 8) {
      return '훌륭해요! 🎉';
    } else if (widget.score >= 6) {
      return '잘했어요! 👏';
    } else if (widget.score >= 4) {
      return '좋아요! 😊';
    } else {
      return '다시 도전해봐요! 💪';
    }
  }

  Color getGradeColor() {
    if (widget.score == 10) {
      return Colors.amber;
    } else if (widget.score >= 8) {
      return Colors.green;
    } else if (widget.score >= 6) {
      return Colors.blue;
    } else if (widget.score >= 4) {
      return Colors.orange;
    } else {
      return Colors.red;
    }
  }

  // 캐릭터 정보 캡쳐 및 저장 기능
  Future<void> captureAndSaveCharacterInfo() async {
    try {
      // 권한 확인
      var status = await Permission.storage.status;
      if (!status.isGranted) {
        await Permission.storage.request();
      }

      // Android 13+ 에서는 photos 권한이 필요
      if (Platform.isAndroid) {
        var photoStatus = await Permission.photos.status;
        if (!photoStatus.isGranted) {
          await Permission.photos.request();
        }
      }

      // RepaintBoundary로 감싸진 위젯 캡쳐
      RenderRepaintBoundary boundary = _repaintBoundaryKey.currentContext!
          .findRenderObject() as RenderRepaintBoundary;
      
      // 이미지로 변환 (고해상도)
      ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      
      // PNG 형식으로 변환
      ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      Uint8List pngBytes = byteData!.buffer.asUint8List();
      
      // 임시 파일 생성
      final tempDir = await getTemporaryDirectory();
      final characterName = isSpecialCharacter
          ? (selectedSpecialInfo?.name ?? selectedImage.split('/').last.replaceAll(RegExp(r'\.(png|webp|jpg)$'), ''))
          : getCharacterName(selectedImage);
      final fileName = '${characterName}_정보.png';
      final tempFile = File('${tempDir.path}/$fileName');
      await tempFile.writeAsBytes(pngBytes);
      
      // 갤러리에 저장
      await Gal.putImage(tempFile.path, album: '브레인롯 수학게임');
      
      // 임시 파일 삭제
      await tempFile.delete();
      
      // 성공 메시지
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(isSpecialCharacter
                ? '스페셜 정보가 갤러리에 저장되었습니다!'
                : '캐릭터 정보가 갤러리에 저장되었습니다!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      print('캐릭터 정보 캡쳐 실패: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('캐릭터 정보 저장에 실패했습니다.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Widget _buildDefaultRewardImage() {
    return Container(
      width: 300,
      height: 300,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.emoji_events,
            size: 80,
            color: Colors.amber[600],
          ),
          const SizedBox(height: 10),
          Text(
            '축하합니다!',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey[700],
            ),
          ),
        ],
      ),
    );
  }

  // 보상 콘텐츠 (스페셜 / 브레인롯 / 마인크래프트)
  Widget _buildRewardContent() {
    if (isSpecialCharacter) {
      return _buildSpecialReward();
    }
    if (isMinecraftMob) {
      return _buildMinecraftReward();
    }
    return _buildBrainrotReward();
  }

  /// 스페셜 캐릭터 보상 위젯 (.png 우선, 없으면 .webp) + CSV 기반 카드 정보
  Widget _buildSpecialReward() {
    if (selectedImage.isEmpty) {
      return const Center(child: Text('스페셜 캐릭터를 불러오지 못했습니다.'));
    }
    final name = selectedSpecialInfo?.name ?? selectedImage
        .replaceFirst('special_image/', '')
        .replaceAll('.png', '')
        .replaceAll('.webp', '');
    final webpPath = selectedImage.replaceFirst('.png', '.webp');
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Text(
              '⭐ 스페셜 캐릭터 획득!',
              style: Theme.of(context).textTheme.displayMedium?.copyWith(
                color: Colors.amber[800],
              ),
            ),
            if (hasEarnedCharacter) ...[
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.amber[100],
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: Colors.amber[300]!),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.psychology, size: 16, color: Colors.amber),
                    const SizedBox(width: 6),
                    Text(
                      '스페셜: $collectedCount/$totalCharacters',
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.amber[800]),
                    ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 15),
            RepaintBoundary(
              key: _repaintBoundaryKey,
              child: Container(
                padding: const EdgeInsets.all(20),
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
                      name,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Colors.amber[800],
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 15),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: Image.asset(
                        selectedImage,
                        width: 300,
                        height: 300,
                        fit: BoxFit.contain,
                        errorBuilder: (_, __, ___) {
                          return Image.asset(
                            webpPath,
                            width: 300,
                            height: 300,
                            fit: BoxFit.contain,
                            errorBuilder: (_, __, ___) => Icon(Icons.image_not_supported, size: 80, color: Colors.grey[400]),
                          );
                        },
                      ),
                    ),
                    if (selectedSpecialInfo != null) ...[
                      const SizedBox(height: 20),
                      Container(
                        padding: const EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          color: Colors.amber[50],
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.amber[200]!),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '📊 스페셜 정보',
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                color: Colors.amber[800],
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Text(
                                  '레벨 $selectedSpecialLevel',
                                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.amber[800]),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                const Text('⚔️ 공격력: ', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                                Text(selectedSpecialInfo!.attackPower, style: const TextStyle(fontSize: 14)),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                const Text('❤️ 생명력: ', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                                Text(selectedSpecialInfo!.health, style: const TextStyle(fontSize: 14)),
                              ],
                            ),
                            if (selectedSpecialInfo!.specialAbility.isNotEmpty) ...[
                              const SizedBox(height: 8),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('✨ 특수능력: ', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                                  Expanded(
                                    child: Text(selectedSpecialInfo!.specialAbility, style: const TextStyle(fontSize: 14)),
                                  ),
                                ],
                              ),
                            ],
                            if (selectedSpecialInfo!.dropItems.isNotEmpty) ...[
                              const SizedBox(height: 12),
                              Text(
                                '🎁 드롭 아이템:',
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.amber[700],
                                ),
                              ),
                              const SizedBox(height: 4),
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: Colors.amber[100],
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: Colors.amber[200]!),
                                ),
                                child: Text(
                                  selectedSpecialInfo!.dropItems,
                                  style: TextStyle(fontSize: 13, color: Colors.amber[800]),
                                ),
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
            const SizedBox(height: 15),
            ElevatedButton.icon(
              onPressed: captureAndSaveCharacterInfo,
              icon: const Icon(Icons.save_alt),
              label: const Text('스페셜 정보 저장'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.amber[700],
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 브레인롯 캐릭터 보상 위젯
  Widget _buildBrainrotReward() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Text(
              '새로운 캐릭터 획득!',
              style: Theme.of(context).textTheme.displayMedium?.copyWith(
                color: Colors.amber[800],
              ),
            ),
            
            // 수집 진행 상황
            if (hasEarnedCharacter) ...[
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: isAllCollected ? Colors.green[100] : Colors.blue[100],
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(
                    color: isAllCollected ? Colors.green[300]! : Colors.blue[300]!,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      isAllCollected ? Icons.star : Icons.collections,
                      size: 16,
                      color: isAllCollected ? Colors.green[700] : Colors.blue[700],
                    ),
                    const SizedBox(width: 6),
                    Text(
                      isAllCollected 
                          ? '🎉 도감 완성!'
                          : '📚 도감 진행: $collectedCount/$totalCharacters (복원추출)',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: isAllCollected ? Colors.green[700] : Colors.blue[700],
                      ),
                    ),
                  ],
                ),
              ),
            ],
            
            const SizedBox(height: 15),
            
            if (selectedImage.isNotEmpty) ...[
              RepaintBoundary(
                key: _repaintBoundaryKey,
                child: Container(
                  padding: const EdgeInsets.all(20),
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
                        getCharacterName(selectedImage),
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Colors.pink[800],
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 15),
                      
                      ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: Image.asset(
                          selectedImage,
                          width: 300,
                          height: 300,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) {
                            return _buildDefaultRewardImage();
                          },
                        ),
                      ),
                      
                      if (selectedCharacterInfo != null) ...[
                        const SizedBox(height: 20),
                        Container(
                          padding: const EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            color: Colors.pink[50],
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.pink[200]!),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '📊 캐릭터 정보',
                                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  color: Colors.pink[800],
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 12),
                              
                              Text(
                                '영어 이름: ${selectedCharacterInfo!.englishName}',
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                              const SizedBox(height: 8),
                              
                              Row(
                                children: [
                                  const Text('🥊 전투력: ', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                                  buildStarsWidget(selectedCharacterInfo!.combat),
                                ],
                              ),
                              const SizedBox(height: 6),
                              
                              Row(
                                children: [
                                  const Text('🧠 지능: ', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                                  buildStarsWidget(selectedCharacterInfo!.intelligence),
                                ],
                              ),
                              const SizedBox(height: 6),
                              
                              Row(
                                children: [
                                  const Text('💖 귀여움: ', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                                  buildStarsWidget(selectedCharacterInfo!.cuteness),
                                ],
                              ),
                              const SizedBox(height: 6),
                              
                              Row(
                                children: [
                                  const Text('💎 희귀도: ', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                                  buildStarsWidget(selectedCharacterInfo!.rarity),
                                ],
                              ),
                              const SizedBox(height: 12),
                              
                              Text(
                                '⚡ 특수 스킬:',
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.purple[700],
                                ),
                              ),
                              const SizedBox(height: 4),
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: Colors.purple[50],
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: Colors.purple[200]!),
                                ),
                                child: Text(
                                  selectedCharacterInfo!.skill,
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.purple[800],
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 15),
              ElevatedButton.icon(
                onPressed: captureAndSaveCharacterInfo,
                icon: const Icon(Icons.save_alt),
                label: const Text('캐릭터 정보 저장'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  // 마인크래프트 몹 보상 위젯
  Widget _buildMinecraftReward() {
    if (!hasEarnedCharacter || selectedMobInfo == null || selectedImage.isEmpty) {
      return const Center(child: Text('마인크래프트 몹을 선택하지 못했습니다.'));
    }

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Text(
              '새로운 몹 획득!',
              style: Theme.of(context).textTheme.displayMedium?.copyWith(
                color: Colors.green[800],
              ),
            ),
            
            // 수집 진행 상황
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: isAllCollected ? Colors.green[100] : Colors.blue[100],
                borderRadius: BorderRadius.circular(15),
                border: Border.all(
                  color: isAllCollected ? Colors.green[300]! : Colors.blue[300]!,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    isAllCollected ? Icons.star : Icons.collections,
                    size: 16,
                    color: isAllCollected ? Colors.green[700] : Colors.blue[700],
                  ),
                  const SizedBox(width: 6),
                  Text(
                    isAllCollected 
                        ? '🎉 도감 완성!'
                        : '📚 도감 진행: $collectedCount/$totalCharacters (신규 몹 우선)',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: isAllCollected ? Colors.green[700] : Colors.blue[700],
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 15),
            
            RepaintBoundary(
              key: _repaintBoundaryKey,
              child: Container(
                padding: const EdgeInsets.all(20),
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
                      selectedMobInfo!.name,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Colors.green[800],
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 15),
                    
                    ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: Image.asset(
                        selectedImage,
                        width: 300,
                        height: 300,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) {
                          // .webp 실패 시 .png 또는 .jpg 시도
                          String basePath = selectedImage.replaceAll('.webp', '').replaceAll('.png', '').replaceAll('.jpg', '');
                          String pngPath = '$basePath.png';
                          String jpgPath = '$basePath.jpg';
                          return Image.asset(
                            pngPath,
                            width: 300,
                            height: 300,
                            fit: BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) {
                              return Image.asset(
                                jpgPath,
                                width: 300,
                                height: 300,
                                fit: BoxFit.contain,
                                errorBuilder: (context, error, stackTrace) {
                                  return _buildDefaultRewardImage();
                                },
                              );
                            },
                          );
                        },
                      ),
                    ),
                    
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: Colors.green[50],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.green[200]!),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '📊 몹 정보',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              color: Colors.green[800],
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 12),
                          
                          Row(
                            children: [
                              const Text('⚔️ 공격력: ', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                              Text(
                                selectedMobInfo!.attackPower,
                                style: const TextStyle(fontSize: 14),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          
                          Row(
                            children: [
                              const Text('❤️ 생명력: ', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                              Text(
                                selectedMobInfo!.health,
                                style: const TextStyle(fontSize: 14),
                              ),
                            ],
                          ),
                          
                          if (selectedMobInfo!.specialAbility.isNotEmpty) ...[
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                const Text('✨ 특수능력: ', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                                Expanded(
                                  child: Text(
                                    selectedMobInfo!.specialAbility,
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                ),
                              ],
                            ),
                          ],
                          
                          if (selectedMobInfo!.dropItems.isNotEmpty) ...[
                            const SizedBox(height: 12),
                            Text(
                              '🎁 드롭 아이템:',
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.orange[700],
                              ),
                            ),
                            const SizedBox(height: 4),
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.orange[50],
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: Colors.orange[200]!),
                              ),
                              child: Text(
                                selectedMobInfo!.dropItems,
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.orange[800],
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 15),
            ElevatedButton.icon(
              onPressed: captureAndSaveCharacterInfo,
              icon: const Icon(Icons.save_alt),
              label: const Text('몹 정보 저장'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 보상 획득 실패 위젯
  Widget _buildNoReward() {
    return Container(
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.symmetric(horizontal: 20),
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
            '캐릭터 획득 실패',
            style: Theme.of(context).textTheme.displayMedium?.copyWith(
              color: Colors.grey[600],
            ),
          ),
          
          // 열쇠가 없어서 보상을 획득하지 못한 경우 안내
          if (widget.score >= 8 && !widget.hasKeys) ...[
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.orange[50],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.orange[300]!),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.warning_amber_rounded, color: Colors.orange[700], size: 20),
                  const SizedBox(width: 8),
                  Flexible(
                    child: Text(
                      '열쇠가 없어서 보상을 획득하지 못했습니다.\n열쇠는 6시간마다 하나씩 충전됩니다.',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: Colors.orange[800],
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          ],
          
          const SizedBox(height: 20),
          Container(
            width: 300,
            height: 300,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(15),
              border: Border.all(
                color: Colors.grey[400]!,
                style: BorderStyle.solid,
                width: 2,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.lock,
                  size: 80,
                  color: Colors.grey[600],
                ),
                const SizedBox(height: 20),
                Text(
                  '8문제 이상 맞혀야\n캐릭터를 획득할 수 있어요!',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[700],
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.pink[50],
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
              // 축하 메시지
              Container(
                padding: const EdgeInsets.all(20),
                margin: const EdgeInsets.symmetric(horizontal: 20),
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
                      '게임 완료!',
                      style: Theme.of(context).textTheme.displayLarge?.copyWith(
                        color: Colors.pink[800],
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      '점수: ${widget.score}/10',
                      style: Theme.of(context).textTheme.displayMedium?.copyWith(
                        color: getGradeColor(),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      getGradeText(),
                      style: Theme.of(context).textTheme.displayMedium?.copyWith(
                        color: getGradeColor(),
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 30),
              
              // 보상 영역
              if (hasEarnedCharacter)
                _buildRewardContent()
              else
                _buildNoReward(),
              
              const SizedBox(height: 40),
              
                              // 버튼들
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    // 결과를 전달하면서 HomeScreen으로 돌아가기
                    Navigator.popUntil(context, (route) => route.isFirst);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 40,
                      vertical: 20,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  child: const Text('다시 시작'),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
  }
} 