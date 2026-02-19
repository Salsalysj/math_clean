import 'package:flutter/services.dart';

/// special_mobs.csv 한 행 정보 (공격력, 특수능력, 생명력, 드롭 아이템)
class SpecialInfo {
  final int id;
  final String name;       // 파일명(표시명)
  final String attackPower;
  final String specialAbility;
  final String health;
  final String dropItems;

  SpecialInfo({
    required this.id,
    required this.name,
    required this.attackPower,
    required this.specialAbility,
    required this.health,
    required this.dropItems,
  });
}

/// special_image/special_mobs.csv 에서 스페셜 캐릭터 이미지 경로 목록 로드.
/// CSV 컬럼: 번호, 파일명 (확장자 제외), 공격력, 특수능력, 생명력, 드롭 아이템
Future<List<String>> loadSpecialCharacterImagesFromCsv() async {
  try {
    final csv = await rootBundle.loadString('special_image/special_mobs.csv');
    final lines = csv.replaceAll('\r', '').split('\n').map((s) => s.trim()).where((s) => s.isNotEmpty).toList();
    if (lines.length < 2) return [];
    final result = <String>[];
    for (int i = 1; i < lines.length; i++) {
      final cols = _parseCsvLine(lines[i]);
      if (cols.length >= 2) {
        final fileName = cols[1].trim();
        if (fileName.isNotEmpty) {
          result.add('special_image/$fileName.png');
        }
      }
    }
    return result;
  } catch (e) {
    return [];
  }
}

/// CSV 한 줄 파싱 (쉼표 구분, 필드 내 쉼표 고려하지 않음)
List<String> _parseCsvLine(String line) {
  return line.split(',');
}

/// special_mobs.csv 전체 로드 후 이미지 경로 → SpecialInfo 맵 반환
Future<Map<String, SpecialInfo>> loadSpecialCharacterInfoFromCsv() async {
  final map = <String, SpecialInfo>{};
  try {
    final csv = await rootBundle.loadString('special_image/special_mobs.csv');
    final lines = csv.replaceAll('\r', '').split('\n').map((s) => s.trim()).where((s) => s.isNotEmpty).toList();
    if (lines.length < 2) return map;
    for (int i = 1; i < lines.length; i++) {
      final cols = _parseCsvLine(lines[i]);
      if (cols.length >= 6) {
        final id = int.tryParse(cols[0].trim()) ?? (i);
        final fileName = cols[1].trim();
        if (fileName.isEmpty) continue;
        final imagePath = 'special_image/$fileName.png';
        final dropItems = cols.length > 6 ? cols.sublist(5).join(',').trim() : cols[5].trim();
        map[imagePath] = SpecialInfo(
          id: id,
          name: fileName,
          attackPower: cols[2].trim(),
          specialAbility: cols[3].trim(),
          health: cols[4].trim(),
          dropItems: dropItems,
        );
      }
    }
  } catch (e) {}
  return map;
}
