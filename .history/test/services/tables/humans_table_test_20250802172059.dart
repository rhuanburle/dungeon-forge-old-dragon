// test/services/tables/humans_table_test.dart

import 'package:flutter_test/flutter_test.dart';
import '../../../lib/tables/humans_table.dart';
import '../../../lib/enums/table_enums.dart';

void main() {
  group('HumansTable', () {
    late HumansTable table;

    setUp(() {
      table = HumansTable();
    });

    test('should have correct table properties', () {
      expect(table.tableName, equals('Tabela A13.11 - Humanos e Semi-Humanos'));
      expect(
        table.description,
        equals('Tabela de humanos e semi-humanos por nível'),
      );
      expect(table.columnCount, equals(4));
      expect(table.difficultyLevel, equals(DifficultyLevel.medium));
    });

    test('should return correct values for beginners column', () {
      expect(table.getBeginners(1), equals(MonsterType.caveMen));
      expect(table.getBeginners(2), equals(MonsterType.cultists));
      expect(table.getBeginners(3), equals(MonsterType.noviceAdventurers));
      expect(table.getBeginners(4), equals(MonsterType.mercenaries));
      expect(table.getBeginners(5), equals(MonsterType.patrols));
      expect(table.getBeginners(6), equals(MonsterType.commonMen));
    });

    test('should return correct values for heroic column', () {
      expect(table.getHeroic(1), equals(MonsterType.caveMen));
      expect(table.getHeroic(2), equals(MonsterType.cultists));
      expect(table.getHeroic(3), equals(MonsterType.noviceAdventurers));
      expect(table.getHeroic(4), equals(MonsterType.mercenaries));
      expect(table.getHeroic(5), equals(MonsterType.patrols));
      expect(table.getHeroic(6), equals(MonsterType.commonMen));
      expect(table.getHeroic(7), equals(MonsterType.merchants));
      expect(table.getHeroic(8), equals(MonsterType.bandits));
      expect(table.getHeroic(9), equals(MonsterType.nobles));
      expect(table.getHeroic(10), equals(MonsterType.nomads));
    });

    test('should return correct values for advanced column', () {
      expect(table.getAdvanced(1), equals(MonsterType.caveMen));
      expect(table.getAdvanced(2), equals(MonsterType.cultists));
      expect(table.getAdvanced(3), equals(MonsterType.noviceAdventurers));
      expect(table.getAdvanced(4), equals(MonsterType.mercenaries));
      expect(table.getAdvanced(5), equals(MonsterType.patrols));
      expect(table.getAdvanced(6), equals(MonsterType.commonMen));
      expect(table.getAdvanced(7), equals(MonsterType.merchants));
      expect(table.getAdvanced(8), equals(MonsterType.bandits));
      expect(table.getAdvanced(9), equals(MonsterType.nobles));
      expect(table.getAdvanced(10), equals(MonsterType.nomads));
    });

    test('should return correct values for special column', () {
      expect(table.getSpecial(1), equals(MonsterType.caveMen));
      expect(table.getSpecial(2), equals(MonsterType.halflings));
      expect(table.getSpecial(3), equals(MonsterType.elves));
      expect(table.getSpecial(4), equals(MonsterType.fanatics));
      expect(table.getSpecial(5), equals(MonsterType.fanatics));
      expect(table.getSpecial(6), equals(MonsterType.berserkers));
      expect(table.getSpecial(7), equals(MonsterType.berserkers));
      expect(table.getSpecial(8), equals(MonsterType.dwarves));
      expect(table.getSpecial(9), equals(MonsterType.dwarves));
      expect(table.getSpecial(10), equals(MonsterType.gnomes));
    });

    test('should work with getByPartyLevel method', () {
      expect(
        table.getByPartyLevel(PartyLevel.beginners, 1),
        equals(MonsterType.caveMen),
      );
      expect(
        table.getByPartyLevel(PartyLevel.heroic, 1),
        equals(MonsterType.caveMen),
      );
      expect(
        table.getByPartyLevel(PartyLevel.advanced, 1),
        equals(MonsterType.caveMen),
      );
    });

    test('should work with getSpecialResult method', () {
      // Para rolls 2 e 10, deve retornar resultado especial
      expect(table.getSpecialResult(2), equals(MonsterType.halflings));
      expect(table.getSpecialResult(10), equals(MonsterType.gnomes));

      // Para outros rolls, deve retornar resultado normal
      expect(table.getSpecialResult(1), equals(MonsterType.caveMen));
      expect(table.getSpecialResult(3), equals(MonsterType.noviceAdventurers));
    });

    test('should throw error for invalid roll', () {
      expect(() => table.getBeginners(0), throwsArgumentError);
      expect(() => table.getBeginners(12), throwsArgumentError);
      expect(() => table.getHeroic(0), throwsArgumentError);
      expect(() => table.getHeroic(12), throwsArgumentError);
    });

    test('should return correct table info', () {
      final info = table.getTableInfo();
      expect(info, contains('Tabela A13.11 - Humanos e Semi-Humanos'));
      expect(info, contains('Tabela de humanos e semi-humanos por nível'));
      expect(info, contains('Colunas: 4'));
      expect(info, contains('Mediano'));
    });
  });
}
