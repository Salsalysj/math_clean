import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';
import 'package:gal/gal.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/rendering.dart';
import 'package:math_game_clean/special_characters.dart';

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

class CollectionScreen extends StatefulWidget {
  const CollectionScreen({super.key});

  @override
  State<CollectionScreen> createState() => _CollectionScreenState();
}

class _CollectionScreenState extends State<CollectionScreen> with SingleTickerProviderStateMixin {
  List<String> collectedCharacters = [];
  List<String> collectedMobs = [];
  List<String> collectedSpecial = [];
  List<String> allSpecial = []; // special_mobs.csv에서 로드
  Map<String, SpecialInfo> specialInfoMap = {}; // 이미지 경로 → 스페셜 카드 정보
  Map<String, int> specialLevels = {}; // 이미지 경로 → 레벨 (1~5)
  late TabController _tabController;
  
  // 전체 캐릭터 목록
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
  
  final List<String> allMobs = []; // initState에서 초기화

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    allMobs.addAll(getMobImages());
    loadCollectedData();
    _loadSpecialFromCsv();
  }

  Future<void> _loadSpecialFromCsv() async {
    final list = await loadSpecialCharacterImagesFromCsv();
    final infoMap = await loadSpecialCharacterInfoFromCsv();
    if (mounted) {
      setState(() {
      allSpecial = list;
      specialInfoMap = infoMap;
    });
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> loadCollectedData() async {
    final prefs = await SharedPreferences.getInstance();
    Map<String, int> levels = {};
    try {
      final json = prefs.getString('special_levels');
      if (json != null && json.isNotEmpty) {
        final map = jsonDecode(json) as Map<String, dynamic>?;
        if (map != null) {
          levels = map.map((k, v) => MapEntry(k, (v is int ? v : int.tryParse(v.toString()) ?? 1).clamp(1, 5)));
        }
      }
    } catch (_) {}
    setState(() {
      collectedCharacters = prefs.getStringList('collected_characters') ?? [];
      collectedMobs = prefs.getStringList('collected_mobs') ?? [];
      collectedSpecial = prefs.getStringList('collected_special') ?? [];
      specialLevels = levels;
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

  String getCharacterName(String imagePath) {
    return imagePath
        .split('/')
        .last
        .replaceAll('.webp', '')
        .replaceAll('brainrot_image/', '');
  }

  /// 스페셜 캐릭터 이미지: .png 우선, 없으면 .webp
  Widget _buildSpecialImage(String imagePath, {BoxFit fit = BoxFit.contain, double? width, double? height}) {
    final webpPath = imagePath.replaceFirst('.png', '.webp');
    return Image.asset(
      imagePath,
      fit: fit,
      width: width,
      height: height,
      errorBuilder: (_, __, ___) {
        return Image.asset(
          webpPath,
          fit: fit,
          width: width,
          height: height,
          errorBuilder: (_, __, ___) => Icon(Icons.image_not_supported, size: height != null ? height * 0.4 : 80, color: Colors.grey[400]),
        );
      },
    );
  }

  // 몹 이미지를 로드하는 위젯 (확장자 자동 시도)
  Widget _buildMobImage(String mobPath) {
    String basePath = mobPath.replaceAll('.webp', '').replaceAll('.png', '').replaceAll('.jpg', '');
    
    return Image.asset(
      mobPath,
      fit: BoxFit.contain,
      width: double.infinity,
      errorBuilder: (context, error, stackTrace) {
        // 현재 확장자 실패 시 다른 확장자 시도
        String webpPath = '$basePath.webp';
        String pngPath = '$basePath.png';
        String jpgPath = '$basePath.jpg';
        
        // .webp 시도
        return Image.asset(
          webpPath,
          fit: BoxFit.contain,
          width: double.infinity,
          errorBuilder: (context, error, stackTrace) {
            // .png 시도
            return Image.asset(
              pngPath,
              fit: BoxFit.contain,
              width: double.infinity,
              errorBuilder: (context, error, stackTrace) {
                // .jpg 시도
                return Image.asset(
                  jpgPath,
                  fit: BoxFit.contain,
                  width: double.infinity,
                  errorBuilder: (context, error, stackTrace) {
                    // 모두 실패 시 에러 아이콘
                    return Container(
                      color: Colors.grey[300],
                      child: Icon(
                        Icons.image_not_supported,
                        color: Colors.grey[600],
                      ),
                    );
                  },
                );
              },
            );
          },
        );
      },
    );
  }

  // 캐릭터 정보 캡쳐 및 저장 기능
  Future<void> captureAndSaveCharacterInfo(GlobalKey repaintBoundaryKey, String characterName) async {
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
      RenderRepaintBoundary boundary = repaintBoundaryKey.currentContext!
          .findRenderObject() as RenderRepaintBoundary;
      
      // 이미지로 변환 (고해상도)
      ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      
      // PNG 형식으로 변환
      ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      Uint8List pngBytes = byteData!.buffer.asUint8List();
      
      // 임시 파일 생성
      final tempDir = await getTemporaryDirectory();
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
          const SnackBar(
            content: Text('캐릭터 정보가 갤러리에 저장되었습니다!'),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.indigo[50],
      appBar: AppBar(
        title: const Text('캐릭터 도감'),
        backgroundColor: Colors.indigo[600],
        foregroundColor: Colors.white,
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          indicatorColor: Colors.white,
          tabs: const [
            Tab(text: '브레인롯 캐릭터'),
            Tab(text: '마인크래프트 몹'),
            Tab(text: '스페셜 캐릭터'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildBrainrotTab(),
          _buildMinecraftTab(),
          _buildSpecialTab(),
        ],
      ),
    );
  }

  // 브레인롯 캐릭터 탭
  Widget _buildBrainrotTab() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // 진행률 표시
            Container(
              padding: const EdgeInsets.all(16),
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
                children: [
                  Text(
                    '수집 진행률',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.indigo[800],
                    ),
                  ),
                  const SizedBox(height: 10),
                  LinearProgressIndicator(
                    value: allCharacters.isEmpty ? 0 : collectedCharacters.length / allCharacters.length,
                    backgroundColor: Colors.grey[300],
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.indigo[600]!),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    allCharacters.isEmpty 
                        ? '0% 완료'
                        : '${(collectedCharacters.length / allCharacters.length * 100).toStringAsFixed(1)}% 완료',
                    style: TextStyle(
                      color: Colors.indigo[600],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    '${collectedCharacters.length}/${allCharacters.length}',
                    style: TextStyle(
                      color: Colors.indigo[600],
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 20),
            
            // 캐릭터 그리드
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: 0.8,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: allCharacters.length,
                itemBuilder: (context, index) {
                    final character = allCharacters[index];
                    final isCollected = collectedCharacters.contains(character);
                    final characterName = getCharacterName(character);
                    
                    return GestureDetector(
                      onTap: isCollected ? () {
                        final characterInfo = CharacterDatabase.getCharacterInfo(characterName);
                        showDialog(
                          context: context,
                          builder: (context) {
                            final GlobalKey dialogKey = GlobalKey();
                            return Dialog(
                              insetPadding: const EdgeInsets.all(20),
                              child: SizedBox(
                                width: double.maxFinite,
                                height: MediaQuery.of(context).size.height * 0.85,
                                child: SingleChildScrollView(
                                  child: Container(
                                    padding: const EdgeInsets.all(20),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        // 캐릭터 정보 전체를 RepaintBoundary로 감싸기
                                        RepaintBoundary(
                                          key: dialogKey,
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
                                                // 캐릭터 이름
                                                Text(
                                                  characterName,
                                                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                                    color: Colors.indigo[800],
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                  textAlign: TextAlign.center,
                                                ),
                                                const SizedBox(height: 20),
                                                
                                                // 캐릭터 이미지
                                                ClipRRect(
                                                  borderRadius: BorderRadius.circular(15),
                                                  child: Image.asset(
                                                    character,
                                                    width: 250,
                                                    height: 250,
                                                    fit: BoxFit.contain,
                                                    errorBuilder: (context, error, stackTrace) {
                                                      return Container(
                                                        width: 250,
                                                        height: 250,
                                                        color: Colors.grey[300],
                                                        child: Icon(
                                                          Icons.image_not_supported,
                                                          size: 50,
                                                          color: Colors.grey[600],
                                                        ),
                                                      );
                                                    },
                                                  ),
                                                ),
                                                
                                                // 캐릭터 상세 정보
                                                if (characterInfo != null) ...[
                                                  const SizedBox(height: 20),
                                                  Container(
                                                    padding: const EdgeInsets.all(15),
                                                    decoration: BoxDecoration(
                                                      color: Colors.indigo[50],
                                                      borderRadius: BorderRadius.circular(12),
                                                      border: Border.all(color: Colors.indigo[200]!),
                                                    ),
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Text(
                                                          '📊 캐릭터 정보',
                                                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                                            color: Colors.indigo[800],
                                                            fontWeight: FontWeight.bold,
                                                          ),
                                                        ),
                                                        const SizedBox(height: 12),
                                                        
                                                        // 영어 이름
                                                        Text(
                                                          '영어 이름: ${characterInfo.englishName}',
                                                          style: const TextStyle(
                                                            fontSize: 13,
                                                            color: Colors.grey,
                                                            fontStyle: FontStyle.italic,
                                                          ),
                                                        ),
                                                        const SizedBox(height: 8),
                                                        
                                                        // 능력치들
                                                        Row(
                                                          children: [
                                                            const Text('🥊 전투력: ', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                                                            buildStarsWidget(characterInfo.combat),
                                                          ],
                                                        ),
                                                        const SizedBox(height: 6),
                                                        
                                                        Row(
                                                          children: [
                                                            const Text('🧠 지능: ', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                                                            buildStarsWidget(characterInfo.intelligence),
                                                          ],
                                                        ),
                                                        const SizedBox(height: 6),
                                                        
                                                        Row(
                                                          children: [
                                                            const Text('💖 귀여움: ', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                                                            buildStarsWidget(characterInfo.cuteness),
                                                          ],
                                                        ),
                                                        const SizedBox(height: 6),
                                                        
                                                        Row(
                                                          children: [
                                                            const Text('💎 희귀도: ', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                                                            buildStarsWidget(characterInfo.rarity),
                                                          ],
                                                        ),
                                                        const SizedBox(height: 12),
                                                        
                                                        // 특수 스킬
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
                                                            characterInfo.skill,
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
                                        
                                        // 캐릭터 정보 저장 버튼
                                        const SizedBox(height: 15),
                                        ElevatedButton.icon(
                                          onPressed: () => captureAndSaveCharacterInfo(dialogKey, characterName),
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
                                        
                                        const SizedBox(height: 20),
                                        ElevatedButton(
                                          onPressed: () => Navigator.pop(context),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.indigo,
                                            foregroundColor: Colors.white,
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(20),
                                            ),
                                          ),
                                          child: const Text('닫기'),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      } : null,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.3),
                              spreadRadius: 1,
                              blurRadius: 3,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Expanded(
                              child: ClipRRect(
                                borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(12),
                                ),
                                child: isCollected
                                    ? Image.asset(
                                        character,
                                        fit: BoxFit.contain,
                                        width: double.infinity,
                                        errorBuilder: (context, error, stackTrace) {
                                          return Container(
                                            color: Colors.grey[300],
                                            child: Icon(
                                              Icons.image_not_supported,
                                              color: Colors.grey[600],
                                            ),
                                          );
                                        },
                                      )
                                    : Container(
                                        color: Colors.grey[400],
                                        child: Icon(
                                          Icons.help_outline,
                                          size: 40,
                                          color: Colors.grey[600],
                                        ),
                                      ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.all(8),
                              child: Text(
                                isCollected ? characterName : '???',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: isCollected ? Colors.indigo[800] : Colors.grey[600],
                                ),
                                textAlign: TextAlign.center,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      );
  }

  // 마인크래프트 몹 탭
  Widget _buildMinecraftTab() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // 진행률 표시
            Container(
              padding: const EdgeInsets.all(16),
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
                children: [
                  Text(
                    '수집 진행률',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.green[800],
                    ),
                  ),
                  const SizedBox(height: 10),
                  LinearProgressIndicator(
                    value: allMobs.isEmpty ? 0 : collectedMobs.length / allMobs.length,
                    backgroundColor: Colors.grey[300],
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.green[600]!),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    allMobs.isEmpty 
                        ? '0% 완료'
                        : '${(collectedMobs.length / allMobs.length * 100).toStringAsFixed(1)}% 완료',
                    style: TextStyle(
                      color: Colors.green[600],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    '${collectedMobs.length}/${allMobs.length}',
                    style: TextStyle(
                      color: Colors.green[600],
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 20),
            
            // 몹 그리드
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: 0.8,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: allMobs.length,
                itemBuilder: (context, index) {
                  final mob = allMobs[index];
                  final mobName = getMobName(mob);
                  // 확장자 무시하고 몹 이름 기준으로 수집 여부 확인
                  final isCollected = collectedMobs.any((collected) => getMobName(collected) == mobName);
                  
                  return GestureDetector(
                    onTap: isCollected ? () {
                      final mobInfo = MobDatabase.getMobInfo(mobName);
                      showDialog(
                        context: context,
                        builder: (context) {
                          final GlobalKey dialogKey = GlobalKey();
                          return Dialog(
                            insetPadding: const EdgeInsets.all(20),
                            child: SizedBox(
                              width: double.maxFinite,
                              height: MediaQuery.of(context).size.height * 0.85,
                              child: SingleChildScrollView(
                                child: Container(
                                  padding: const EdgeInsets.all(20),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      RepaintBoundary(
                                        key: dialogKey,
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
                                                mobName,
                                                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                                  color: Colors.green[800],
                                                  fontWeight: FontWeight.bold,
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                              const SizedBox(height: 20),
                                              
                                              ClipRRect(
                                                borderRadius: BorderRadius.circular(15),
                                                child: Image.asset(
                                                  mob,
                                                  width: 250,
                                                  height: 250,
                                                  fit: BoxFit.contain,
                                                  errorBuilder: (context, error, stackTrace) {
                                                    // .webp 실패 시 .png 또는 .jpg 시도
                                                    String basePath = mob.replaceAll('.webp', '').replaceAll('.png', '').replaceAll('.jpg', '');
                                                    String pngPath = '$basePath.png';
                                                    String jpgPath = '$basePath.jpg';
                                                    return Image.asset(
                                                      pngPath,
                                                      width: 250,
                                                      height: 250,
                                                      fit: BoxFit.contain,
                                                      errorBuilder: (context, error, stackTrace) {
                                                        return Image.asset(
                                                          jpgPath,
                                                          width: 250,
                                                          height: 250,
                                                          fit: BoxFit.contain,
                                                          errorBuilder: (context, error, stackTrace) {
                                                            return Container(
                                                              width: 250,
                                                              height: 250,
                                                              color: Colors.grey[300],
                                                              child: Icon(
                                                                Icons.image_not_supported,
                                                                size: 50,
                                                                color: Colors.grey[600],
                                                              ),
                                                            );
                                                          },
                                                        );
                                                      },
                                                    );
                                                  },
                                                ),
                                              ),
                                              
                                              if (mobInfo != null) ...[
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
                                                            mobInfo.attackPower,
                                                            style: const TextStyle(fontSize: 14),
                                                          ),
                                                        ],
                                                      ),
                                                      const SizedBox(height: 8),
                                                      
                                                      Row(
                                                        children: [
                                                          const Text('❤️ 생명력: ', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                                                          Text(
                                                            mobInfo.health,
                                                            style: const TextStyle(fontSize: 14),
                                                          ),
                                                        ],
                                                      ),
                                                      
                                                      if (mobInfo.specialAbility.isNotEmpty) ...[
                                                        const SizedBox(height: 8),
                                                        Row(
                                                          children: [
                                                            const Text('✨ 특수능력: ', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                                                            Expanded(
                                                              child: Text(
                                                                mobInfo.specialAbility,
                                                                style: const TextStyle(fontSize: 14),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                      
                                                      if (mobInfo.dropItems.isNotEmpty) ...[
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
                                                            mobInfo.dropItems,
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
                                            ],
                                          ),
                                        ),
                                      ),
                                      
                                      const SizedBox(height: 15),
                                      ElevatedButton.icon(
                                        onPressed: () => captureAndSaveCharacterInfo(dialogKey, mobName),
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
                                      
                                      const SizedBox(height: 20),
                                      ElevatedButton(
                                        onPressed: () => Navigator.pop(context),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.green,
                                          foregroundColor: Colors.white,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(20),
                                          ),
                                        ),
                                        child: const Text('닫기'),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    } : null,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.3),
                            spreadRadius: 1,
                            blurRadius: 3,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Expanded(
                            child: ClipRRect(
                              borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(12),
                              ),
                              child: isCollected
                                  ? _buildMobImage(mob)
                                  : Container(
                                      color: Colors.grey[400],
                                      child: Icon(
                                        Icons.help_outline,
                                        size: 40,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.all(8),
                            child: Text(
                              isCollected ? mobName : '???',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: isCollected ? Colors.green[800] : Colors.grey[600],
                              ),
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 스페셜 캐릭터 탭 (special_image / special_mobs.csv)
  Widget _buildSpecialTab() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
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
                children: [
                  Text(
                    '스페셜 수집 진행률',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.amber[800],
                    ),
                  ),
                  const SizedBox(height: 10),
                  LinearProgressIndicator(
                    value: allSpecial.isEmpty ? 0 : collectedSpecial.length / allSpecial.length,
                    backgroundColor: Colors.grey[300],
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.amber[700]!),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    allSpecial.isEmpty
                        ? '0% 완료'
                        : '${(collectedSpecial.length / allSpecial.length * 100).toStringAsFixed(1)}% 완료',
                    style: TextStyle(
                      color: Colors.amber[700],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    '${collectedSpecial.length}/${allSpecial.length} (브레인 에너지 20칸 시 획득)',
                    style: TextStyle(
                      color: Colors.amber[800],
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: allSpecial.isEmpty
                  ? Center(
                      child: Text(
                        '스페셜 캐릭터가 없습니다.\nspecial_image 폴더를 확인해 주세요.',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    )
                  : GridView.builder(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        childAspectRatio: 0.8,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                      ),
                      itemCount: allSpecial.length,
                      itemBuilder: (context, index) {
                        final imagePath = allSpecial[index];
                        final isCollected = collectedSpecial.contains(imagePath);
                        final name = imagePath
                            .replaceFirst('special_image/', '')
                            .replaceAll('.webp', '')
                            .replaceAll('.png', '')
                            .replaceAll('.jpg', '');
                        return GestureDetector(
                          onTap: isCollected
                              ? () {
                                  final info = specialInfoMap[imagePath];
                                  final displayName = info?.name ?? name;
                                  showDialog(
                                    context: context,
                                    builder: (dialogContext) {
                                      final specialDialogKey = GlobalKey();
                                      return Dialog(
                                        insetPadding: const EdgeInsets.all(20),
                                        child: Container(
                                          width: double.maxFinite,
                                          padding: const EdgeInsets.all(20),
                                          child: SingleChildScrollView(
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                RepaintBoundary(
                                                  key: specialDialogKey,
                                                  child: Column(
                                                    mainAxisSize: MainAxisSize.min,
                                                    children: [
                                                      Text(
                                                        '⭐ $displayName',
                                                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                                              fontWeight: FontWeight.bold,
                                                              color: Colors.amber[800],
                                                            ),
                                                        textAlign: TextAlign.center,
                                                      ),
                                                      const SizedBox(height: 16),
                                                      _buildSpecialImage(imagePath, fit: BoxFit.contain, height: 200),
                                                      if (info != null) ...[
                                                        const SizedBox(height: 16),
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
                                                              const SizedBox(height: 6),
                                                              Text(
                                                                '레벨 ${specialLevels[imagePath] ?? 1}',
                                                                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.amber[800]),
                                                              ),
                                                              const SizedBox(height: 10),
                                                              Row(
                                                                children: [
                                                                  const Text('⚔️ 공격력: ', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                                                                  Text(info.attackPower, style: const TextStyle(fontSize: 14)),
                                                                ],
                                                              ),
                                                              const SizedBox(height: 6),
                                                              Row(
                                                                children: [
                                                                  const Text('❤️ 생명력: ', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                                                                  Text(info.health, style: const TextStyle(fontSize: 14)),
                                                                ],
                                                              ),
                                                              if (info.specialAbility.isNotEmpty) ...[
                                                                const SizedBox(height: 6),
                                                                Row(
                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                  children: [
                                                                    const Text('✨ 특수능력: ', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                                                                    Expanded(child: Text(info.specialAbility, style: const TextStyle(fontSize: 14))),
                                                                  ],
                                                                ),
                                                              ],
                                                              if (info.dropItems.isNotEmpty) ...[
                                                                const SizedBox(height: 10),
                                                                Text('🎁 드롭 아이템:', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.amber[800])),
                                                                const SizedBox(height: 4),
                                                                Container(
                                                                  padding: const EdgeInsets.all(10),
                                                                  decoration: BoxDecoration(
                                                                    color: Colors.amber[100],
                                                                    borderRadius: BorderRadius.circular(8),
                                                                    border: Border.all(color: Colors.amber[200]!),
                                                                  ),
                                                                  child: Text(info.dropItems, style: TextStyle(fontSize: 13, color: Colors.amber[800])),
                                                                ),
                                                              ],
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ],
                                                  ),
                                                ),
                                                const SizedBox(height: 15),
                                                ElevatedButton.icon(
                                                  onPressed: () => captureAndSaveCharacterInfo(specialDialogKey, displayName),
                                                  icon: const Icon(Icons.save_alt),
                                                  label: const Text('스페셜 정보 저장'),
                                                  style: ElevatedButton.styleFrom(
                                                    backgroundColor: Colors.amber[700],
                                                    foregroundColor: Colors.white,
                                                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                                  ),
                                                ),
                                                const SizedBox(height: 8),
                                                ElevatedButton(
                                                  onPressed: () => Navigator.pop(dialogContext),
                                                  child: const Text('닫기'),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                }
                              : null,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.3),
                                  spreadRadius: 1,
                                  blurRadius: 3,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                Expanded(
                                  child: ClipRRect(
                                    borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                                    child: isCollected
                                        ? _buildSpecialImage(imagePath, fit: BoxFit.contain, width: double.infinity)
                                        : Container(
                                            color: Colors.grey[400],
                                            child: Icon(Icons.lock_outline, size: 40, color: Colors.grey[600]),
                                          ),
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        isCollected ? name : '???',
                                        style: TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                          color: isCollected ? Colors.amber[800] : Colors.grey[600],
                                        ),
                                        textAlign: TextAlign.center,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      if (isCollected && (specialLevels[imagePath] ?? 0) > 0)
                                        Padding(
                                          padding: const EdgeInsets.only(top: 2),
                                          child: Text(
                                            '레벨 ${specialLevels[imagePath] ?? 1}',
                                            style: TextStyle(fontSize: 10, color: Colors.amber[700], fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
} 