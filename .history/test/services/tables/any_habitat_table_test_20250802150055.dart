// test/services/tables/any_habitat_table_test.dart

import 'package:flutter_test/flutter_test.dart';
import '../../../lib/tables/any_habitat_table.dart';
import '../../../lib/enums/table_enums.dart';

void main() {
  group('AnyHabitatTable', () {
    late AnyHabitatTable table;

    setUp(() {
      table = AnyHabitatTable();
    });

    test('should have correct table properties', () {
      expect(table.tableName, equals('Tabela A13.9 - Encontros em Qualquer Habitat'));
      expect(table.description, equals('Tabela de encontros para qualquer habitat'));
      expect(table.columnCount, equals(3));
      expect(table.difficultyLevel, equals(DifficultyLevel.challenging));
    });

    test('should return correct values for Any I column', () {
      expect(table.getAnyI(1), equals(MonsterType.drakold));
      expect(table.getAnyI(2), equals(MonsterType.goblin));
      expect(table.getAnyI(3), equals(MonsterType.orc));
      expect(table.getAnyI(4), equals(MonsterType.hobgoblin));
      expect(table.getAnyI(5), equals(TableReference.humansTable));
      expect(table.getAnyI(6), equals(MonsterType.zombie));
      expect(table.getAnyI(7), equals(MonsterType.ghoul));
      expect(table.getAnyI(8), equals(MonsterType.inhumano));
      expect(table.getAnyI(9), equals(MonsterType.shadow));
      expect(table.getAnyI(10), equals(MonsterType.homunculus));
      expect(table.getAnyI(11), equals(MonsterType.woodGolem));
      expect(table.getAnyI(12), equals(MonsterType.youngShadowDragon));
    });

    test('should return correct values for Any II column', () {
      expect(table.getAnyII(1), equals(MonsterType.wereRat));
      expect(table.getAnyII(2), equals(MonsterType.ogre));
      expect(table.getAnyII(3), equals(MonsterType.gargoyle));
      expect(table.getAnyII(4), equals(MonsterType.wereBoar));
      expect(table.getAnyII(5), equals(TableReference.humansTable));
      expect(table.getAnyII(6), equals(MonsterType.medusa2));
      expect(table.getAnyII(7), equals(MonsterType.wereCat));
      expect(table.getAnyII(8), equals(MonsterType.apparition));
      expect(table.getAnyII(9), equals(MonsterType.specter));
      expect(table.getAnyII(10), equals(MonsterType.troll));
      expect(table.getAnyII(11), equals(MonsterType.banshee));
      expect(table.getAnyII(12), equals(MonsterType.shadowDragon));
    });

    test('should return correct values for Any III column', () {
      expect(table.getAnyIII(1), equals(MonsterType.witch));
      expect(table.getAnyIII(2), equals(MonsterType.deathKnight2));
      expect(table.getAnyIII(3), equals(MonsterType.boneGolem));
      expect(table.getAnyIII(4), equals(MonsterType.fleshGolem2));
      expect(table.getAnyIII(5), equals(TableReference.humansTable));
      expect(table.getAnyIII(6), equals(MonsterType.ghost));
      expect(table.getAnyIII(7), equals(MonsterType.stoneGolem2));
      expect(table.getAnyIII(8), equals(MonsterType.stormGiant));
      expect(table.getAnyIII(9), equals(MonsterType.ironGolem));
      expect(table.getAnyIII(10), equals(MonsterType.lich));
      expect(table.getAnyIII(11), equals(MonsterType.annihilationSphere));
      expect(table.getAnyIII(12), equals(MonsterType.oldShadowDragon));
    });

    test('should work with getByPartyLevel method', () {
      expect(table.getByPartyLevel(PartyLevel.beginners, 1), equals(MonsterType.drakold));
      expect(table.getByPartyLevel(PartyLevel.heroic, 1), equals(MonsterType.wereRat));
      expect(table.getByPartyLevel(PartyLevel.advanced, 1), equals(MonsterType.witch));
    });

    test('should throw error for invalid roll', () {
      expect(() => table.getAnyI(0), throwsArgumentError);
      expect(() => table.getAnyI(13), throwsArgumentError);
      expect(() => table.getAnyII(0), throwsArgumentError);
      expect(() => table.getAnyII(13), throwsArgumentError);
    });

    test('should return correct table info', () {
      final info = table.getTableInfo();
      expect(info, contains('Tabela A13.9 - Encontros em Qualquer Habitat'));
      expect(info, contains('Tabela de encontros para qualquer habitat'));
      expect(info, contains('Colunas: 3'));
      expect(info, contains('Desafiador'));
    });
  });
} 